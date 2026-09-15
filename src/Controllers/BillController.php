<?php

namespace Sandeepkumar\CredApp\Controllers;

use DateTime;
use Smarty\Smarty;
use Sandeepkumar\CredApp\Core\Database;
use Sandeepkumar\CredApp\Helpers\FinancialHelper;
use Sandeepkumar\CredApp\Models\Bill;
use Sandeepkumar\CredApp\Models\CreditCard;

class BillController
{
    private Bill $bill;
    private CreditCard $creditCard;

    public function __construct(
        private Smarty $smarty,
        Database $database
    ) {
        $this->bill = new Bill($database);
        $this->creditCard = new CreditCard($database);
    }

    public function index(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $rawBills = $this->bill->findByUserId($userId);
        $totalDue = $this->bill->getTotalDueByUserId($userId);
        $paidCount = $this->bill->getPaidCountByUserId($userId);

        $today = new DateTime('today');
        $formattedBills = [];
        $pendingCount = 0;

        foreach ($rawBills as $bill) {
            $rawNumber = $bill['card_number'] ?? '';
            $last4 = substr($rawNumber, -4);
            $maskedNumber = '•••• •••• •••• ' . ($last4 ?: '••••');

            $amountFloat = (float)$bill['amount'];
            $minDueFloat = FinancialHelper::calculateMinimumDue($amountFloat);

            $dueDateTimestamp = strtotime($bill['due_date']);
            $formattedDueDate = $dueDateTimestamp ? date('d M Y', $dueDateTimestamp) : $bill['due_date'];

            // Smart Urgency Analysis
            $dueDateObj = new DateTime($bill['due_date']);
            $diffDays = (int)$today->diff($dueDateObj)->format('%r%a');

            if ($bill['status'] === 'paid') {
                $urgency = 'paid';
                $urgencyBadge = 'Paid';
                $urgencyClass = 'success';
                $urgencyText = 'Settled & Cleared';
            } else {
                $pendingCount++;
                if ($diffDays < 0) {
                    $daysPast = abs($diffDays);
                    $urgency = 'overdue';
                    $urgencyBadge = 'Overdue';
                    $urgencyClass = 'danger';
                    $urgencyText = 'Overdue by ' . $daysPast . ($daysPast === 1 ? ' day' : ' days');
                } elseif ($diffDays === 0) {
                    $urgency = 'due_today';
                    $urgencyBadge = 'Due Today';
                    $urgencyClass = 'danger';
                    $urgencyText = 'Due Today!';
                } elseif ($diffDays <= 3) {
                    $urgency = 'due_soon';
                    $urgencyBadge = 'Due Soon';
                    $urgencyClass = 'warning';
                    $urgencyText = 'Due in ' . $diffDays . ($diffDays === 1 ? ' day' : ' days');
                } else {
                    $urgency = 'upcoming';
                    $urgencyBadge = 'Upcoming';
                    $urgencyClass = 'secondary';
                    $urgencyText = 'Due in ' . $diffDays . ' days';
                }
            }

            // Generate deterministic payment transaction ref for receipt
            $txnRef = 'TXN-CRED-' . str_pad((string)$bill['id'], 6, '0', STR_PAD_LEFT) . '-' . strtoupper(substr(md5($bill['id'] . ($bill['created_at'] ?? 'cred')), 0, 4));

            $formattedBills[] = [
                'id' => (int)$bill['id'],
                'card_id' => (int)$bill['card_id'],
                'card' => $bill['bank_name'] . ($last4 ? ' (•••• ' . $last4 . ')' : ''),
                'bank_name' => $bill['bank_name'],
                'card_holder' => $bill['card_holder'],
                'masked_card_number' => $maskedNumber,
                'amount' => number_format($amountFloat, 2),
                'raw_amount' => $amountFloat,
                'min_due' => number_format($minDueFloat, 2),
                'raw_min_due' => $minDueFloat,
                'due_date' => $formattedDueDate,
                'raw_due_date' => $bill['due_date'],
                'status' => $bill['status'],
                'urgency' => $urgency,
                'urgency_badge' => $urgencyBadge,
                'urgency_class' => $urgencyClass,
                'urgency_text' => $urgencyText,
                'txn_ref' => $txnRef,
                'settlement_date' => date('d M Y, h:i A')
            ];
        }

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('bills', $formattedBills);
        $this->smarty->assign('total_due', number_format($totalDue, 2));
        $this->smarty->assign('paid_bills', $paidCount);
        $this->smarty->assign('pending_bills', $pendingCount);
        $this->smarty->assign('all_count', count($formattedBills));
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('bills/index.tpl');
    }

