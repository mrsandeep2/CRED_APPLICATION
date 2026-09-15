<?php

namespace Sandeepkumar\CredApp\Controllers;

use DateTime;
use Smarty\Smarty;
use Sandeepkumar\CredApp\Core\Database;
use Sandeepkumar\CredApp\Models\Payment;
use Sandeepkumar\CredApp\Models\Bill;
use Sandeepkumar\CredApp\Models\CreditCard;
use Sandeepkumar\CredApp\Helpers\FinancialHelper;

class PaymentController
{
    private Payment $payment;
    private Bill $bill;
    private CreditCard $creditCard;
    private Database $database;

    public function __construct(
        private Smarty $smarty,
        Database $database
    ) {
        $this->database = $database;
        $this->payment = new Payment($database);
        $this->bill = new Bill($database);
        $this->creditCard = new CreditCard($database);
    }

    /**
     * Generate a unique application-level transaction ID
     */
    public function generateTransactionId(): string
    {
        $datePrefix = date('Ymd');
        $randomHex = strtoupper(bin2hex(random_bytes(4)));
        return 'TXN-CRED-' . $datePrefix . '-' . $randomHex;
    }

    /**
     * Generate a simulated gateway reference ID
     */
    public function generateGatewayReference(): string
    {
        return 'GW-CRED-' . strtoupper(bin2hex(random_bytes(6)));
    }

    /**
     * Generate an idempotency key for checkout duplicate protection
     */
    public function generateIdempotencyKey(): string
    {
        return 'IDEMP-' . date('Ymd') . '-' . bin2hex(random_bytes(12));
    }

    /**
     * Validate bill and card ownership and verify it is not already settled
     * 
     * @param int $billId
     * @param int $userId Strictly authenticated user ID
     * @return array{bill: array, card: array, remaining_due: float, min_due: float}|null Verified data payload or null
     */
    public function validateBillForPayment(int $billId, int $userId): ?array
    {
        if ($billId <= 0 || $userId <= 0) {
            return null;
        }

        // 1. Fetch bill and verify user ownership
        $bill = $this->bill->findById($billId);
        if ($bill === null || (int)($bill['user_id'] ?? 0) !== $userId) {
            return null;
        }

        $amount = (float)$bill['amount'];
        $paidAmount = (float)($bill['paid_amount'] ?? 0.00);
        $remainingDue = max(0.00, round($amount - $paidAmount, 2));

        // 2. Verify bill is not already fully settled/paid
        if (($bill['status'] ?? '') === 'paid' || $remainingDue <= 0.00) {
            return null;
        }

        // 3. Verify card belongs to the same authenticated user
        $cardId = (int)($bill['card_id'] ?? 0);
        $card = $this->creditCard->findById($cardId, $userId);
        if ($card === null || (int)($card['user_id'] ?? 0) !== $userId) {
            return null;
        }

        $minDue = FinancialHelper::calculateMinimumDue($remainingDue);

        return [
            'bill'          => $bill,
            'card'          => $card,
            'remaining_due' => $remainingDue,
            'min_due'       => $minDue
        ];
    }

