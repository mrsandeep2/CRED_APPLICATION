<?php

namespace Sandeepkumar\CredApp\Controllers;

use DateTime;
use Smarty\Smarty;
use Sandeepkumar\CredApp\Core\Database;
use Sandeepkumar\CredApp\Helpers\FinancialHelper;
use Sandeepkumar\CredApp\Models\CreditCard;
use Sandeepkumar\CredApp\Models\Bill;
use Sandeepkumar\CredApp\Models\Payment;

class DashboardController
{
    private CreditCard $creditCard;
    private Bill $bill;
    private Payment $payment;

    public function __construct(
        private Smarty $smarty,
        Database $database
    ) {
        $this->creditCard = new CreditCard($database);
        $this->bill = new Bill($database);
        $this->payment = new Payment($database);
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
        
        $userCards = $this->creditCard->findByUserId($userId);
        $cardCount = count($userCards);
        $pendingPerCard = $this->bill->getPendingTotalsPerCard($userId);

        $totalCreditLimit = 0.0;
        $totalOutstanding = 0.0;
        $totalAvailableCredit = 0.0;

        foreach ($userCards as $c) {
            $limitFloat = (float)($c['credit_limit'] ?? 0);
            $cardId = (int)$c['id'];
            $outstandingFloat = $pendingPerCard[$cardId] ?? 0.0;
            $avail = FinancialHelper::calculateAvailableCredit($limitFloat, $outstandingFloat);

            $totalCreditLimit += $limitFloat;
            $totalOutstanding += $outstandingFloat;
            $totalAvailableCredit += $avail;
        }

        $totalDueAmount = $this->bill->getTotalDueByUserId($userId);
        $paidBillsCount = $this->bill->getPaidCountByUserId($userId);
        $rawBills = $this->bill->findByUserId($userId);

        $today = new DateTime('today');
        $formattedBills = [];
        $pendingBillsCount = 0;

        foreach ($rawBills as $bill) {
            $rawNumber = $bill['card_number'] ?? '';
            $last4 = substr($rawNumber, -4);
            $maskedNumber = '•••• •••• •••• ' . ($last4 ?: '••••');
            
            $amountFloat = (float)$bill['amount'];
            $paidFloat = (float)($bill['paid_amount'] ?? 0.00);
            $remainingFloat = max(0.00, round($amountFloat - $paidFloat, 2));
            $minDueFloat = FinancialHelper::calculateMinimumDue($remainingFloat);

            $derivedStatus = FinancialHelper::getDerivedStatementStatus(
                $bill['status'],
                $bill['due_date'],
                $amountFloat,
                $paidFloat
            );

            $dueDateTimestamp = strtotime($bill['due_date']);
            $formattedDueDate = $dueDateTimestamp ? date('d M Y', $dueDateTimestamp) : $bill['due_date'];

            // Smart Urgency Analysis
            $dueDateObj = new DateTime($bill['due_date']);
            $diffDays = (int)$today->diff($dueDateObj)->format('%r%a');

            if ($derivedStatus['code'] === 'paid') {
                $urgency = 'paid';
                $urgencyBadge = 'Paid';
                $urgencyClass = 'success';
                $urgencyText = 'Settled & Cleared';
            } elseif ($derivedStatus['code'] === 'overdue') {
                $pendingBillsCount++;
                $daysPast = abs($diffDays);
                $urgency = 'overdue';
                $urgencyBadge = 'Overdue';
                $urgencyClass = 'danger';
                $urgencyText = 'Overdue by ' . $daysPast . ($daysPast === 1 ? ' day' : ' days');
            } elseif ($derivedStatus['code'] === 'partially_paid') {
                $pendingBillsCount++;
                $urgency = 'partially_paid';
                $urgencyBadge = 'Partially Paid';
                $urgencyClass = 'info';
                $urgencyText = 'Remaining: ₹' . number_format($remainingFloat, 2);
            } else {
                $pendingBillsCount++;
                if ($diffDays === 0) {
                    $urgency = 'due_today';
                    $urgencyBadge = 'Due Today';
                    $urgencyClass = 'danger';
                    $urgencyText = 'Due Today!';
                } elseif ($diffDays <= 3 && $diffDays > 0) {
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

            $txnRef = 'TXN-CRED-' . str_pad((string)$bill['id'], 6, '0', STR_PAD_LEFT) . '-' . strtoupper(substr(md5($bill['id'] . ($bill['created_at'] ?? 'cred')), 0, 4));

            $formattedBills[] = [
                'id'                  => (int)$bill['id'],
                'card_id'             => (int)$bill['card_id'],
                'card'                => $bill['bank_name'] . ($last4 ? ' (•••• ' . $last4 . ')' : ''),
                'bank_name'           => $bill['bank_name'],
                'card_holder'         => $bill['card_holder'],
                'masked_card_number'  => $maskedNumber,
                'amount'              => number_format($amountFloat, 2),
                'raw_amount'          => $amountFloat,
                'paid_amount'         => number_format($paidFloat, 2),
                'raw_paid_amount'     => $paidFloat,
                'remaining_amount'    => number_format($remainingFloat, 2),
                'raw_remaining_amount'=> $remainingFloat,
                'min_due'             => number_format($minDueFloat, 2),
                'raw_min_due'         => $minDueFloat,
                'due_date'            => $formattedDueDate,
                'status'              => $bill['status'],
                'derived_code'        => $derivedStatus['code'],
                'derived_label'       => $derivedStatus['label'],
                'derived_badge'       => $derivedStatus['badge_class'],
                'urgency'             => $urgency,
                'urgency_badge'       => $urgencyBadge,
                'urgency_class'       => $urgencyClass,
                'urgency_text'        => $urgencyText,
                'txn_ref'             => $txnRef,
                'settlement_date'     => date('d M Y, h:i A')
            ];
        }

        // Ensure legacy paid statements are synchronized in the authoritative payment ledger
        $this->payment->syncLegacyPaidBills();

        $totalPaid = $this->payment->getTotalPaidByUserId($userId);
        $totalCashback = $this->payment->getTotalCashbackByUserId($userId);
        $totalRewardPoints = (int)($totalPaid * 10);

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('name', $_SESSION['user_name'] ?? 'Member');
        $this->smarty->assign('year', date('Y'));

        $this->smarty->assign('total_due', number_format($totalDueAmount, 2));
        $this->smarty->assign('total_credit_limit', number_format($totalCreditLimit, 2));
        $this->smarty->assign('total_available_credit', number_format($totalAvailableCredit, 2));
        $this->smarty->assign('total_cashback', number_format($totalCashback, 2));
        $this->smarty->assign('total_reward_points', number_format($totalRewardPoints));
        $this->smarty->assign('card_count', $cardCount);
        $this->smarty->assign('paid_bills', $paidBillsCount);
        $this->smarty->assign('pending_bills', $pendingBillsCount);
        $this->smarty->assign('bills', $formattedBills);
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('dashboard/index.tpl');
    }
}
