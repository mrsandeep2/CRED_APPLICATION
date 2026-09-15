{extends file="../layouts/main.tpl"}

{block name="title"}
    Login | CRED Heritage & Modern
{/block}

{block name="content"}

<div class="row justify-content-center">

    <div class="col-md-7 col-lg-5">

        <div class="card cred-card shadow-sm">

            <div class="card-body p-4 p-md-5">

                <div class="text-center mb-4">
                    <div class="d-inline-flex align-items-center justify-content-center mb-3 rounded-circle" 
                         style="width: 60px; height: 60px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; color: #b45309; font-size: 1.8rem; box-shadow: 0 6px 16px rgba(245, 158, 11, 0.25);">
                        <i class="bi bi-person-lock"></i>
                    </div>

                    <h2 class="fw-bold text-dark mb-1">
                        Welcome Back
                    </h2>

                    <p class="text-muted small">
                        Access your luxury credit portal and exclusive rewards.
                    </p>
                </div>

                {if !empty($errors)}
                    <div class="alert alert-danger border-danger-subtle rounded-3 shadow-sm mb-4">
                        <div class="d-flex align-items-center gap-2 mb-1 fw-bold text-danger">
                            <i class="bi bi-exclamation-octagon-fill"></i>
                            <span>Authentication Error:</span>
                        </div>
                        <ul class="mb-0 ps-3">
                            {foreach $errors as $error}
                                <li>{$error}</li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}

                <form method="POST" action="/cred-app/public/login">

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="bi bi-envelope-fill text-warning me-1"></i> Email Address
                        </label>

                        <input
                            type="email"
                            class="form-control"
                            id="email"
                            name="email"
                            value="{$old.email|default:''}"
                            placeholder="name@example.com"
                            required
                        >
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label">
                            <i class="bi bi-key-fill text-warning me-1"></i> Password
                        </label>

                        <input
                            type="password"
                            class="form-control"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            required
                        >
                    </div>

                    <button
                        type="submit"
                        class="btn btn-royal-primary w-100 py-3 mb-3"
                    >
                        <i class="bi bi-box-arrow-in-right"></i>
                        <span>Secure Login</span>
                    </button>

                    <div class="d-flex align-items-center justify-content-center gap-2">
                        <a href="/cred-app/public/" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                            <i class="bi bi-house-door"></i>
                            <span>Back to Home</span>
                        </a>
                    </div>

                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <p class="text-muted small mb-0">
                        New to CRED?
                        <a
                            href="/cred-app/public/register"
                            class="fw-bold text-decoration-none"
                            style="color: #b45309;"
                        >
                            Create an Account
                        </a>
                    </p>
                </div>

            </div>

        </div>

    </div>

</div>

{/block}