    /**
     * Display the Interactive Payment Checkout Screen with Flexible Payment Options
     */
    public function showCheckout(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $billId = (int)($_GET['bill_id'] ?? 0);

        if ($billId <= 0) {
            $_SESSION['flash_message'] = 'Please select a valid bill statement for payment.';
            $_SESSION['flash_type'] = 'warning';
            header('Location: /cred-app/public/bills');
            exit;
        }

        // Verify bill & card ownership
        $validated = $this->validateBillForPayment($billId, $userId);
        if ($validated === null) {
            $existingBill = $this->bill->findById($billId);
            if ($existingBill !== null && (int)$existingBill['user_id'] === $userId && ($existingBill['status'] === 'paid' || (float)$existingBill['amount'] <= (float)$existingBill['paid_amount'])) {
                $_SESSION['flash_message'] = 'This bill statement has already been fully settled and paid.';
                $_SESSION['flash_type'] = 'info';
            } else {
                $_SESSION['flash_message'] = 'The selected bill could not be found or does not belong to your account.';
                $_SESSION['flash_type'] = 'danger';
            }
            header('Location: /cred-app/public/bills');
            exit;
        }

        $bill = $validated['bill'];
        $card = $validated['card'];
        $remainingDue = $validated['remaining_due'];
        $minDue = $validated['min_due'];

        // Mask card details
        $rawNumber = $card['card_number'] ?? '';
        $last4 = substr($rawNumber, -4);
        $maskedNumber = '•••• •••• •••• ' . ($last4 ?: '••••');

        // Due date formatting and urgency
        $dueDateTimestamp = strtotime($bill['due_date']);
        $formattedDueDate = $dueDateTimestamp ? date('d M Y', $dueDateTimestamp) : $bill['due_date'];

        $today = new DateTime('today');
        $dueDateObj = new DateTime($bill['due_date']);
        $diffDays = (int)$today->diff($dueDateObj)->format('%r%a');

        if ($diffDays < 0) {
            $urgencyBadge = 'Overdue by ' . abs($diffDays) . ' days';
            $urgencyClass = 'danger';
        } elseif ($diffDays === 0) {
            $urgencyBadge = 'Due Today!';
            $urgencyClass = 'danger';
        } elseif ($diffDays <= 3) {
            $urgencyBadge = 'Due in ' . $diffDays . ' days';
            $urgencyClass = 'warning';
        } else {
            $urgencyBadge = 'Upcoming Due';
            $urgencyClass = 'secondary';
        }

        $estimatedCashback = Payment::calculateCashback($remainingDue, 'success');
        $idempotencyKey = $this->generateIdempotencyKey();

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('bill', [
            'id'                  => (int)$bill['id'],
            'total_amount'        => number_format((float)$bill['amount'], 2),
            'paid_amount'         => number_format((float)($bill['paid_amount'] ?? 0), 2),
            'remaining_due'       => number_format($remainingDue, 2),
            'raw_remaining_due'   => $remainingDue,
            'raw_amount'          => (float)$bill['amount'],
            'min_due'             => number_format($minDue, 2),
            'raw_min_due'         => $minDue,
            'due_date'            => $formattedDueDate,
            'raw_due_date'        => $bill['due_date'],
            'urgency_badge'       => $urgencyBadge,
            'urgency_class'       => $urgencyClass,
            'bank_name'           => $card['bank_name'],
            'card_holder'         => $card['card_holder'],
            'masked_card_number'  => $maskedNumber,
            'card_id'             => (int)$card['id'],
            'estimated_cashback'  => number_format($estimatedCashback, 2),
            'idempotency_key'     => $idempotencyKey
        ]);

        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('payments/checkout.tpl');
    }

