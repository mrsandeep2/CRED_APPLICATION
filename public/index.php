<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Smarty\Smarty;
use Sandeepkumar\CredApp\Core\Router;
use Sandeepkumar\CredApp\Core\Database;
use Sandeepkumar\CredApp\Controllers\AuthController;
use Sandeepkumar\CredApp\Controllers\DashboardController;
use Sandeepkumar\CredApp\Controllers\CreditCardController;
use Sandeepkumar\CredApp\Controllers\BillController;
use Sandeepkumar\CredApp\Controllers\PaymentController;

$smarty = new Smarty();
$smarty->setTemplateDir(__DIR__ . '/../templates');
$smarty->setCompileDir(__DIR__ . '/../templates/cache');

$router = new Router();
$database = new Database();
$dashboardController = new DashboardController($smarty, $database);
$creditCardController = new CreditCardController($smarty, $database);
$billController = new BillController($smarty, $database);
$paymentController = new PaymentController($smarty, $database);
$authController = new AuthController(
	$smarty,
	$database
);

$router->get('/', [$dashboardController, 'index']);
$router->get('/cards', [$creditCardController, 'index']);
$router->get('/cards/add', [$creditCardController, 'showAddForm']);
$router->post('/cards/add', [$creditCardController, 'handleAdd']);
$router->post('/cards/delete', [$creditCardController, 'delete']);
$router->get('/bills', [$billController, 'index']);
$router->get('/bills/add', [$billController, 'showAddForm']);
$router->post('/bills/add', [$billController, 'handleAdd']);
$router->post('/bills/pay', [$billController, 'markAsPaid']);
$router->post('/bills/delete', [$billController, 'delete']);
$router->get('/payments/checkout', [$paymentController, 'showCheckout']);
$router->post('/payments/process', [$paymentController, 'processPayment']);
$router->get('/payments/success', [$paymentController, 'showSuccess']);
$router->get('/payments/failed', [$paymentController, 'showFailed']);
$router->get('/payments/history', [$paymentController, 'showHistory']);
$router->get('/payments', [$paymentController, 'showHistory']);
$router->get('/payments/analytics', [$paymentController, 'showAnalytics']);
$router->post('/payments/reverse', [$paymentController, 'reversePayment']);
$router->get('/register', [$authController, 'register']);
$router->post('/register', [$authController, 'register']);
$router->get('/login', [$authController, 'login']);
$router->post('/login', [$authController, 'login']);
$router->get('/logout', [$authController, 'logout']);

$uri = $_SERVER['REQUEST_URI'] ?? '/';
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

echo $router->dispatch($uri, $method);