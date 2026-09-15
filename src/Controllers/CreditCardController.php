<?php

namespace Sandeepkumar\CredApp\Controllers;

use Smarty\Smarty;
use DateTime;
use Sandeepkumar\CredApp\Core\Database;
use Sandeepkumar\CredApp\Helpers\Validator;
use Sandeepkumar\CredApp\Helpers\FinancialHelper;
use Sandeepkumar\CredApp\Models\CreditCard;
use Sandeepkumar\CredApp\Models\Bill;

class CreditCardController
{
    private CreditCard $creditCard;
    private Bill $bill;

    public function __construct(
        private Smarty $smarty,
        Database $database
    ) {
        $this->creditCard = new CreditCard($database);
        $this->bill = new Bill($database);
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
        $cards = $this->creditCard->findByUserId($userId);
        $pendingPerCard = $this->bill->getPendingTotalsPerCard($userId);
        $latestBillsPerCard = $this->bill->getLatestBillsPerCard($userId);

        $totalCreditLimit = 0.0;
        $totalOutstanding = 0.0;
        $totalAvailableCredit = 0.0;
        $today = new DateTime('today');

        foreach ($cards as &$card) {
            $rawNumber = $card['card_number'] ?? '';
            $last4 = substr($rawNumber, -4);
            $card['masked_number'] = '•••• •••• •••• ' . ($last4 ?: '••••');

            $limitFloat = (float)($card['credit_limit'] ?? 0);
            $cardId = (int)$card['id'];
            $outstandingFloat = $pendingPerCard[$cardId] ?? 0.0;
            $availableFloat = FinancialHelper::calculateAvailableCredit($limitFloat, $outstandingFloat);
            $utilization = FinancialHelper::calculateUtilization($limitFloat, $outstandingFloat);

            $totalCreditLimit += $limitFloat;
            $totalOutstanding += $outstandingFloat;
            $totalAvailableCredit += $availableFloat;

            $card['raw_limit'] = $limitFloat;
            $card['raw_outstanding'] = $outstandingFloat;
            $card['raw_available'] = $availableFloat;
            $card['utilization'] = $utilization;
            $card['utilization_percent'] = $utilization['percentage'];

            $card['formatted_limit'] = number_format($limitFloat, 2);
            $card['formatted_outstanding'] = number_format($outstandingFloat, 2);
            $card['formatted_available'] = number_format($availableFloat, 2);
            $card['formatted_expiry'] = sprintf('%02d/%s', (int)$card['expiry_month'], substr((string)$card['expiry_year'], -2));

            // Attach latest statement information
            $latestBill = $latestBillsPerCard[$cardId] ?? null;
            if ($latestBill !== null) {
                $billAmountFloat = (float)$latestBill['amount'];
                $minDueFloat = FinancialHelper::calculateMinimumDue($billAmountFloat);

                $dueDateTimestamp = strtotime($latestBill['due_date']);
                $formattedDueDate = $dueDateTimestamp ? date('d M Y', $dueDateTimestamp) : $latestBill['due_date'];

                $dueDateObj = new DateTime($latestBill['due_date']);
                $diffDays = (int)$today->diff($dueDateObj)->format('%r%a');

                if ($latestBill['status'] === 'paid') {
                    $urgencyText = 'Settled & Paid';
                    $urgencyClass = 'success';
                } elseif ($diffDays < 0) {
                    $urgencyText = 'Overdue by ' . abs($diffDays) . ' days';
                    $urgencyClass = 'danger';
                } elseif ($diffDays === 0) {
                    $urgencyText = 'Due Today!';
                    $urgencyClass = 'danger';
                } elseif ($diffDays <= 3) {
                    $urgencyText = 'Due in ' . $diffDays . ' days';
                    $urgencyClass = 'warning';
                } else {
                    $urgencyText = 'Due in ' . $diffDays . ' days';
                    $urgencyClass = 'secondary';
                }

                $card['has_statement'] = true;
                $card['statement'] = [
                    'id' => (int)$latestBill['id'],
                    'status' => $latestBill['status'],
                    'amount' => number_format($billAmountFloat, 2),
                    'raw_amount' => $billAmountFloat,
                    'min_due' => number_format($minDueFloat, 2),
                    'raw_min_due' => $minDueFloat,
                    'due_date' => $formattedDueDate,
                    'urgency_text' => $urgencyText,
                    'urgency_class' => $urgencyClass
                ];
            } else {
                $card['has_statement'] = false;
                $card['statement'] = null;
            }
        }
        unset($card);

        $portfolioUtilization = FinancialHelper::calculateUtilization($totalCreditLimit, $totalOutstanding);

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('cards', $cards);
        $this->smarty->assign('card_count', count($cards));
        $this->smarty->assign('total_credit_limit', number_format($totalCreditLimit, 2));
        $this->smarty->assign('total_outstanding', number_format($totalOutstanding, 2));
        $this->smarty->assign('total_available', number_format($totalAvailableCredit, 2));
        $this->smarty->assign('portfolio_utilization', $portfolioUtilization);
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('cards/index.tpl');
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

        $flashMessage = $_SESSION['flash_message'] ?? null;
        $flashType = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);

        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('errors', $errors);
        $this->smarty->assign('old', $old);
        $this->smarty->assign('flash_message', $flashMessage);
        $this->smarty->assign('flash_type', $flashType);