    /**
     * Handle Server-Side Payment Processing with Authoritative Validation & Allocations
     */
    public function processPayment(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $billId = (int)($_POST['bill_id'] ?? 0);
        $paymentOption = trim($_POST['payment_option'] ?? 'full');
        $customAmountInput = trim($_POST['custom_amount'] ?? '');
        $paymentMethod = trim($_POST['payment_method'] ?? '');
        $idempotencyKey = trim($_POST['idempotency_key'] ?? '');

        // 1. Idempotency Check (Duplicate request protection)
        if (!empty($idempotencyKey)) {
            $existingPayment = $this->payment->findByIdempotencyKey($userId, $idempotencyKey);
            if ($existingPayment !== null) {
                if ($existingPayment['status'] === 'success') {
                    $_SESSION['flash_message'] = 'Duplicate submission detected. Displaying existing verified payment.';
                    $_SESSION['flash_type'] = 'info';
                    header('Location: /cred-app/public/payments/success?txn=' . urlencode($existingPayment['transaction_id']));
                    exit;
                }
            }
        }

        // 2. Authoritative Bill & Card Validation
        $validated = $this->validateBillForPayment($billId, $userId);
        if ($validated === null) {
            $_SESSION['flash_message'] = 'Payment cannot be processed. Invalid bill statement or already settled.';
            $_SESSION['flash_type'] = 'danger';
            header('Location: /cred-app/public/bills');
            exit;
        }

        $bill = $validated['bill'];
        $card = $validated['card'];
        $remainingDue = $validated['remaining_due'];
        $minDue = $validated['min_due'];

        // 3. Determine Payment Amount Server-Side
        $payAmount = 0.00;
        $isBelowMinDue = false;

        if ($paymentOption === 'full') {
            $payAmount = $remainingDue;
        } elseif ($paymentOption === 'minimum') {
            $payAmount = $minDue;
        } elseif ($paymentOption === 'custom') {
            if (!is_numeric($customAmountInput)) {
                $_SESSION['flash_message'] = 'Please enter a valid numeric payment amount.';
                $_SESSION['flash_type'] = 'danger';
                header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
                exit;
            }
            $payAmount = round((float)$customAmountInput, 2);
        } else {
            $_SESSION['flash_message'] = 'Invalid payment option selected.';
            $_SESSION['flash_type'] = 'warning';
            header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
            exit;
        }

        // 4. Strict Financial Invariant Validation on Amount
        if ($payAmount <= 0.00) {
            $_SESSION['flash_message'] = 'Payment amount must be strictly greater than ₹0.00.';
            $_SESSION['flash_type'] = 'danger';
            header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
            exit;
        }

        if (round($payAmount, 2) > round($remainingDue, 2)) {
            $_SESSION['flash_message'] = "Payment amount (₹" . number_format($payAmount, 2) . ") cannot exceed the statement remaining due of ₹" . number_format($remainingDue, 2) . ".";
            $_SESSION['flash_type'] = 'danger';
            header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
            exit;
        }

        if ($payAmount < $minDue && $payAmount < $remainingDue) {
            $isBelowMinDue = true;
        }

        // 5. Validate Payment Method
        $validMethods = ['upi', 'netbanking', 'debit_card', 'cred_pay'];
        if (!in_array($paymentMethod, $validMethods, true)) {
            $_SESSION['flash_message'] = 'Please select a valid payment method.';
            $_SESSION['flash_type'] = 'warning';
            header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
            exit;
        }

        // 6. Method-Specific Validation
        $validationError = null;
        if ($paymentMethod === 'upi') {
            $upiId = trim($_POST['upi_id'] ?? '');
            if (empty($upiId) || !preg_match('/^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$/', $upiId)) {
                $validationError = 'Please provide a valid UPI ID (e.g. username@bank).';
            }
        } elseif ($paymentMethod === 'netbanking') {
            $bankCode = trim($_POST['bank_code'] ?? '');
            if (empty($bankCode)) {
                $validationError = 'Please select your Net Banking financial institution.';
            }
        } elseif ($paymentMethod === 'debit_card') {
            $cardNumber = str_replace([' ', '-'], '', trim($_POST['debit_card_number'] ?? ''));
            $expiry = trim($_POST['debit_expiry'] ?? '');
            $cvv = trim($_POST['debit_cvv'] ?? '');
            if (!preg_match('/^[0-9]{16}$/', $cardNumber) || empty($expiry) || !preg_match('/^[0-9]{3,4}$/', $cvv)) {
                $validationError = 'Please provide valid debit card credentials.';
            }
        } elseif ($paymentMethod === 'cred_pay') {
            $consent = $_POST['cred_pay_consent'] ?? '';
            if (empty($consent)) {
                $validationError = 'Please confirm CRED Pay authorization.';
            }
        }

        if ($validationError !== null) {
            $_SESSION['flash_message'] = $validationError;
            $_SESSION['flash_type'] = 'danger';
            header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
            exit;
        }

        // 7. Simulated Failure Handling
        $simulateFailure = (isset($_POST['simulate_failure']) && $_POST['simulate_failure'] === '1') || 
                           ($paymentMethod === 'upi' && str_contains(strtolower($_POST['upi_id'] ?? ''), 'fail'));

        if ($simulateFailure) {
            $transactionId = $this->generateTransactionId();
            $gatewayRef = $this->generateGatewayReference();

            $this->payment->create(
                $userId,
                $billId,
                (int)$card['id'],
                $transactionId,
                $payAmount,
                $paymentMethod,
                $gatewayRef,
                'failed',
                0.00,
                $idempotencyKey
            );

            $_SESSION['flash_message'] = 'Simulated payment was declined by the issuing gateway.';
            $_SESSION['flash_type'] = 'danger';

            header('Location: /cred-app/public/payments/failed?txn=' . urlencode($transactionId));
            exit;
        }

        // 8. Execute Atomic Settlement with Allocations
        $cashbackEarned = Payment::calculateCashback($payAmount, 'success');
        $allocations = [
            [
                'bill_id' => $billId,
                'amount'  => $payAmount
            ]
        ];

        try {
            $paymentRecord = $this->payment->processSettlementWithAllocations(
                $userId,
                (int)$card['id'],
                $payAmount,
                $paymentMethod,
                $allocations,
                $idempotencyKey,
                $cashbackEarned
            );

            $successMsg = 'Payment verified and allocated!';
            if ($isBelowMinDue) {
                $successMsg .= ' (Note: Payment is below Minimum Due; remaining balance remains outstanding).';
            }

            $_SESSION['flash_message'] = $successMsg;
            $_SESSION['flash_type'] = 'success';

            header('Location: /cred-app/public/payments/success?txn=' . urlencode($paymentRecord['transaction_id']));
            exit;

        } catch (\Throwable $e) {
            $_SESSION['flash_message'] = 'Transaction settlement failed: ' . $e->getMessage();
            $_SESSION['flash_type'] = 'danger';
            header('Location: /cred-app/public/payments/checkout?bill_id=' . $billId);
            exit;
        }
    }

