<?php

namespace Sandeepkumar\CredApp\Helpers;

class Validator
{
    public static function name(string $name): bool
    {
        return preg_match('/^[A-Za-z ]{2,100}$/', $name) === 1;
    }

    public static function email(string $email): bool
    {
        return preg_match(
            '/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/',
            $email
        ) === 1;
    }

    public static function mobile(string $mobile): bool
    {
        return preg_match('/^[6-9][0-9]{9}$/', $mobile) === 1;
    }

    public static function password(string $password): bool
    {
        return preg_match(
            '/^(?=.*[A-Za-z])(?=.*[0-9]).{8,}$/',
            $password
        ) === 1;
    }

    public static function bankName(string $bankName): bool
    {
        return preg_match('/^[A-Za-z0-9\s&.\-\',]{2,100}$/', $bankName) === 1;
    }

    public static function cardNumber(string $cardNumber): bool
    {
        $cleanNumber = str_replace([' ', '-'], '', $cardNumber);
        return preg_match('/^[0-9]{16}$/', $cleanNumber) === 1;
    }

    public static function expiryMonth(mixed $month): bool
    {
        if (!is_numeric($month)) {
            return false;
        }
        $m = (int)$month;
        return $m >= 1 && $m <= 12;
    }

    public static function expiryYear(mixed $year): bool
    {
        if (!is_numeric($year)) {
            return false;
        }
        $y = (int)$year;
        $currentYear = (int)date('Y');
        return $y >= $currentYear && $y <= $currentYear + 50;
    }

    public static function creditLimit(mixed $limit): bool
    {
        if (!is_numeric($limit)) {
            return false;
        }
        return (float)$limit > 0;
    }
}