        $this->smarty->display('cards/add.tpl');
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

        $cardHolderName = trim($_POST['card_holder_name'] ?? '');
        $bankName = trim($_POST['bank_name'] ?? '');
        $cardNumber = trim($_POST['card_number'] ?? '');
        $cleanCardNumber = str_replace([' ', '-'], '', $cardNumber);
        $expiryMonth = trim($_POST['expiry_month'] ?? '');
        $expiryYear = trim($_POST['expiry_year'] ?? '');
        $creditLimit = trim($_POST['credit_limit'] ?? '');

        // Preserve non-sensitive form values only (card number is excluded)
        $old = [
            'card_holder_name' => $cardHolderName,
            'bank_name' => $bankName,
            'expiry_month' => $expiryMonth,
            'expiry_year' => $expiryYear,
            'credit_limit' => $creditLimit
        ];

        $errors = [];

        if (!Validator::name($cardHolderName)) {
            $errors[] = 'Card holder name must contain only letters and spaces (2-100 characters).';
        }

        if (!Validator::bankName($bankName)) {
            $errors[] = 'Please enter a valid bank name.';
        }

        if (!Validator::cardNumber($cardNumber)) {
            $errors[] = 'Card number must be exactly 16 digits.';
        }

        if (!Validator::expiryMonth($expiryMonth)) {
            $errors[] = 'Expiry month must be between 1 and 12.';
        }

        if (!Validator::expiryYear($expiryYear)) {
            $errors[] = 'Expiry year must be the current year or later.';
        }

        if (Validator::expiryMonth($expiryMonth) && Validator::expiryYear($expiryYear)) {
            $currentYear = (int)date('Y');
            $currentMonth = (int)date('n');
            if ((int)$expiryYear === $currentYear && (int)$expiryMonth < $currentMonth) {
                $errors[] = 'The card expiry date cannot be in the past.';
            }
        }

        if (!Validator::creditLimit($creditLimit)) {
            $errors[] = 'Credit limit must be a positive numeric amount.';
        }

        if (!empty($errors)) {
            $this->showAddForm($errors, $old);
            return;
        }

        $userId = (int)$_SESSION['user_id'];

        $this->creditCard->create(
            $userId,
            $cardHolderName,
            $bankName,
            $cleanCardNumber,
            (int)$expiryMonth,
            (int)$expiryYear,
            $creditLimit
        );

        $_SESSION['flash_message'] = 'Credit card linked to your account successfully.';
        $_SESSION['flash_type'] = 'success';

        header('Location: /cred-app/public/cards');
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

        $id = (int)($_POST['id'] ?? 0);
        $userId = (int)$_SESSION['user_id'];

        if ($id > 0) {
            $this->creditCard->delete($id, $userId);
            $_SESSION['flash_message'] = 'Credit card removed successfully.';
            $_SESSION['flash_type'] = 'info';
        }

        header('Location: /cred-app/public/cards');
        exit;
    }
}

