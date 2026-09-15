<?php

namespace Sandeepkumar\CredApp\Models;

use PDO;
use DomainException;
use InvalidArgumentException;
use RuntimeException;
use Sandeepkumar\CredApp\Core\Database;

class Payment
{
    private PDO $db;

    public function __construct(Database $database)
    {
        $this->db = $database->getConnection();
    }

    /**
     * Validate payment state machine transitions
     * 
     * Valid transitions:
     *   null -> created, processing
     *   created -> processing, failed
     *   processing -> success, failed
     *   success -> refunded, reversed
     * 
     * @throws DomainException if transition is prohibited
     */
    public static function validateTransition(?string $currentStatus, string $newStatus): bool
    {
        $validStatuses = ['created', 'processing', 'success', 'failed', 'refunded', 'reversed'];
        if (!in_array($newStatus, $validStatuses, true)) {
            throw new InvalidArgumentException("Invalid target status: {$newStatus}");
        }

        if ($currentStatus === null) {
            if (in_array($newStatus, ['created', 'processing', 'success', 'failed'], true)) {
                return true;
            }
            throw new DomainException("Initial payment status cannot be '{$newStatus}'.");
        }

        $allowedTransitions = [
            'created'    => ['processing', 'failed'],
            'processing' => ['success', 'failed'],
            'success'    => ['refunded', 'reversed'],
            'failed'     => [], // Terminal state
            'refunded'   => [], // Terminal state
            'reversed'   => [], // Terminal state
        ];

        if (!isset($allowedTransitions[$currentStatus]) || !in_array($newStatus, $allowedTransitions[$currentStatus], true)) {
            throw new DomainException("Prohibited state transition from '{$currentStatus}' to '{$newStatus}'.");
        }

        return true;
    }

    /**
     * Append an immutable event record to payment_events (Append-only audit ledger)
     */
    public function addEvent(int $paymentId, string $eventType, float $amount, ?string $notes = null): int
    {
        $stmt = $this->db->prepare(
            'INSERT INTO payment_events (payment_id, event_type, amount, notes)
             VALUES (:payment_id, :event_type, :amount, :notes)'
        );

        $stmt->execute([
            'payment_id' => $paymentId,
            'event_type' => $eventType,
            'amount'     => $amount,
            'notes'      => $notes
        ]);

        return (int)$this->db->lastInsertId();
    }

    /**
     * Retrieve all chronological state transition events for a payment
     */
    public function getEventsByPaymentId(int $paymentId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, payment_id, event_type, amount, notes, created_at
             FROM payment_events
             WHERE payment_id = :payment_id
             ORDER BY id ASC'
        );

        $stmt->execute(['payment_id' => $paymentId]);

