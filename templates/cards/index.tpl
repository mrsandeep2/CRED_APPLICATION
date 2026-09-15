{extends file="../layouts/main.tpl"}

{block name="title"}
    My Credit Cards | CRED Heritage & Modern
{/block}

{block name="content"}

<!-- Top Navigation & Home Action Bar -->
<div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 p-3 bg-white border rounded-4 shadow-sm" style="border-color: rgba(217, 119, 6, 0.15) !important;">
    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/" class="btn btn-sm btn-outline-warning text-dark fw-semibold rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b; background: #fffdf5;">
            <i class="bi bi-house-door-fill text-warning"></i>
            <span>Home</span>
        </a>
        <span class="text-muted opacity-50">/</span>
        <a href="/cred-app/public/" class="text-decoration-none text-muted small hover-gold">Dashboard</a>
        <span class="text-muted opacity-50">/</span>
        <span class="fw-bold text-dark">My Credit Cards</span>
    </div>

    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-success rounded-pill px-3">
            <i class="bi bi-receipt-cutoff"></i>
            <span>View Bills</span>
        </a>
        <a href="/cred-app/public/cards/add" class="btn btn-royal-primary btn-sm px-3 py-2 rounded-pill shadow-sm">
            <i class="bi bi-plus-circle-fill"></i>
            <span>Add New Card</span>
        </a>
    </div>
</div>

<!-- Header Section -->
<div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
    <div>
        <h2 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
            <i class="bi bi-wallet2 text-warning"></i>
            <span>Linked Credit Cards</span>
        </h2>
        <p class="text-muted small mb-0">
            Revolving credit lines, real-time available limits, and active billing statements.
        </p>
    </div>

    <div class="d-flex align-items-center gap-2">
        <div class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-2">
            <i class="bi bi-shield-lock-fill text-success me-1"></i>
            <span>{$card_count|default:0} Cards Connected</span>
        </div>
    </div>
</div>

