<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>{block name="title"}CRED | Modern & Heritage Credit Experience{/block}</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-canvas: #faf8f5;
            --bg-canvas-subtle: #f4ede2;
            --card-bg: #ffffff;
            --primary-royal: #1e3a8a;
            --primary-accent: #d97706;
            --primary-gold: #f59e0b;
            --primary-gold-light: #fef3c7;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-subtle: rgba(217, 119, 6, 0.15);
            --border-light: rgba(226, 232, 240, 0.9);
            --shadow-soft: 0 10px 30px -10px rgba(180, 83, 9, 0.08), 0 4px 6px -2px rgba(0, 0, 0, 0.03);
            --shadow-card: 0 20px 40px -15px rgba(30, 58, 138, 0.07), 0 0 1px 1px rgba(217, 119, 6, 0.08);
            --shadow-hover: 0 25px 50px -12px rgba(217, 119, 6, 0.18);
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-canvas);
            background-image: 
                radial-gradient(at 0% 0%, rgba(245, 158, 11, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(30, 58, 138, 0.06) 0px, transparent 50%),
                radial-gradient(at 50% 100%, rgba(217, 119, 6, 0.05) 0px, transparent 50%);
            background-attachment: fixed;
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        h1, h2, h3, h4, h5, h6, .brand-font {
            font-family: 'Outfit', sans-serif;
            color: var(--text-main);
        }

        /* Navbar */
        .cred-navbar {
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid rgba(217, 119, 6, 0.16);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            transition: all 0.3s ease;
        }

        .navbar-brand {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            letter-spacing: 2px;
            background: linear-gradient(135deg, #1e3a8a 0%, #b45309 50%, #d97706 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .brand-crest {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #f59e0b;
            border-radius: 10px;
            color: #b45309;
            font-size: 1.2rem;
            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.25);
        }

        .nav-pill-btn {
            background: #ffffff;
            border: 1px solid var(--border-subtle);
            color: var(--text-main);
            font-weight: 600;
            padding: 8px 18px;
            border-radius: 50rem;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.25s ease;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            text-decoration: none;
        }

        .nav-pill-btn:hover {
            background: #fffdf9;
            border-color: #d97706;
            color: #b45309;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(217, 119, 6, 0.12);
        }

        .nav-pill-btn.active {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: #ffffff;
            border-color: #d97706;
            box-shadow: 0 4px 14px rgba(217, 119, 6, 0.3);
        }

        .nav-pill-btn.active:hover {
            color: #ffffff;
        }

        .nav-user-badge {
            background: linear-gradient(135deg, #f8fafc 0%, #fef3c7 100%);
            border: 1px solid rgba(217, 119, 6, 0.2);
            padding: 6px 14px;
            border-radius: 50rem;
            font-size: 0.88rem;
            font-weight: 600;
            color: #1e3a8a;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .nav-user-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1e3a8a 0%, #d97706 100%);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
        }

        /* Common Cards */
        .cred-card {
            background: var(--card-bg);
            border: 1px solid var(--border-subtle);
            border-radius: 20px;
            box-shadow: var(--shadow-card);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
        }

        .cred-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1e3a8a 0%, #f59e0b 50%, #d97706 100%);
            opacity: 0.85;
        }

        .cred-card:hover {
            border-color: rgba(217, 119, 6, 0.35);
            box-shadow: var(--shadow-hover);
        }

        /* Buttons */
        .btn-royal-primary {
            background: linear-gradient(135deg, #b45309 0%, #d97706 50%, #f59e0b 100%);
            color: #ffffff;
            border: none;
            font-weight: 600;
            border-radius: 12px;
            padding: 12px 24px;
            transition: all 0.25s ease;
            box-shadow: 0 4px 15px rgba(217, 119, 6, 0.25);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-royal-primary:hover {
            background: linear-gradient(135deg, #92400e 0%, #b45309 50%, #d97706 100%);
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(217, 119, 6, 0.35);
        }

        .btn-royal-outline {
            background: #ffffff;
            color: #b45309;
            border: 1.5px solid rgba(217, 119, 6, 0.35);
            font-weight: 600;
            border-radius: 12px;
            padding: 12px 24px;
            transition: all 0.25s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-royal-outline:hover {
            background: #fef3c7;
            border-color: #d97706;
            color: #92400e;
            transform: translateY(-1px);
        }

        /* Form Controls */
        .form-control, .form-select {
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.95rem;
            color: var(--text-main);
            background-color: #ffffff;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #d97706;
            box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.15);
            background-color: #ffffff;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #334155;
            margin-bottom: 6px;
        }

        /* Main layout content */
        .main-content {
            flex: 1 0 auto;
            padding: 3rem 0;
        }

        /* Footer */
        .cred-footer {
            background: #ffffff;
            border-top: 1px solid rgba(217, 119, 6, 0.15);
            padding: 1.75rem 0;
            color: var(--text-muted);
            font-size: 0.88rem;
            flex-shrink: 0;
            box-shadow: 0 -4px 15px rgba(0, 0, 0, 0.02);
        }
    </style>
</head>
<body>

<!-- Header Navigation -->
<nav class="navbar navbar-expand-lg cred-navbar sticky-top">
    <div class="container">
        <!-- Brand with Royal Crest -->
        <a class="navbar-brand" href="/cred-app/public/">
            <span class="brand-crest">
                <i class="bi bi-shield-fill-check"></i>
            </span>
            CRED
        </a>

        <!-- Mobile Toggle -->
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#credNavContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Nav Links -->
        <div class="collapse navbar-collapse" id="credNavContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4 gap-2">
                <li class="nav-item">
                    <a href="/cred-app/public/" class="nav-pill-btn">
                        <i class="bi bi-house-door-fill text-warning"></i>
                        <span>Home</span>
                    </a>
                </li>
                {if isset($smarty.session.user_id)}
                    <li class="nav-item">
                        <a href="/cred-app/public/cards" class="nav-pill-btn">
                            <i class="bi bi-wallet2 text-warning"></i>
                            <span>My Cards</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="/cred-app/public/bills" class="nav-pill-btn">
                            <i class="bi bi-receipt-cutoff text-success"></i>
                            <span>Bills</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="/cred-app/public/payments/history" class="nav-pill-btn">
                            <i class="bi bi-journal-check text-warning"></i>
                            <span>Payment History</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="/cred-app/public/payments/analytics" class="nav-pill-btn">
                            <i class="bi bi-stars text-warning"></i>
                            <span>Rewards & Analytics</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="/cred-app/public/cards/add" class="nav-pill-btn">
                            <i class="bi bi-credit-card-2-front-fill text-primary"></i>
                            <span>Add Card</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="/cred-app/public/bills/add" class="nav-pill-btn">
                            <i class="bi bi-plus-circle-fill text-warning"></i>
                            <span>Add Bill</span>
                        </a>
                    </li>
                {/if}
            </ul>

            <!-- Auth Section -->
            <div class="d-flex align-items-center gap-2 mt-3 mt-lg-0">
                {if isset($smarty.session.user_id)}
                    <div class="nav-user-badge me-2">
                        <span class="nav-user-avatar">
                            {if isset($smarty.session.user_name)}
                                {$smarty.session.user_name|substr:0:1|upper}
                            {else}
                                U
                            {/if}
                        </span>
                        <span>{$smarty.session.user_name|default:'User'}</span>
                    </div>

                    <a href="/cred-app/public/logout" class="nav-pill-btn text-danger">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Logout</span>
                    </a>
                {else}
                    <a href="/cred-app/public/login" class="nav-pill-btn">
                        <i class="bi bi-box-arrow-in-right"></i>
                        <span>Login</span>
                    </a>

                    <a href="/cred-app/public/register" class="nav-pill-btn active">
                        <i class="bi bi-person-plus-fill"></i>
                        <span>Register</span>
                    </a>
                {/if}
            </div>
        </div>
    </div>
</nav>

<!-- Page Content -->
<main class="main-content">
    <div class="container">
        {if !empty($flash_message)}
            <div class="alert alert-{$flash_type|default:'info'} alert-dismissible fade show rounded-4 shadow-sm border mb-4 d-flex align-items-center gap-3" role="alert">
                <div class="fs-4">
                    {if $flash_type == 'success'}
                        <i class="bi bi-check-circle-fill text-success"></i>
                    {elseif $flash_type == 'danger'}
                        <i class="bi bi-exclamation-triangle-fill text-danger"></i>
                    {elseif $flash_type == 'warning'}
                        <i class="bi bi-exclamation-circle-fill text-warning"></i>
                    {else}
                        <i class="bi bi-info-circle-fill text-primary"></i>
                    {/if}
                </div>
                <div class="fw-semibold flex-grow-1">
                    {$flash_message}
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        {/if}

        {block name="content"}
        {/block}
    </div>
</main>

<!-- Modern Heritage Footer -->
<footer class="cred-footer">
    <div class="container">
        <div class="d-flex flex-column flex-md-row align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-1">
                    <i class="bi bi-stars me-1"></i> Royal & Modern Experience
                </span>
                <span>CRED Platform &copy; {$year|default:2026}</span>
            </div>

            <div class="d-flex align-items-center gap-3">
                <a href="/cred-app/public/" class="text-decoration-none text-muted small hover-gold">
                    <i class="bi bi-house-door me-1"></i>Home
                </a>
                <span class="text-muted opacity-25">|</span>
                <span class="small text-muted">
                    <i class="bi bi-shield-lock-fill text-success me-1"></i>256-bit Encrypted
                </span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
