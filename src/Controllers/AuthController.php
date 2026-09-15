<?php

namespace Sandeepkumar\CredApp\Controllers;

use Smarty\Smarty;
use Sandeepkumar\CredApp\Helpers\Validator;
use Sandeepkumar\CredApp\Models\User;
use Sandeepkumar\CredApp\Core\Database;

class AuthController
{
    private User $user;

    public function __construct(
        private Smarty $smarty,
        Database $database
    ) {
        $this->user = new User($database);
    }

    public function register(): void
    {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
            $this->handleRegistration();
            return;
        }

        $this->showRegisterForm();
    }

    public function login(): void
    {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
            $email = trim($_POST['email'] ?? '');
            $password = $_POST['password'] ?? '';

            $old = [
                'email' => $email
            ];

            $errors = [];

            if (!Validator::email($email)) {
                $errors[] = 'Please enter a valid email address.';
            }

            if ($password === '') {
                $errors[] = 'Please enter your password.';
            }

            if (!empty($errors)) {
                $this->showLoginForm($errors, $old);
                return;
            }

            $user = $this->user->findByEmail($email);

            if ($user === null || !password_verify($password, $user['password'])) {
                $errors[] = 'Invalid email or password.';
                $this->showLoginForm($errors, $old);
                return;
            }

            session_start();

            $_SESSION['user_id'] = $user['id'];
            $_SESSION['user_name'] = $user['name'];
            $_SESSION['user_email'] = $user['email'];

            header('Location: /cred-app/public/');
            exit;
        }

        $this->showLoginForm();
    }

    public function logout(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }

        $_SESSION = [];
        session_destroy();

        header('Location: /cred-app/public/login');
        exit;
    }

    private function showLoginForm(
        array $errors = [],
        array $old = []
    ): void {
        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('errors', $errors);
        $this->smarty->assign('old', $old);

        $this->smarty->display('auth/login.tpl');
    }

    private function showRegisterForm(
        array $errors = [],
        array $old = []
    ): void {
        $this->smarty->assign('year', date('Y'));
        $this->smarty->assign('errors', $errors);
        $this->smarty->assign('old', $old);

        $this->smarty->display('auth/register.tpl');
    }

    private function handleRegistration(): void
    {
        $name = trim($_POST['name'] ?? '');
        $email = trim($_POST['email'] ?? '');
        $mobile = trim($_POST['mobile'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirmPassword = $_POST['confirm_password'] ?? '';

        $old = [
            'name' => $name,
            'email' => $email,
            'mobile' => $mobile
        ];

        $errors = [];

        if (!Validator::name($name)) {
            $errors[] = 'Please enter a valid name.';
        }

        if (!Validator::email($email)) {
            $errors[] = 'Please enter a valid email address.';
        }

        if (!Validator::mobile($mobile)) {
            $errors[] = 'Please enter a valid 10-digit mobile number.';
        }

        if (!Validator::password($password)) {
            $errors[] = 'Password must be at least 8 characters and contain a letter and a number.';
        }

        if ($password !== $confirmPassword) {
            $errors[] = 'Passwords do not match.';
        }

        if ($this->user->findByEmail($email) !== null) {
            $errors[] = 'An account with this email already exists.';
        }

        if (!empty($errors)) {
            $this->showRegisterForm($errors, $old);
            return;
        }

        $hashedPassword = password_hash(
            $password,
            PASSWORD_DEFAULT
        );

        $this->user->create(
            $name,
            $email,
            $mobile,
            $hashedPassword
        );

        header('Location: /cred-app/public/login');
        exit;
    }
}