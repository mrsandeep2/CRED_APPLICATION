<?php

namespace Sandeepkumar\CredApp\Models;

use PDO;
use Sandeepkumar\CredApp\Core\Database;

class Payment
{
    private PDO $db;

    public function __construct(Database $database)
    {
        $this->db = $database->getConnection();
    }

    /**
     * Insert an immutable payment record into payments table
     */
    public function create(
        int $userId,
        int $billId,
        int $cardId,
        string $transactionId,
        float $amount,
        string $paymentMethod,
        string $gatewayReference,
        string $status = 'processing',
        float $cashbackEarned = 0.00
    ): int {
        $stmt = $this->db->prepare(
            'INSERT INTO payments 
                (user_id, bill_id, card_id, transaction_id, amount, payment_method, gateway_reference, status, cashback_earned)
             VALUES 
                (:user_id, :bill_id, :card_id, :transaction_id, :amount, :payment_method, :gateway_reference, :status, :cashback_earned)'
        );

        $stmt->execute([
            'user_id' => $userId,
            'bill_id' => $billId,
            'card_id' => $cardId,
            'transaction_id' => $transactionId,
            'amount' => $amount,
            'payment_method' => $paymentMethod,
            'gateway_reference' => $gatewayReference,
            'status' => $status,
            'cashback_earned' => $cashbackEarned
        ]);

        return (int)$this->db->lastInsertId();
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
            'id' => $id,
            'user_id' => $userId
        ]);

        $payment = $stmt->fetch();

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
            'user_id' => $userId
        ]);

        $payment = $stmt->fetch();

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

        return $stmt->fetchAll();
    }

    /**
     * Retrieve payment(s) associated with a bill, verifying user ownership
     */
    public function findByBillId(int $billId, int $userId): array
    {
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
                p.created_at
             FROM payments p
             WHERE p.bill_id = :bill_id
               AND p.user_id = :user_id
             ORDER BY p.id DESC'
        );

        $stmt->execute([
            'bill_id' => $billId,
            'user_id' => $userId
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Check whether a successful payment already exists for a bill (Duplicate payment prevention)
     */
    public function findSuccessfulByBillId(int $billId, int $userId): ?array
    {
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
                p.created_at
             FROM payments p
             WHERE p.bill_id = :bill_id
               AND p.user_id = :user_id
               AND p.status = :status
             LIMIT 1'
        );

        $stmt->execute([
            'bill_id' => $billId,
            'user_id' => $userId,
            'status' => 'success'
        ]);

        $payment = $stmt->fetch();

        return $payment ?: null;
    }

    /**
     * Prepare backend support for Phase 4.6 analytics: Monthly spend in current month
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
            'status' => 'success'
        ]);

        $result = $stmt->fetch();

        return (float)($result['monthly_spend'] ?? 0);
    }

    /**
     * Total lifetime payments made by user
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
            'status' => 'success'
        ]);

        $result = $stmt->fetch();

        return (float)($result['total_paid'] ?? 0);
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
            'status' => 'success'
        ]);

        $result = $stmt->fetch();

        return (int)($result['payment_count'] ?? 0);
    }

    /**
     * Total count of all transaction attempts (success, failed, processing)
     */
    public function getTotalTransactionsCountByUserId(int $userId): int
    {
        $stmt = $this->db->prepare(
            'SELECT COUNT(*) AS total_count
             FROM payments
             WHERE user_id = :user_id'
        );

        $stmt->execute([
            'user_id' => $userId
        ]);

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
            'status' => 'success'
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
            'status' => 'success'
        ]);

        $rows = $stmt->fetchAll();
        $dbData = [];
        foreach ($rows as $row) {
            $dbData[$row['payment_method']] = [
                'count' => (int)$row['txn_count'],
                'amount' => (float)$row['total_amount']
            ];
        }

        $allMethods = ['upi', 'netbanking', 'debit_card', 'cred_pay'];
        $methodLabels = [
            'upi' => 'UPI',
            'netbanking' => 'Net Banking',
            'debit_card' => 'Debit Card',
            'cred_pay' => 'CRED Pay'
        ];
        $methodIcons = [
            'upi' => 'bi-qr-code-scan text-warning',
            'netbanking' => 'bi-bank text-primary',
            'debit_card' => 'bi-credit-card-2-back text-success',
            'cred_pay' => 'bi-lightning-charge-fill text-warning'
        ];

        $totalPaid = $this->getTotalPaidByUserId($userId);
        $breakdown = [];

        foreach ($allMethods as $method) {
            $count = $dbData[$method]['count'] ?? 0;
            $amount = $dbData[$method]['amount'] ?? 0.00;
            $percentage = $totalPaid > 0 ? round(($amount / $totalPaid) * 100, 1) : 0.0;

            $breakdown[$method] = [
                'method' => $method,
                'label' => $methodLabels[$method],
                'icon' => $methodIcons[$method],
                'count' => $count,
                'amount' => $amount,
                'formatted_amount' => number_format($amount, 2),
                'percentage' => $percentage
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

        $stmt->execute([
            'user_id' => $userId
        ]);

        $rows = $stmt->fetchAll();
        $dbData = [];
        foreach ($rows as $row) {
            $dbData[$row['month_key']] = [
                'month_key' => $row['month_key'],
                'month_label' => $row['month_label'],
                'amount' => (float)$row['total_amount'],
                'count' => (int)$row['txn_count'],
                'cashback' => (float)$row['total_cashback']
            ];
        }

        // Generate full continuous 6-month timeline up to current month
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
                'month_key' => $key,
                'month_label' => $label,
                'amount' => $amount,
                'formatted_amount' => number_format($amount, 2),
                'count' => $count,
                'cashback' => $cashback,
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
            'status' => 'success'
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Deterministic cashback calculation helper
     * Rule: 1% of successful payment amount, rounded to 2 decimal places (minimum ₹5, max ₹100 or flat 1%)
     * Only successful payments earn cashback.
     */
    public static function calculateCashback(float $amount, string $status = 'success'): float
    {
        if ($status !== 'success' || $amount <= 0) {
            return 0.00;
        }

        return min(100.00, max(5.00, round($amount * 0.01, 2)));
    }
}
