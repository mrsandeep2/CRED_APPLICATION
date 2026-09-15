<?php

namespace Sandeepkumar\CredApp\Models;

use PDO;
use Sandeepkumar\CredApp\Core\Database;

class Bill
{
    private PDO $db;

    public function __construct(Database $database)
    {
        $this->db = $database->getConnection();
    }

    public function findByUserId(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                b.id,
                b.user_id,
                b.card_id,
                b.amount,
                b.due_date,
                b.status,
                b.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number,
                c.expiry_month,
                c.expiry_year,
                c.credit_limit
             FROM bills b
             JOIN credit_cards c ON b.card_id = c.id
             WHERE b.user_id = :user_id
             ORDER BY b.due_date ASC'
        );

        $stmt->execute([
            'user_id' => $userId
        ]);

        return $stmt->fetchAll();
    }

    public function findPendingByUserId(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                b.id,
                b.user_id,
                b.card_id,
                b.amount,
                b.due_date,
                b.status,
                b.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number,
                c.expiry_month,
                c.expiry_year,
                c.credit_limit
             FROM bills b
             JOIN credit_cards c ON b.card_id = c.id
             WHERE b.user_id = :user_id
               AND b.status = :status
             ORDER BY b.due_date ASC'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status' => 'pending'
        ]);

        return $stmt->fetchAll();
    }

    public function getTotalDueByUserId(int $userId): float
    {
        $stmt = $this->db->prepare(
            'SELECT COALESCE(SUM(amount), 0) AS total_due
             FROM bills
             WHERE user_id = :user_id
               AND status = :status'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status' => 'pending'
        ]);

        $result = $stmt->fetch();

        return (float)($result['total_due'] ?? 0);
    }

    public function getPaidCountByUserId(int $userId): int
    {
        $stmt = $this->db->prepare(
            'SELECT COUNT(*) AS paid_count
             FROM bills
             WHERE user_id = :user_id
               AND status = :status'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status' => 'paid'
        ]);

        $result = $stmt->fetch();

        return (int)($result['paid_count'] ?? 0);
    }

    public function create(
        int $userId,
        int $cardId,
        float $amount,
        string $dueDate
    ): bool {
        $stmt = $this->db->prepare(
            'INSERT INTO bills (user_id, card_id, amount, due_date, status)
             VALUES (:user_id, :card_id, :amount, :due_date, :status)'
        );

        return $stmt->execute([
            'user_id' => $userId,
            'card_id' => $cardId,
            'amount' => $amount,
            'due_date' => $dueDate,
            'status' => 'pending'
        ]);
    }

    public function findById(int $id): ?array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                b.id,
                b.user_id,
                b.card_id,
                b.amount,
                b.due_date,
                b.status,
                b.created_at,
                c.card_holder,
                c.bank_name,
                c.card_number,
                c.expiry_month,
                c.expiry_year,
                c.credit_limit
             FROM bills b
             JOIN credit_cards c ON b.card_id = c.id
             WHERE b.id = :id
             LIMIT 1'
        );

        $stmt->execute([
            'id' => $id
        ]);

        $bill = $stmt->fetch();

        return $bill ?: null;
    }

    public function markAsPaid(int $id, int $userId): bool
    {
        $stmt = $this->db->prepare(
            'UPDATE bills
             SET status = :status
             WHERE id = :id
               AND user_id = :user_id'
        );

        return $stmt->execute([
            'status' => 'paid',
            'id' => $id,
            'user_id' => $userId
        ]);
    }

    public function delete(int $id, int $userId): bool
    {
        $stmt = $this->db->prepare(
            'DELETE FROM bills
             WHERE id = :id
               AND user_id = :user_id'
        );

        return $stmt->execute([
            'id' => $id,
            'user_id' => $userId
        ]);
    }

    public function getPendingTotalsPerCard(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT card_id, COALESCE(SUM(amount), 0) AS total_pending
             FROM bills
             WHERE user_id = :user_id
               AND status = :status
             GROUP BY card_id'
        );

        $stmt->execute([
            'user_id' => $userId,
            'status' => 'pending'
        ]);

        $rows = $stmt->fetchAll();
        $totals = [];
        foreach ($rows as $row) {
            $totals[(int)$row['card_id']] = (float)$row['total_pending'];
        }

        return $totals;
    }

    /**
     * Retrieve the most relevant active/latest bill statement per credit card
     */
    public function getLatestBillsPerCard(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT 
                b.id,
                b.user_id,
                b.card_id,
                b.amount,
                b.due_date,
                b.status,
                b.created_at
             FROM bills b
             INNER JOIN (
                 SELECT card_id, MAX(id) AS max_id
                 FROM bills
                 WHERE user_id = :uid_sub
                 GROUP BY card_id
             ) latest ON b.id = latest.max_id
             WHERE b.user_id = :uid_main'
        );

        $stmt->execute([
            'uid_sub' => $userId,
            'uid_main' => $userId
        ]);

        $rows = $stmt->fetchAll();
        $latest = [];
        foreach ($rows as $row) {
            $latest[(int)$row['card_id']] = $row;
        }

        return $latest;
    }
}