    public function showAddForm(
        array $errors = [],
        array $old = []
    ): void {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $userCards = $this->creditCard->findByUserId($userId);

        foreach ($userCards as &$card) {
            $rawNumber = $card['card_number'] ?? '';
            $last4 = substr($rawNumber, -4);
            $card['masked_number'] = '•••• •••• •••• ' . ($last4 ?: '••••');
        }
        unset($card);

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('cards', $userCards);
        $this->smarty->assign('errors', $errors);
        $this->smarty->assign('old', $old);
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('bills/add.tpl');
    }

    public function handleAdd(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];

        $cardId = (int)($_POST['card_id'] ?? 0);
        $amount = trim($_POST['amount'] ?? '');
        $dueDate = trim($_POST['due_date'] ?? '');

        // Preserve non-sensitive form values for redisplay on validation error
        $old = [
            'card_id' => $cardId,
            'amount' => $amount,
            'due_date' => $dueDate
        ];

        $errors = [];

        // 1. Card ID & Ownership Validation
        if ($cardId <= 0) {
            $errors[] = 'Please select a valid credit card.';
        } else {
            $ownedCard = $this->creditCard->findById($cardId, $userId);
            if ($ownedCard === null) {
                $errors[] = 'The selected credit card is invalid or does not belong to your account.';
            }
        }

        // 2. Amount Validation
        if ($amount === '' || !is_numeric($amount) || (float)$amount <= 0) {
            $errors[] = 'Bill amount must be a positive numeric value greater than zero.';
        }

        // 3. Due Date Validation (YYYY-MM-DD format & valid calendar date)
        if ($dueDate === '') {
            $errors[] = 'Due date is required.';
        } else {
            $parsedDate = DateTime::createFromFormat('Y-m-d', $dueDate);
            if (!$parsedDate || $parsedDate->format('Y-m-d') !== $dueDate) {
                $errors[] = 'Due date must be a valid date in YYYY-MM-DD format.';
            }
        }

        if (!empty($errors)) {
            $this->showAddForm($errors, $old);
            return;
        }

        $this->bill->create(
            $userId,
            $cardId,
            (float)$amount,
            $dueDate
        );

        $_SESSION['flash_message'] = 'Credit card bill statement added successfully.';
        $_SESSION['flash_type'] = 'success';

        header('Location: /cred-app/public/bills');
        exit;
    }

    public function markAsPaid(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $billId = (int)($_POST['id'] ?? 0);

        if ($billId > 0) {
            $this->bill->markAsPaid($billId, $userId);
            $_SESSION['flash_message'] = 'Payment verified! Bill marked as settled and cleared.';
            $_SESSION['flash_type'] = 'success';
        }

        header('Location: /cred-app/public/bills');
        exit;
    }

    public function delete(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        if (!isset($_SESSION['user_id'])) {
            header('Location: /cred-app/public/login');
            exit;
        }

        $userId = (int)$_SESSION['user_id'];
        $billId = (int)($_POST['id'] ?? 0);

        if ($billId > 0) {
            $this->bill->delete($billId, $userId);
            $_SESSION['flash_message'] = 'Bill statement removed successfully.';
            $_SESSION['flash_type'] = 'info';
        }

        header('Location: /cred-app/public/bills');
        exit;
    }
}

