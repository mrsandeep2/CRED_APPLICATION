<?php

namespace Sandeepkumar\CredApp\Helpers;

class FinancialHelper
{
    /**
     * Calculate the Minimum Amount Due for a credit card statement.
     * Demo rule used for this application: 5% of statement remaining amount, minimum ₹250.
     */
    public static function calculateMinimumDue(float $totalAmount): float
    {
        if ($totalAmount <= 0) {
            return 0.00;
        }

        if ($totalAmount <= 250.00) {
            return round($totalAmount, 2);
        }

        $fivePercent = $totalAmount * 0.05;
        $minDue = max(250.00, $fivePercent);

        return min(round($totalAmount, 2), round($minDue, 2));
    }

    /**
     * Calculate available revolving credit on a card.
     * Available Credit = max(0, Credit Limit - Current Outstanding)
     */
    public static function calculateAvailableCredit(float $creditLimit, float $currentOutstanding): float
    {
        if ($creditLimit <= 0) {
            return 0.00;
        }

        return max(0.00, round($creditLimit - $currentOutstanding, 2));
    }

    /**
     * Check if a statement is overdue based on due date and remaining balance.
     * Note: Overdue is dynamically derived from due date + remaining balance.
     */
    public static function isOverdue(string $dueDate, float $remainingAmount): bool
    {
        if ($remainingAmount <= 0) {
            return false;
        }

        $today = date('Y-m-d');
        return $dueDate < $today;
    }

    /**
     * Determine derived statement status, label, and badge class.
     * 
     * @param string $storedStatus Stored enum: 'pending', 'partially_paid', 'paid'
     * @param string $dueDate Format: 'YYYY-MM-DD'
     * @param float $amount Total statement amount
     * @param float $paidAmount Cumulative allocated paid amount
     * @return array{code: string, label: string, badge_class: string, is_overdue: bool, remaining_amount: float}
     */
    public static function getDerivedStatementStatus(
        string $storedStatus,
        string $dueDate,
        float $amount,
        float $paidAmount
    ): array {
        $remaining = max(0.00, round($amount - $paidAmount, 2));
        $isOverdue = self::isOverdue($dueDate, $remaining);

        if ($remaining <= 0 || $storedStatus === 'paid') {
            return [
                'code' => 'paid',
                'label' => 'Settled & Paid',
                'badge_class' => 'bg-success-subtle text-success-emphasis border border-success-subtle',
                'is_overdue' => false,
                'remaining_amount' => 0.00
            ];
        }

        if ($isOverdue) {
            return [
                'code' => 'overdue',
                'label' => 'Overdue Statement',
                'badge_class' => 'bg-danger text-white border border-danger',
                'is_overdue' => true,
                'remaining_amount' => $remaining
            ];
        }

        if ($paidAmount > 0 || $storedStatus === 'partially_paid') {
            return [
                'code' => 'partially_paid',
                'label' => 'Partially Paid',
                'badge_class' => 'bg-info-subtle text-info-emphasis border border-info-subtle',
                'is_overdue' => false,
                'remaining_amount' => $remaining
            ];
        }

        return [
            'code' => 'pending',
            'label' => 'Pending Due',
            'badge_class' => 'bg-warning-subtle text-warning-emphasis border border-warning-subtle',
            'is_overdue' => false,
            'remaining_amount' => $remaining
        ];
    }

    /**
     * Calculate Credit Card Utilization metrics with over-limit detection.
     */
    public static function calculateUtilization(float $creditLimit, float $currentOutstanding): array
    {
        if ($creditLimit <= 0) {
            $percent = $currentOutstanding > 0 ? 100.0 : 0.0;
            return [
                'percentage' => $percent,
                'formatted_percentage' => number_format($percent, 1) . '%',
                'is_overlimit' => $currentOutstanding > 0,
                'health_status' => 'overlimit',
                'health_label' => 'No Limit Configured',
                'badge_class' => 'bg-danger-subtle text-danger border border-danger-subtle',
                'bar_class' => 'bg-danger',
                'progress_width' => min(100.0, $percent)
            ];
        }

        $rawPercent = ($currentOutstanding / $creditLimit) * 100;
        $percent = round($rawPercent, 1);
        $isOverlimit = $currentOutstanding > $creditLimit;

        if ($isOverlimit) {
            $healthStatus = 'overlimit';
            $healthLabel = 'Over-Limit Alert';
            $badgeClass = 'bg-danger text-white border border-danger';
            $barClass = 'bg-danger progress-bar-striped progress-bar-animated';
            $progressWidth = 100.0;
        } elseif ($percent > 70.0) {
            $healthStatus = 'high';
            $healthLabel = 'High Utilization';
            $badgeClass = 'bg-danger-subtle text-danger border border-danger-subtle';
            $barClass = 'bg-danger';
            $progressWidth = $percent;
        } elseif ($percent > 30.0) {
            $healthStatus = 'moderate';
            $healthLabel = 'Moderate Utilization';
            $badgeClass = 'bg-warning-subtle text-warning-emphasis border border-warning-subtle';
            $barClass = 'bg-warning';
            $progressWidth = $percent;
        } elseif ($percent > 0.0) {
            $healthStatus = 'healthy';
            $healthLabel = 'Optimal Utilization';
            $badgeClass = 'bg-success-subtle text-success-emphasis border border-success-subtle';
            $barClass = 'bg-success';
            $progressWidth = max(4.0, $percent);
        } else {
            $healthStatus = 'zero';
            $healthLabel = '0% Utilized (100% Available)';
            $badgeClass = 'bg-success-subtle text-success-emphasis border border-success-subtle';
            $barClass = 'bg-success';
            $progressWidth = 0.0;
        }

        return [
            'percentage' => $percent,
            'formatted_percentage' => $percent . '%',
            'is_overlimit' => $isOverlimit,
            'health_status' => $healthStatus,
            'health_label' => $healthLabel,
            'badge_class' => $badgeClass,
            'bar_class' => $barClass,
            'progress_width' => $progressWidth
        ];
    }
}