{if !empty($cards)}
    <!-- Global Credit Analytics Summary -->
    <div class="row g-3 mb-4">
        <!-- Total Available Credit -->
        <div class="col-md-3">
            <div class="card cred-card p-3 shadow-sm h-100" style="background: linear-gradient(135deg, #f0fdf4 0%, #ffffff 100%);">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 0.6px;">Total Available Credit</span>
                        <h3 class="fw-bold text-success my-1">₹{$total_available|default:'0.00'}</h3>
                        <span class="small text-muted">Ready to spend</span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-success-subtle text-success p-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-check-circle-fill fs-5"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total Current Outstanding -->
        <div class="col-md-3">
            <div class="card cred-card p-3 shadow-sm h-100" style="background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 0.6px;">Current Outstanding</span>
                        <h3 class="fw-bold text-warning-emphasis my-1">₹{$total_outstanding|default:'0.00'}</h3>
                        <span class="small text-muted">Active statement balance</span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-warning-subtle text-warning p-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-cash-stack fs-5"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total Credit Limit -->
        <div class="col-md-3">
            <div class="card cred-card p-3 shadow-sm h-100" style="background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 0.6px;">Total Credit Limit</span>
                        <h3 class="fw-bold text-primary my-1">₹{$total_credit_limit|default:'0.00'}</h3>
                        <span class="small text-muted">Sanctioned capacity</span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-primary-subtle text-primary p-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-credit-card-fill fs-5"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Portfolio Utilization -->
        <div class="col-md-3">
            <div class="card cred-card p-3 shadow-sm h-100" style="background: linear-gradient(135deg, #faf5ff 0%, #ffffff 100%);">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 0.6px;">Portfolio Utilization</span>
                        <h3 class="fw-bold text-dark my-1">{$portfolio_utilization.formatted_percentage|default:'0%'}</h3>
                        <span class="badge {$portfolio_utilization.badge_class|default:'bg-secondary'} rounded-pill px-2 py-0 small">
                            {$portfolio_utilization.health_label|default:'Healthy'}
                        </span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-light text-primary border p-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-speedometer2 fs-5"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cards Grid -->
    <div class="row g-4">
        {foreach $cards as $card}
            <div class="col-lg-6 col-xl-4">
                <div class="card cred-card h-100 shadow-sm border-0">
                    <div class="card-body p-4 d-flex flex-column justify-content-between">
                        
                        <!-- 1. 3D Luxury Mini Virtual Card -->
                        <div class="p-4 text-white text-start rounded-4 position-relative overflow-hidden mb-3 shadow"
                             style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 50%, #b45309 100%); min-height: 185px; border: 1px solid rgba(254, 243, 199, 0.4);">
                            
                            <!-- Watermark Pattern -->
                            <div style="position: absolute; right: -15px; bottom: -15px; opacity: 0.12; font-size: 7.5rem; pointer-events: none; line-height: 1;">
                                <i class="bi bi-shield-fill-check"></i>
                            </div>

                            <!-- Header: Bank & Contactless -->
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <div class="fw-bold fs-6 text-truncate pe-2 text-warning">
                                    {$card.bank_name|upper}
                                </div>
                                <div class="fs-5 text-warning">
                                    <i class="bi bi-wifi"></i>
                                </div>
                            </div>

                            <!-- EMV Chip -->
                            <div class="mb-2 d-inline-flex align-items-center justify-content-center rounded-2 px-1"
                                 style="background: linear-gradient(135deg, #fde68a 0%, #d97706 100%); border: 1px solid #fef3c7; width: 34px; height: 26px;">
                                <div style="width: 100%; height: 1px; background: rgba(0,0,0,0.2);"></div>
                            </div>

                            <!-- Masked Number -->
                            <div class="fs-6 fw-bold mb-3 font-monospace text-light" style="letter-spacing: 2px;">
                                {$card.masked_number}
                            </div>

                            <!-- Card Holder & Expiry -->
                            <div class="d-flex align-items-end justify-content-between">
                                <div>
                                    <div class="text-uppercase text-white-50" style="font-size: 0.65rem; letter-spacing: 0.8px;">Card Holder</div>
                                    <div class="fw-bold text-uppercase text-truncate small" style="max-width: 140px; letter-spacing: 0.5px;">
                                        {$card.card_holder}
                                    </div>
                                </div>

                                <div class="text-end">
                                    <div class="text-uppercase text-white-50" style="font-size: 0.65rem; letter-spacing: 0.8px;">Expires</div>
                                    <div class="fw-bold font-monospace small">
                                        {$card.formatted_expiry}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 2. Card Account Financial Capacity -->
                        <div class="p-3 mb-3 bg-light rounded-3 border">
                            <div class="d-flex align-items-center justify-content-between mb-1 pb-1 border-bottom">
                                <span class="text-muted small fw-semibold">Credit Limit</span>
                                <span class="fw-bold text-dark">₹{$card.formatted_limit}</span>
                            </div>

                            <div class="d-flex align-items-center justify-content-between mb-1 pb-1 border-bottom">
                                <span class="text-muted small fw-semibold">Current Outstanding</span>
                                <span class="fw-bold text-warning-emphasis">₹{$card.formatted_outstanding}</span>
                            </div>

                            <div class="d-flex align-items-center justify-content-between mb-2 pb-1 border-bottom">
                                <span class="text-muted small fw-semibold">Available Credit</span>
                                <span class="fw-bold text-success fs-6">₹{$card.formatted_available}</span>
                            </div>

                            <!-- Over-limit Alert Box -->
                            {if $card.utilization.is_overlimit}
                                <div class="alert alert-danger py-1 px-2 mb-2 small d-flex align-items-center gap-1 rounded-2">
                                    <i class="bi bi-exclamation-octagon-fill"></i>
                                    <span><strong>Over-Limit:</strong> Balance exceeds credit limit!</span>
                                </div>
                            {/if}

                            <!-- Utilization Bar -->
                            <div class="d-flex align-items-center justify-content-between small text-muted mb-1" style="font-size: 0.75rem;">
                                <span>Utilization: <strong>{$card.utilization.formatted_percentage}</strong></span>
                                <span class="badge {$card.utilization.badge_class} rounded-pill px-2 py-0">{$card.utilization.health_label}</span>
                            </div>
                            <div class="progress" style="height: 6px; border-radius: 10px; background-color: #e2e8f0;">
                                <div class="progress-bar {$card.utilization.bar_class}" 
                                     role="progressbar" 
                                     style="width: {$card.utilization.progress_width}%;" 
                                     aria-valuenow="{$card.utilization.progress_width}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                </div>
                            </div>
                        </div>

                        <!-- 3. Current Statement / Bill Section -->
                        <div class="p-3 mb-3 rounded-3 border" style="background: #ffffff;">
                            {if $card.has_statement && $card.statement.status == 'pending'}
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <div class="d-flex align-items-center gap-1">
                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-2 py-1 small">
                                            <i class="bi bi-receipt me-1"></i> Active Statement
                                        </span>
                                    </div>
                                    <span class="badge bg-{$card.statement.urgency_class}-subtle text-{$card.statement.urgency_class} rounded-pill small">
                                        {$card.statement.urgency_text}
                                    </span>
                                </div>

                                <div class="d-flex align-items-center justify-content-between mb-1">
                                    <span class="text-muted small">Total Statement Due:</span>
                                    <span class="fw-bold text-dark fs-6">₹{$card.statement.amount}</span>
                                </div>

                                <div class="d-flex align-items-center justify-content-between mb-2 small text-muted">
                                    <span>Minimum Due:</span>
                                    <span class="fw-semibold text-secondary">₹{$card.statement.min_due}</span>
                                </div>

                                <div class="d-flex align-items-center justify-content-between mb-3 small text-muted">
                                    <span>Due Date:</span>
                                    <span class="fw-semibold text-dark">{$card.statement.due_date}</span>
                                </div>

                                <a href="/cred-app/public/payments/checkout?bill_id={$card.statement.id}" class="btn btn-sm btn-royal-primary w-100 rounded-pill shadow-sm">
                                    <i class="bi bi-lightning-charge-fill me-1"></i> Pay Statement (₹{$card.statement.amount})
                                </a>
                            {elseif $card.has_statement && $card.statement.status == 'paid'}
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-2 py-1 small">
                                        <i class="bi bi-check2-circle me-1"></i> Statement Cleared
                                    </span>
                                    <span class="badge bg-success text-white rounded-pill px-2 py-0 small">
                                        ✓ Paid in Full
                                    </span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between text-muted small py-1">
                                    <span>Settled Amount:</span>
                                    <span class="fw-bold text-dark">₹{$card.statement.amount}</span>
                                </div>
                                <div class="text-center small text-success py-1 fw-semibold">
                                    <i class="bi bi-shield-check me-1"></i> Available credit fully restored
                                </div>
                            {else}
                                <div class="text-center py-2 text-muted small">
                                    <i class="bi bi-check-circle text-success me-1"></i> No active statements due.
                                </div>
                            {/if}
                        </div>

                        <!-- 4. Card Bottom Actions -->
                        <div class="d-flex align-items-center justify-content-between gap-2 pt-2 border-top">
                            <a href="/cred-app/public/bills/add" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                                <i class="bi bi-plus-circle"></i> Add Bill
                            </a>

                            <form method="POST" action="/cred-app/public/cards/delete" onsubmit="return confirm('Are you sure you want to remove this card?');" class="m-0">
                                <input type="hidden" name="id" value="{$card.id}">
                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                    <i class="bi bi-trash3"></i> Remove
                                </button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        {/foreach}
    </div>
{else}
    <!-- Empty State -->
    <div class="card cred-card text-center p-5">
        <div class="card-body">
            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" 
                 style="width: 80px; height: 80px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; color: #b45309; font-size: 2.5rem; box-shadow: 0 6px 18px rgba(245, 158, 11, 0.2);">
                <i class="bi bi-credit-card-2-front"></i>
            </div>
            <h3 class="fw-bold mb-2 text-dark">No Credit Cards Found</h3>
            <p class="text-muted mb-4" style="max-width: 450px; margin: 0 auto;">
                You haven't added any credit cards yet. Add your first card now to experience seamless bill management and rewards.
            </p>
            <div class="d-flex align-items-center justify-content-center gap-2">
                <a href="/cred-app/public/cards/add" class="btn btn-royal-primary">
                    <i class="bi bi-plus-circle-fill"></i>
                    <span>Add Your First Card</span>
                </a>
                <a href="/cred-app/public/" class="btn btn-royal-outline">
                    <i class="bi bi-house-door"></i>
                    <span>Back to Home</span>
                </a>
            </div>
        </div>
    </div>
{/if}

{/block}
