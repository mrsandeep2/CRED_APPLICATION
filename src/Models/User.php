<?php

namespace Sandeepkumar\CredApp\Models;

use PDO;
use Sandeepkumar\CredApp\Core\Database;

class User
{
    private PDO $db;

    public function __construct(Database $database)
    {
        $this->db = $database->getConnection();
    }

    public function findByEmail(string $email): ?array
    {
        $stmt = $this->db->prepare(
            'SELECT id, name, email, mobile, password, created_at
             FROM users
             WHERE email = :email
             LIMIT 1'
        );

        $stmt->execute([
            'email' => $email
        ]);

        $user = $stmt->fetch();

        return $user ?: null;
    }

    public function create(
        string $name,
        string $email,
        string $mobile,
        string $password
    ): bool {
        $stmt = $this->db->prepare(
            'INSERT INTO users (name, email, mobile, password)
             VALUES (:name, :email, :mobile, :password)'
        );

        return $stmt->execute([
            'name' => $name,
            'email' => $email,
            'mobile' => $mobile,
            'password' => $password
        ]);
    }
}