    /**
     * Handle Non-Destructive Payment Reversal Action
     */
    public function reversePayment(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $paymentId = (int)($_POST['payment_id'] ?? 0);
        $reason = trim($_POST['reason'] ?? 'User simulated merchant reversal');

        if ($paymentId <= 0) {
            $_SESSION['flash_message'] = 'Invalid payment record selected for reversal.';
            $_SESSION['flash_type'] = 'danger';
            header('Location: /cred-app/public/payments/history');
            exit;
        }

        try {
            $this->payment->reversePayment($paymentId, $userId, 'reversed', $reason);

            $_SESSION['flash_message'] = 'Payment successfully reversed. Statement balance and card revolving credit restored.';
            $_SESSION['flash_type'] = 'success';

        } catch (\Throwable $e) {
            $_SESSION['flash_message'] = 'Payment reversal failed: ' . $e->getMessage();
            $_SESSION['flash_type'] = 'danger';
        }

        header('Location: /cred-app/public/payments/history');
        exit;
    }

    /**
     * Display Payment Success Confirmation Screen
     */
    public function showSuccess(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $txn = trim($_GET['txn'] ?? '');

        if (empty($txn)) {
            header('Location: /cred-app/public/bills');
            exit;
        }

        $payment = $this->payment->findByTransactionId($txn, $userId);
        if ($payment === null || $payment['status'] !== 'success') {
            header('Location: /cred-app/public/bills');
            exit;
        }

        $rawNumber = $payment['card_number'] ?? '';
        $last4 = substr($rawNumber, -4);
        $maskedNumber = '•••• •••• •••• ' . ($last4 ?: '••••');

        $methodLabels = [
            'upi'        => 'UPI (Unified Payments Interface)',
            'netbanking' => 'Net Banking',
            'debit_card' => 'Debit Card',
            'cred_pay'   => 'CRED Pay Instant'
        ];

        $paidTimestamp = strtotime($payment['created_at']);
        $formattedPaidDate = $paidTimestamp ? date('d M Y, h:i A', $paidTimestamp) : $payment['created_at'];

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('payment', [
            'id'                   => (int)$payment['id'],
            'transaction_id'       => $payment['transaction_id'],
            'gateway_reference'    => $payment['gateway_reference'],
            'amount'               => number_format((float)$payment['amount'], 2),
            'payment_method'       => $payment['payment_method'],
            'payment_method_label' => $methodLabels[$payment['payment_method']] ?? strtoupper($payment['payment_method']),
            'cashback_earned'      => number_format((float)$payment['cashback_earned'], 2),
            'reward_points'        => (int)((float)$payment['amount'] * 10),
            'paid_at'              => $formattedPaidDate,
            'bank_name'            => $payment['bank_name'],
            'card_holder'          => $payment['card_holder'],
            'masked_card'          => $maskedNumber,
            'allocations'          => $payment['allocations'] ?? [],
            'events'               => $payment['events'] ?? []
        ]);

        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('payments/success.tpl');
    }

