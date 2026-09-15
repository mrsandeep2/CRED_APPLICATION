<?php

namespace Sandeepkumar\CredApp\Core;

use PDO;
use PDOException;

class Database
{
    private PDO $connection;

    public function __construct()
    {
        $config = require __DIR__ . '/../../config/database.php';

        $host = $config['host'];
        $database = $config['database'];
        $username = $config['username'];
        $password = $config['password'];
        $charset = $config['charset'];

        $dsn = "mysql:host={$host};dbname={$database};charset={$charset}";

        try {
            $this->connection = new PDO(
                $dsn,
                $username,
                $password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]
            );
        } catch (PDOException $e) {
            die('Database connection failed: ' . $e->getMessage());
        }
    }

    public function getConnection(): PDO
    {
        return $this->connection;
    }
}