<?php

namespace Sandeepkumar\CredApp\Models;

use PDO;
use Sandeepkumar\CredApp\Core\Database;

class CreditCard
{
    private PDO $db;

    public function __construct(Database $database)
    {
        $this->db = $database->getConnection();
    }

    public function create(
        int $userId,
        string $cardHolder,
        string $bankName,
        string $cardNumber,
        int $expiryMonth,
        int $expiryYear,
        string $creditLimit
    ): bool {
        $stmt = $this->db->prepare(
            'INSERT INTO credit_cards
                (user_id, card_holder, bank_name, card_number, expiry_month, expiry_year, credit_limit)
             VALUES
                (:user_id, :card_holder, :bank_name, :card_number, :expiry_month, :expiry_year, :credit_limit)'
        );

        return $stmt->execute([
            'user_id' => $userId,
            'card_holder' => $cardHolder,
            'bank_name' => $bankName,
            'card_number' => $cardNumber,
            'expiry_month' => $expiryMonth,
            'expiry_year' => $expiryYear,
            'credit_limit' => $creditLimit
        ]);
    }

    public function findByUserId(int $userId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, user_id, card_holder, bank_name, card_number,
                    expiry_month, expiry_year, credit_limit, created_at
             FROM credit_cards
             WHERE user_id = :user_id
             ORDER BY id DESC'
        );

        $stmt->execute([
            'user_id' => $userId
        ]);

        return $stmt->fetchAll();
    }

    public function findById(int $id, int $userId): ?array
    {
        $stmt = $this->db->prepare(
            'SELECT id, user_id, card_holder, bank_name, card_number,
                    expiry_month, expiry_year, credit_limit, created_at
             FROM credit_cards
             WHERE id = :id
               AND user_id = :user_id
             LIMIT 1'
        );

        $stmt->execute([
            'id' => $id,
            'user_id' => $userId
        ]);

        $card = $stmt->fetch();

        return $card ?: null;
    }

    public function delete(int $id, int $userId): bool
    {
        $stmt = $this->db->prepare(
            'DELETE FROM credit_cards
             WHERE id = :id
               AND user_id = :user_id'
        );

        return $stmt->execute([
            'id' => $id,
            'user_id' => $userId
        ]);
    }
}