        return $stmt->fetchAll();
    }

    /**
     * Create a payment allocation linking a payment to a statement/bill
     */
    public function createAllocation(int $paymentId, int $billId, float $amount, string $status = 'allocated'): int
    {
        if ($amount <= 0) {
            throw new InvalidArgumentException('Allocation amount must be strictly greater than 0.');
        }

        $stmt = $this->db->prepare(
            'INSERT INTO payment_allocations (payment_id, bill_id, allocated_amount, status)
             VALUES (:payment_id, :bill_id, :allocated_amount, :status)'
        );

        $stmt->execute([
            'payment_id'       => $paymentId,
            'bill_id'          => $billId,
            'allocated_amount' => $amount,
            'status'           => $status
        ]);

        return (int)$this->db->lastInsertId();
    }

    /**
     * Retrieve all allocations for a given payment
     */
    public function getAllocationsByPaymentId(int $paymentId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                pa.id,
                pa.payment_id,
                pa.bill_id,
                pa.allocated_amount,
                pa.status,
                pa.created_at,
                b.amount AS bill_total_amount,
                b.paid_amount AS bill_paid_amount,
                b.due_date AS bill_due_date,
                b.status AS bill_status
             FROM payment_allocations pa
             JOIN bills b ON pa.bill_id = b.id
             WHERE pa.payment_id = :payment_id
             ORDER BY pa.id ASC'
        );

        $stmt->execute(['payment_id' => $paymentId]);

        return $stmt->fetchAll();
    }

    /**
     * Retrieve all allocations for a specific statement/bill
     */
    public function getAllocationsByBillId(int $billId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                pa.id,
                pa.payment_id,
                pa.bill_id,
                pa.allocated_amount,
                pa.status,
                pa.created_at,
                p.transaction_id,
                p.payment_method,
                p.status AS payment_status
             FROM payment_allocations pa
             JOIN payments p ON pa.payment_id = p.id
             WHERE pa.bill_id = :bill_id
             ORDER BY pa.id DESC'
        );

        $stmt->execute(['bill_id' => $billId]);

        return $stmt->fetchAll();
    }

    /**
     * Retrieve payment by Idempotency Key (Duplicate request prevention)
     */
    public function findByIdempotencyKey(int $userId, string $idempotencyKey): ?array
    {
        if (empty($idempotencyKey)) {
            return null;
        }

        $stmt = $this->db->prepare(
            'SELECT 
                p.*,
                c.card_holder,
                c.bank_name,
                c.card_number
             FROM payments p
             LEFT JOIN credit_cards c ON p.card_id = c.id
             WHERE p.user_id = :user_id
               AND p.idempotency_key = :idempotency_key
             LIMIT 1'
        );

        $stmt->execute([
            'user_id'         => $userId,
            'idempotency_key' => $idempotencyKey
        ]);

        $result = $stmt->fetch();
        return $result ?: null;
    }

    /**
     * Insert a payment master record into payments table
     */
    public function create(
        int $userId,
        ?int $billId,
        int $cardId,
        string $transactionId,
        float $amount,
        string $paymentMethod,
        string $gatewayReference,
        string $status = 'processing',
        float $cashbackEarned = 0.00,
        ?string $idempotencyKey = null
    ): int {
        self::validateTransition(null, $status);

        $stmt = $this->db->prepare(
            'INSERT INTO payments 
                (user_id, bill_id, card_id, transaction_id, idempotency_key, amount, payment_method, gateway_reference, status, cashback_earned)
             VALUES 
                (:user_id, :bill_id, :card_id, :transaction_id, :idempotency_key, :amount, :payment_method, :gateway_reference, :status, :cashback_earned)'
        );

        $stmt->execute([
            'user_id'           => $userId,
            'bill_id'           => $billId, // Legacy compatibility
            'card_id'           => $cardId,
            'transaction_id'    => $transactionId,
            'idempotency_key'   => $idempotencyKey,
            'amount'            => $amount,
            'payment_method'    => $paymentMethod,
            'gateway_reference' => $gatewayReference,
            'status'            => $status,
            'cashback_earned'   => $cashbackEarned
        ]);

        $paymentId = (int)$this->db->lastInsertId();

        // Write initial audit events
        $this->addEvent($paymentId, 'created', $amount, 'Payment intent initiated');
        if ($status !== 'created') {
            $this->addEvent($paymentId, $status, $amount, "Payment set to {$status}");
        }

        return $paymentId;
    }

    /**
     * Retrieve a single payment scoped strictly by authenticated user
     */
    public function findById(int $id, int $userId): ?array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                p.id,
                p.user_id,
                p.bill_id,
                p.card_id,
                p.transaction_id,
                p.idempotency_key,
                p.amount,
                p.payment_method,
                p.gateway_reference,
                p.status,
                p.cashback_earned,
                p.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number,
                b.due_date AS bill_due_date,
                b.status AS bill_status
             FROM payments p
             LEFT JOIN credit_cards c ON p.card_id = c.id
             LEFT JOIN bills b ON p.bill_id = b.id
             WHERE p.id = :id
               AND p.user_id = :user_id
             LIMIT 1'
        );

        $stmt->execute([
            'id'      => $id,
            'user_id' => $userId
        ]);

        $payment = $stmt->fetch();
        if ($payment) {
            $payment['allocations'] = $this->getAllocationsByPaymentId((int)$payment['id']);
            $payment['events'] = $this->getEventsByPaymentId((int)$payment['id']);
        }

        return $payment ?: null;
    }

    /**
     * Retrieve a payment by transaction ID scoped strictly by user
     */
    public function findByTransactionId(string $transactionId, int $userId): ?array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                p.id,
                p.user_id,
                p.bill_id,
                p.card_id,
                p.transaction_id,
                p.idempotency_key,
                p.amount,
                p.payment_method,
                p.gateway_reference,
                p.status,
                p.cashback_earned,
                p.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number,
                b.due_date AS bill_due_date
             FROM payments p
             LEFT JOIN credit_cards c ON p.card_id = c.id
             LEFT JOIN bills b ON p.bill_id = b.id
             WHERE p.transaction_id = :transaction_id
               AND p.user_id = :user_id
             LIMIT 1'
        );

        $stmt->execute([
            'transaction_id' => $transactionId,
            'user_id'        => $userId
        ]);

        $payment = $stmt->fetch();
        if ($payment) {
            $payment['allocations'] = $this->getAllocationsByPaymentId((int)$payment['id']);
            $payment['events'] = $this->getEventsByPaymentId((int)$payment['id']);
        }

        return $payment ?: null;
    }

    /**
     * Return payment history for an authenticated user, newest first
     */
    public function findByUserId(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                p.id,
                p.user_id,
                p.bill_id,
                p.card_id,
                p.transaction_id,
                p.idempotency_key,
                p.amount,
                p.payment_method,
                p.gateway_reference,
                p.status,
                p.cashback_earned,
                p.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number,
                b.due_date AS bill_due_date
             FROM payments p
             LEFT JOIN credit_cards c ON p.card_id = c.id
             LEFT JOIN bills b ON p.bill_id = b.id
             WHERE p.user_id = :user_id
             ORDER BY p.created_at DESC, p.id DESC'
        );

        $stmt->execute([
            'user_id' => $userId
        ]);

        $rows = $stmt->fetchAll();
        foreach ($rows as &$row) {
            $row['allocations'] = $this->getAllocationsByPaymentId((int)$row['id']);
            $row['events'] = $this->getEventsByPaymentId((int)$row['id']);
        }

        return $rows;
    }

    /**
     * Execute full transaction settlement with Payment Allocations and Statement update
     * 
     * @param int $userId
     * @param int $cardId
     * @param float $totalAmount
     * @param string $paymentMethod
     * @param array<array{bill_id: int, amount: float}> $allocations
     * @param string|null $idempotencyKey
     * @param float $cashbackEarned
     * @return array Created payment record with allocations
     */
    public function processSettlementWithAllocations(
        int $userId,
        int $cardId,
        float $totalAmount,
        string $paymentMethod,
        array $allocations,
        ?string $idempotencyKey = null,
        float $cashbackEarned = 0.00
    ): array {
        if ($totalAmount <= 0) {
            throw new InvalidArgumentException('Total payment amount must be positive.');
        }

        // Financial invariant check 1: Allocations sum <= total payment amount
        $allocSum = 0.00;
        foreach ($allocations as $alloc) {
            $allocAmount = (float)$alloc['amount'];
            if ($allocAmount <= 0) {
                throw new InvalidArgumentException('Individual allocation amount must be greater than 0.');
            }
            $allocSum += $allocAmount;
        }

        if (round($allocSum, 2) > round($totalAmount, 2)) {
            throw new DomainException('Sum of payment allocations exceeds total payment amount.');
        }

        $transactionId = 'TXN-CRED-' . date('Ymd') . '-' . strtoupper(bin2hex(random_bytes(4)));
        $gatewayRef = 'GW-CRED-' . strtoupper(bin2hex(random_bytes(6)));

        $inTxn = $this->db->inTransaction();
        $savepoint = 'sp_settle_' . bin2hex(random_bytes(4));
        if ($inTxn) {
            $this->db->exec("SAVEPOINT {$savepoint}");
        } else {
            $this->db->beginTransaction();
        }

        try {
            // First bill ID for legacy column compatibility
            $legacyBillId = !empty($allocations) ? (int)$allocations[0]['bill_id'] : null;

            // 1. Create payment in 'processing' then transition to 'success'
            $paymentId = $this->create(
                $userId,
                $legacyBillId,
                $cardId,
                $transactionId,
                $totalAmount,
                $paymentMethod,
                $gatewayRef,
                'processing',
                $cashbackEarned,
                $idempotencyKey
            );

            // 2. Transition state to 'success'
            self::validateTransition('processing', 'success');
            $upStmt = $this->db->prepare('UPDATE payments SET status = :status WHERE id = :id');
            $upStmt->execute(['status' => 'success', 'id' => $paymentId]);
            $this->addEvent($paymentId, 'success', $totalAmount, 'Gateway settlement confirmed');

            // 3. Create discrete allocations and update statement balances
            foreach ($allocations as $alloc) {
                $bId = (int)$alloc['bill_id'];
                $aAmt = (float)$alloc['amount'];

                // Verify bill exists and belongs to user
                $bStmt = $this->db->prepare('SELECT id, amount, paid_amount, status, user_id FROM bills WHERE id = :id AND user_id = :user_id FOR UPDATE');
                $bStmt->execute(['id' => $bId, 'user_id' => $userId]);
                $billRow = $bStmt->fetch();

                if (!$billRow) {
                    throw new RuntimeException("Statement #{$bId} not found or access denied.");
                }

                $curPaid = (float)$billRow['paid_amount'];
                $billTotal = (float)$billRow['amount'];
                $remainingDue = max(0.00, round($billTotal - $curPaid, 2));

                // Financial invariant check 2: Allocation cannot exceed statement remaining due
                if (round($aAmt, 2) > round($remainingDue, 2)) {
                    throw new DomainException("Allocation of ₹{$aAmt} exceeds remaining due ₹{$remainingDue} on Statement #{$bId}.");
                }

                // Insert allocation row
                $this->createAllocation($paymentId, $bId, $aAmt, 'allocated');

                // Update statement cumulative paid amount and state
                $newPaid = round($curPaid + $aAmt, 2);
                $newStatus = ($newPaid >= $billTotal) ? 'paid' : 'partially_paid';

                $updBill = $this->db->prepare('UPDATE bills SET paid_amount = :paid_amount, status = :status WHERE id = :id');
                $updBill->execute([
                    'paid_amount' => $newPaid,
                    'status'      => $newStatus,
                    'id'          => $bId
                ]);
            }

            if ($inTxn) {
                $this->db->exec("RELEASE SAVEPOINT {$savepoint}");
            } else {
                $this->db->commit();
            }

            return $this->findById($paymentId, $userId);

        } catch (\Throwable $e) {
            if ($inTxn) {
                $this->db->exec("ROLLBACK TO SAVEPOINT {$savepoint}");
            } elseif ($this->db->inTransaction()) {
                $this->db->rollBack();
            }
            throw $e;
        }
    }

    /**
     * Non-destructive payment reversal / refund event simulation
     * 
     * 1. Validates current payment status is 'success'
     * 2. Appends 'reversed' / 'refunded' event to payment_events (zero rows deleted)
     * 3. Updates payment status to 'reversed' / 'refunded'
     * 4. Updates payment_allocations status to 'reversed'
     * 5. Decrements bills.paid_amount for each allocation and resets statement status
     * 
     * @param int $paymentId
     * @param int $userId
     * @param string $eventType 'reversed' or 'refunded'
     * @param string|null $reason
     * @return bool
     */
    public function reversePayment(
        int $paymentId,
        int $userId,
        string $eventType = 'reversed',
        ?string $reason = 'User simulated refund / reversal'
    ): bool {
        if (!in_array($eventType, ['reversed', 'refunded'], true)) {
            throw new InvalidArgumentException("Invalid reversal event type: {$eventType}");
        }

        $payment = $this->findById($paymentId, $userId);
        if (!$payment) {
            throw new RuntimeException('Payment record not found.');
        }

        if ($payment['status'] !== 'success') {
            throw new DomainException("Only successful payments can be reversed. Current status: {$payment['status']}.");
        }

        // Validate state machine transition
        self::validateTransition('success', $eventType);

        $inTxn = $this->db->inTransaction();
        $savepoint = 'sp_rev_' . bin2hex(random_bytes(4));
        if ($inTxn) {
            $this->db->exec("SAVEPOINT {$savepoint}");
        } else {
            $this->db->beginTransaction();
        }

        try {
            // 1. Append immutable event log
            $this->addEvent($paymentId, $eventType, (float)$payment['amount'], $reason);

            // 2. Update payment status to reversed
            $stmt = $this->db->prepare('UPDATE payments SET status = :status WHERE id = :id AND user_id = :user_id');
            $stmt->execute([
                'status'  => $eventType,
                'id'      => $paymentId,
                'user_id' => $userId
            ]);

            // 3. Update allocations status to reversed
            $allocStmt = $this->db->prepare('UPDATE payment_allocations SET status = :status WHERE payment_id = :payment_id');
            $allocStmt->execute([
                'status'     => 'reversed',
                'payment_id' => $paymentId
            ]);

            // 4. Restore statement balances
            $allocations = $this->getAllocationsByPaymentId($paymentId);
            foreach ($allocations as $alloc) {
                $billId = (int)$alloc['bill_id'];
                $allocatedAmount = (float)$alloc['allocated_amount'];

                $bStmt = $this->db->prepare('SELECT id, amount, paid_amount FROM bills WHERE id = :id FOR UPDATE');
                $bStmt->execute(['id' => $billId]);
                $billRow = $bStmt->fetch();

                if ($billRow) {
                    $curPaid = (float)$billRow['paid_amount'];
                    $totalAmt = (float)$billRow['amount'];
                    $newPaid = max(0.00, round($curPaid - $allocatedAmount, 2));
                    $newStatus = ($newPaid <= 0) ? 'pending' : 'partially_paid';

                    $upBill = $this->db->prepare('UPDATE bills SET paid_amount = :paid_amount, status = :status WHERE id = :id');
                    $upBill->execute([
                        'paid_amount' => $newPaid,
                        'status'      => $newStatus,
                        'id'          => $billId
                    ]);
                }
            }

            if ($inTxn) {
                $this->db->exec("RELEASE SAVEPOINT {$savepoint}");
            } else {
                $this->db->commit();
            }

            return true;

        } catch (\Throwable $e) {
            if ($inTxn) {
                $this->db->exec("ROLLBACK TO SAVEPOINT {$savepoint}");
            } elseif ($this->db->inTransaction()) {
                $this->db->rollBack();
            }
            throw $e;
        }
    }

    /**
     * Total lifetime payments made by user (successful payments only)
     */
    public function getTotalPaidByUserId(int $userId): float
    {
        $stmt = $this->db->prepare(
            'SELECT COALESCE(SUM(amount), 0) AS total_paid
             FROM payments
             WHERE user_id = :user_id
               AND status = :status'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status'  => 'success'
        ]);

        $result = $stmt->fetch();
        return (float)($result['total_paid'] ?? 0);
    }

    /**
     * Monthly spend in current month (successful payments only)
     */
    public function getMonthlySpend(int $userId): float
    {
        $stmt = $this->db->prepare(
            'SELECT COALESCE(SUM(amount), 0) AS monthly_spend
             FROM payments
             WHERE user_id = :user_id
               AND status = :status
               AND MONTH(created_at) = MONTH(CURRENT_DATE())
               AND YEAR(created_at) = YEAR(CURRENT_DATE())'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status'  => 'success'
        ]);

        $result = $stmt->fetch();
        return (float)($result['monthly_spend'] ?? 0);
    }

    /**
     * Total count of successful payments
     */
    public function getPaymentCountByUserId(int $userId): int
    {
        $stmt = $this->db->prepare(
            'SELECT COUNT(*) AS payment_count
             FROM payments
             WHERE user_id = :user_id
               AND status = :status'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status'  => 'success'
        ]);

        $result = $stmt->fetch();
        return (int)($result['payment_count'] ?? 0);
    }

    /**
     * Total count of all transaction attempts (success, processing, failed, reversed, refunded)
     */
    public function getTotalTransactionsCountByUserId(int $userId): int
    {
        $stmt = $this->db->prepare(
            'SELECT COUNT(*) AS total_count
             FROM payments
             WHERE user_id = :user_id'
        );

        $stmt->execute(['user_id' => $userId]);

        $result = $stmt->fetch();
        return (int)($result['total_count'] ?? 0);
    }

    /**
     * Total cashback earned from successful payments
     */
    public function getTotalCashbackByUserId(int $userId): float
    {
        $stmt = $this->db->prepare(
            'SELECT COALESCE(SUM(cashback_earned), 0) AS total_cashback
             FROM payments
             WHERE user_id = :user_id
               AND status = :status'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status'  => 'success'
        ]);

        $result = $stmt->fetch();
        return (float)($result['total_cashback'] ?? 0);
    }

    /**
     * Return successful payment totals and transaction counts grouped by payment method
     */
    public function getPaymentMethodBreakdown(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                payment_method,
                COUNT(*) AS txn_count,
                COALESCE(SUM(amount), 0) AS total_amount
             FROM payments
             WHERE user_id = :user_id
               AND status = :status
             GROUP BY payment_method'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status'  => 'success'
        ]);

        $rows = $stmt->fetchAll();
        $dbData = [];
        foreach ($rows as $row) {
            $dbData[$row['payment_method']] = [
                'count'  => (int)$row['txn_count'],
                'amount' => (float)$row['total_amount']
            ];
        }

        $allMethods = ['upi', 'netbanking', 'debit_card', 'cred_pay'];
        $methodLabels = [
            'upi'        => 'UPI',
            'netbanking' => 'Net Banking',
            'debit_card' => 'Debit Card',
            'cred_pay'   => 'CRED Pay'
        ];
        $methodIcons = [
            'upi'        => 'bi-qr-code-scan text-warning',
            'netbanking' => 'bi-bank text-primary',
            'debit_card' => 'bi-credit-card-2-back text-success',
            'cred_pay'   => 'bi-lightning-charge-fill text-warning'
        ];

        $totalPaid = $this->getTotalPaidByUserId($userId);
        $breakdown = [];

        foreach ($allMethods as $method) {
            $count = $dbData[$method]['count'] ?? 0;
            $amount = $dbData[$method]['amount'] ?? 0.00;
            $percentage = $totalPaid > 0 ? round(($amount / $totalPaid) * 100, 1) : 0.0;

            $breakdown[$method] = [
                'method'           => $method,
                'label'            => $methodLabels[$method],
                'icon'             => $methodIcons[$method],
                'count'            => $count,
                'amount'           => $amount,
                'formatted_amount' => number_format($amount, 2),
                'percentage'       => $percentage
            ];
        }

        return $breakdown;
    }

    /**
     * Return monthly payment trends for the last 6 months (successful payments only)
     */
    public function getMonthlyPaymentTrend(int $userId): array
    {
        $stmt = $this->db->prepare(
            "SELECT 
                DATE_FORMAT(created_at, '%Y-%m') AS month_key,
                DATE_FORMAT(created_at, '%b %Y') AS month_label,
                COALESCE(SUM(amount), 0) AS total_amount,
                COUNT(*) AS txn_count,
                COALESCE(SUM(cashback_earned), 0) AS total_cashback
             FROM payments
             WHERE user_id = :user_id
               AND status = 'success'
               AND created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 5 MONTH)
             GROUP BY DATE_FORMAT(created_at, '%Y-%m'), DATE_FORMAT(created_at, '%b %Y')
             ORDER BY month_key ASC"
        );

        $stmt->execute(['user_id' => $userId]);

        $rows = $stmt->fetchAll();
        $dbData = [];
        foreach ($rows as $row) {
            $dbData[$row['month_key']] = [
                'month_key'   => $row['month_key'],
                'month_label' => $row['month_label'],
                'amount'      => (float)$row['total_amount'],
                'count'       => (int)$row['txn_count'],
                'cashback'    => (float)$row['total_cashback']
            ];
        }

        $months = [];
        for ($i = 5; $i >= 0; $i--) {
            $timestamp = strtotime("-$i months");
            $key = date('Y-m', $timestamp);
            $label = date('M Y', $timestamp);

            if (isset($dbData[$key])) {
                $amount = $dbData[$key]['amount'];
                $count = $dbData[$key]['count'];
                $cashback = $dbData[$key]['cashback'];
            } else {
                $amount = 0.00;
                $count = 0;
                $cashback = 0.00;
            }

            $months[] = [
                'month_key'          => $key,
                'month_label'        => $label,
                'amount'             => $amount,
                'formatted_amount'   => number_format($amount, 2),
                'count'              => $count,
                'cashback'           => $cashback,
                'formatted_cashback' => number_format($cashback, 2)
            ];
        }

        return $months;
    }

    /**
     * Return recent successful payments with card details (user-scoped)
     */
    public function getRecentPayments(int $userId, int $limit = 5): array
    {
        $limit = max(1, min(50, $limit));
        $stmt = $this->db->prepare(
            'SELECT 
                p.id,
                p.user_id,
                p.bill_id,
                p.card_id,
                p.transaction_id,
                p.amount,
                p.payment_method,
                p.gateway_reference,
                p.status,
                p.cashback_earned,
                p.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number
             FROM payments p
             LEFT JOIN credit_cards c ON p.card_id = c.id
             WHERE p.user_id = :user_id
               AND p.status = :status
             ORDER BY p.created_at DESC, p.id DESC
             LIMIT ' . (int)$limit
        );

        $stmt->execute([
            'user_id' => $userId,
            'status'  => 'success'
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Deterministic cashback calculation helper
     * Rule: 1% of successful payment amount, rounded to 2 decimal places (minimum ₹5, max ₹100)
     */
    public static function calculateCashback(float $amount, string $status = 'success'): float
    {
        if ($status !== 'success' || $amount <= 0) {
            return 0.00;
        }

        return min(100.00, max(5.00, round($amount * 0.01, 2)));
    }

    /**
     * Synchronize legacy paid bills into the authoritative payments and allocations ledger
     * 
     * Finds any bill with paid_amount > 0 that has no corresponding payment_allocations,
     * and creates the authoritative payment, allocation, and event records.
     * 
     * @return int Number of legacy bills synchronized
     */
    public function syncLegacyPaidBills(): int
    {
        $stmt = $this->db->query(
            "SELECT b.id, b.user_id, b.card_id, b.amount, b.paid_amount, b.status, b.created_at
             FROM bills b
             WHERE b.paid_amount > 0
               AND NOT EXISTS (
                   SELECT 1 FROM payment_allocations pa WHERE pa.bill_id = b.id
               )"
        );

        $legacyBills = $stmt->fetchAll(PDO::FETCH_ASSOC);
        if (empty($legacyBills)) {
            return 0;
        }

        $syncedCount = 0;
        foreach ($legacyBills as $bill) {
            $billId = (int)$bill['id'];
            $userId = (int)$bill['user_id'];
            $cardId = (int)$bill['card_id'];
            $paidAmount = (float)$bill['paid_amount'];
            $createdAt = $bill['created_at'] ?? date('Y-m-d H:i:s');

            $cashback = self::calculateCashback($paidAmount, 'success');
            $txnId = 'TXN-CRED-' . date('Ymd', strtotime($createdAt)) . '-' . strtoupper(substr(md5((string)$billId), 0, 8));
            $gwRef = 'GW-LEGACY-' . str_pad((string)$billId, 6, '0', STR_PAD_LEFT);

            $inTxn = $this->db->inTransaction();
            $savepoint = 'sp_legacy_' . bin2hex(random_bytes(4));
            if ($inTxn) {
                $this->db->exec("SAVEPOINT {$savepoint}");
            } else {
                $this->db->beginTransaction();
            }

            try {
                // Insert payment record with legacy timestamp
                $pStmt = $this->db->prepare(
                    'INSERT INTO payments 
                        (user_id, bill_id, card_id, transaction_id, amount, payment_method, gateway_reference, status, cashback_earned, created_at)
                     VALUES 
                        (:user_id, :bill_id, :card_id, :transaction_id, :amount, :payment_method, :gateway_reference, :status, :cashback_earned, :created_at)'
                );
                $pStmt->execute([
                    'user_id'           => $userId,
                    'bill_id'           => $billId,
                    'card_id'           => $cardId,
                    'transaction_id'    => $txnId,
                    'amount'            => $paidAmount,
                    'payment_method'    => 'cred_pay',
                    'gateway_reference' => $gwRef,
                    'status'            => 'success',
                    'cashback_earned'   => $cashback,
                    'created_at'        => $createdAt
                ]);

                $paymentId = (int)$this->db->lastInsertId();

                // Create allocation
                $this->createAllocation($paymentId, $billId, $paidAmount, 'allocated');

                // Create events
                $this->addEvent($paymentId, 'created', $paidAmount, 'Historical statement settlement recorded');
                $this->addEvent($paymentId, 'success', $paidAmount, 'Historical settlement confirmed');

                if ($inTxn) {
                    $this->db->exec("RELEASE SAVEPOINT {$savepoint}");
                } else {
                    $this->db->commit();
                }

                $syncedCount++;
            } catch (\Throwable $e) {
                if ($inTxn) {
                    $this->db->exec("ROLLBACK TO SAVEPOINT {$savepoint}");
                } elseif ($this->db->inTransaction()) {
                    $this->db->rollBack();
                }
            }
        }

        return $syncedCount;
    }
}