    /**
     * Display Payment Failure Screen
     */
    public function showFailed(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $txn = trim($_GET['txn'] ?? '');

        if (empty($txn)) {
            header('Location: /cred-app/public/bills');
            exit;
        }

        $payment = $this->payment->findByTransactionId($txn, $userId);
        if ($payment === null) {
            header('Location: /cred-app/public/bills');
            exit;
        }

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('payment', [
            'transaction_id'    => $payment['transaction_id'],
            'gateway_reference' => $payment['gateway_reference'],
            'amount'            => number_format((float)$payment['amount'], 2),
            'bank_name'         => $payment['bank_name'] ?? 'Credit Card'
        ]);

        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('payments/failed.tpl');
    }

    /**
     * Display the Dedicated Payment History & Transaction Logs UI
     */
    public function showHistory(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $rawPayments = $this->payment->findByUserId($userId);

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

        $statusLabels = [
            'success'    => 'Success',
            'processing' => 'Processing',
            'failed'     => 'Failed',
            'reversed'   => 'Reversed',
            'refunded'   => 'Refunded'
        ];

        $statusBadgeClasses = [
            'success'    => 'bg-success-subtle text-success-emphasis border border-success-subtle',
            'processing' => 'bg-warning-subtle text-warning-emphasis border border-warning-subtle',
            'failed'     => 'bg-danger-subtle text-danger border border-danger-subtle',
            'reversed'   => 'bg-secondary text-white border border-secondary',
            'refunded'   => 'bg-info-subtle text-info-emphasis border border-info-subtle'
        ];

        $formattedPayments = [];
        $totalSettledAmount = 0.00;
        $totalCashbackEarned = 0.00;
        $successCount = 0;
        $processingCount = 0;
        $failedCount = 0;
        $reversedCount = 0;

        foreach ($rawPayments as $p) {
            $amountFloat = (float)$p['amount'];
            $cashbackFloat = (float)($p['cashback_earned'] ?? 0.00);
            $status = $p['status'] ?? 'success';

            if ($status === 'success') {
                $totalSettledAmount += $amountFloat;
                $totalCashbackEarned += $cashbackFloat;
                $successCount++;
            } elseif ($status === 'processing') {
                $processingCount++;
            } elseif ($status === 'failed') {
                $failedCount++;
            } elseif ($status === 'reversed' || $status === 'refunded') {
                $reversedCount++;
            }

            $rawCardNumber = $p['card_number'] ?? '';
            $last4 = substr($rawCardNumber, -4);
            $maskedCard = '•••• •••• •••• ' . ($last4 ?: '••••');

            $paidTimestamp = strtotime($p['created_at']);
            $formattedPaidDate = $paidTimestamp ? date('d M Y, h:i A', $paidTimestamp) : $p['created_at'];

            $formattedPayments[] = [
                'id'                   => (int)$p['id'],
                'user_id'              => (int)$p['user_id'],
                'card_id'              => (int)$p['card_id'],
                'transaction_id'       => $p['transaction_id'],
                'idempotency_key'      => $p['idempotency_key'],
                'amount'               => number_format($amountFloat, 2),
                'raw_amount'           => $amountFloat,
                'payment_method'       => $p['payment_method'],
                'payment_method_label' => $methodLabels[$p['payment_method']] ?? strtoupper($p['payment_method']),
                'payment_method_icon'  => $methodIcons[$p['payment_method']] ?? 'bi-credit-card',
                'gateway_reference'    => $p['gateway_reference'],
                'status'               => $status,
                'status_label'         => $statusLabels[$status] ?? ucfirst($status),
                'status_badge_class'   => $statusBadgeClasses[$status] ?? 'bg-secondary-subtle text-secondary',
                'can_reverse'          => ($status === 'success'),
                'cashback_earned'      => number_format($cashbackFloat, 2),
                'reward_points'        => (int)($amountFloat * 10),
                'paid_at'              => $formattedPaidDate,
                'bank_name'            => $p['bank_name'] ?? 'Card Statement',
                'card_holder'          => $p['card_holder'] ?? 'Account Holder',
                'masked_card'          => $maskedCard,
                'allocations'          => $p['allocations'] ?? [],
                'events'               => $p['events'] ?? []
            ];
        }

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('payments', $formattedPayments);
        $this->smarty->assign('all_count', count($formattedPayments));
        $this->smarty->assign('success_count', $successCount);
        $this->smarty->assign('processing_count', $processingCount);
        $this->smarty->assign('failed_count', $failedCount);
        $this->smarty->assign('reversed_count', $reversedCount);
        $this->smarty->assign('total_settled_amount', number_format($totalSettledAmount, 2));
        $this->smarty->assign('total_cashback_earned', number_format($totalCashbackEarned, 2));
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('payments/history.tpl');
    }

