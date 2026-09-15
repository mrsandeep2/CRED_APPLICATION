<?php

namespace Sandeepkumar\CredApp\Helpers;

class FinancialHelper
{
    /**
     * Calculate the Minimum Amount Due for a credit card statement.
     * Note: Minimum due calculation varies by card issuer and account terms.
     * Demo rule used for this application: 5% of statement amount, minimum ₹250.
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
     * Calculate Credit Card Utilization metrics with over-limit detection.
     * 
     * @param float $creditLimit
     * @param float $currentOutstanding
     * @return array{
     *   percentage: float,
     *   formatted_percentage: string,
     *   is_overlimit: bool,
     *   health_status: string,
     *   health_label: string,
     *   badge_class: string,
     *   bar_class: string,
     *   progress_width: float
     * }
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
