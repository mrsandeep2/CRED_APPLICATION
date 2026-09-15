<?php

require 'vendor/autoload.php';

use Sandeepkumar\CredApp\Core\Database;
use Sandeepkumar\CredApp\Models\User;

$database = new Database();

$user = new User($database);

$result = $user->findByEmail('test-not-found@example.com');

if ($result === null) {
    echo "User model connection successful!";
} else {
    echo "Unexpected user found.";
}