    /**
     * Display Payment Analytics & CRED Rewards Dashboard
     */
    public function showAnalytics(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];

        $totalPaid = $this->payment->getTotalPaidByUserId($userId);
        $monthlySpend = $this->payment->getMonthlySpend($userId);
        $successfulCount = $this->payment->getPaymentCountByUserId($userId);
        $totalAttempts = $this->payment->getTotalTransactionsCountByUserId($userId);
        $totalCashback = $this->payment->getTotalCashbackByUserId($userId);
        $methodBreakdown = $this->payment->getPaymentMethodBreakdown($userId);
        $monthlyTrend = $this->payment->getMonthlyPaymentTrend($userId);
        $rawRecentPayments = $this->payment->getRecentPayments($userId, 6);

        $avgTxnValue = $successfulCount > 0 ? ($totalPaid / $successfulCount) : 0.00;
        $totalRewardPoints = (int)($totalPaid * 10);

        $maxTrendAmount = 0.00;
        foreach ($monthlyTrend as $m) {
            if ($m['amount'] > $maxTrendAmount) {
                $maxTrendAmount = $m['amount'];
            }
        }
        $scaleMax = $maxTrendAmount > 0 ? $maxTrendAmount : 1.0;

        $trendChart = [];
        foreach ($monthlyTrend as $m) {
            $percentHeight = $maxTrendAmount > 0 ? round(($m['amount'] / $scaleMax) * 100) : 0;
            if ($m['amount'] > 0 && $percentHeight < 12) {
                $percentHeight = 12;
            }
            $trendChart[] = array_merge($m, [
                'bar_height_percent' => $percentHeight
            ]);
        }

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

        $formattedRecent = [];
        foreach ($rawRecentPayments as $p) {
            $rawCard = $p['card_number'] ?? '';
            $last4 = substr($rawCard, -4);
            $maskedCard = '•••• •••• •••• ' . ($last4 ?: '••••');

            $timestamp = strtotime($p['created_at']);
            $paidDate = $timestamp ? date('d M Y, h:i A', $timestamp) : $p['created_at'];

            $formattedRecent[] = [
                'id'                   => (int)$p['id'],
                'transaction_id'       => $p['transaction_id'],
                'gateway_reference'    => $p['gateway_reference'],
                'amount'               => number_format((float)$p['amount'], 2),
                'cashback_earned'      => number_format((float)$p['cashback_earned'], 2),
                'payment_method'       => $p['payment_method'],
                'payment_method_label' => $methodLabels[$p['payment_method']] ?? strtoupper($p['payment_method']),
                'payment_method_icon'  => $methodIcons[$p['payment_method']] ?? 'bi-credit-card',
                'bank_name'            => $p['bank_name'] ?? 'Card Account',
                'card_holder'          => $p['card_holder'] ?? 'Account Holder',
                'masked_card'          => $maskedCard,
                'paid_at'              => $paidDate
            ];
        }

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('total_paid', number_format($totalPaid, 2));
        $this->smarty->assign('raw_total_paid', $totalPaid);
        $this->smarty->assign('monthly_spend', number_format($monthlySpend, 2));
        $this->smarty->assign('raw_monthly_spend', $monthlySpend);
        $this->smarty->assign('successful_count', $successfulCount);
        $this->smarty->assign('total_attempts', $totalAttempts);
        $this->smarty->assign('total_cashback', number_format($totalCashback, 2));
        $this->smarty->assign('total_reward_points', number_format($totalRewardPoints));
        $this->smarty->assign('avg_txn_value', number_format($avgTxnValue, 2));
        $this->smarty->assign('method_breakdown', $methodBreakdown);
        $this->smarty->assign('trend_chart', $trendChart);
        $this->smarty->assign('recent_payments', $formattedRecent);
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('payments/analytics.tpl');
    }
}
