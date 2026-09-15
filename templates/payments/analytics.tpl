{extends file="../layouts/main.tpl"}

{block name="title"}
    Payment Analytics & CRED Rewards | Royal Heritage Experience
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
        <a href="/cred-app/public/bills" class="text-decoration-none text-muted small hover-gold">Bills</a>
        <span class="text-muted opacity-50">/</span>
        <a href="/cred-app/public/payments/history" class="text-decoration-none text-muted small hover-gold">History</a>
        <span class="text-muted opacity-50">/</span>
        <span class="fw-bold text-dark">Analytics & Rewards</span>
    </div>

    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/payments/history" class="btn btn-sm btn-outline-warning text-dark rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b;">
            <i class="bi bi-journal-check text-warning"></i>
            <span>Payment History</span>
        </a>
        <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-primary rounded-pill px-3">
            <i class="bi bi-receipt-cutoff"></i>
            <span>Bills</span>
        </a>
    </div>
</div>

<!-- Header Section -->
<div class="card cred-card border-0 mb-4 text-dark" style="background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 40%, #ffffff 100%); border: 1.5px solid rgba(245, 158, 11, 0.3) !important;">
    <div class="card-body p-4 p-lg-5 position-relative">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <div class="d-inline-flex align-items-center gap-2 badge bg-white text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-2 mb-3 shadow-sm">
                    <i class="bi bi-stars text-warning"></i>
                    <span class="fw-semibold">CRED Rewards & Financial Intelligence</span>
                </div>
                <h1 class="display-6 fw-bold mb-2 text-dark">
                    Payment Analytics & <span style="background: linear-gradient(135deg, #1e3a8a 0%, #b45309 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Rewards Hub</span>
                </h1>
                <p class="text-secondary fs-6 mb-0" style="max-width: 620px;">
                    Gain deep insight into your credit card settlements, spending trends across payment channels, and accumulated CRED cashback.
                </p>
            </div>
            <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                <div class="d-inline-flex flex-column align-items-lg-end gap-1 p-3 rounded-4 bg-white border shadow-sm">
                    <span class="text-muted small text-uppercase fw-bold" style="letter-spacing: 0.5px;">CRED Reward Points</span>
                    <div class="d-flex align-items-center gap-2">
                        <span class="fs-3 fw-bold text-warning-emphasis">{$total_reward_points|default:'0'}</span>
                        <span class="badge bg-warning-subtle text-warning-emphasis rounded-pill px-2 py-1 small">pts</span>
                    </div>
                    <small class="text-muted"><i class="bi bi-shield-check text-success"></i> 10 pts per ₹1 settled</small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Key Stat Cards (4-Grid) -->
<div class="row g-4 mb-4 align-items-stretch">
    <!-- Stat 1: Lifetime Settled Amount -->
    <div class="col-sm-6 col-lg-3">
        <div class="card cred-card h-100 p-3 shadow-sm" style="background: linear-gradient(135deg, #f0fdf4 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Total Paid</span>
                    <h3 class="fw-bold my-1 text-dark">₹{$total_paid|default:'0.00'}</h3>
                    <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-2 py-1 small">
                        <i class="bi bi-check-circle-fill me-1"></i> Lifetime Settled
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 50px; height: 50px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1px solid #10b981; color: #047857; font-size: 1.4rem; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);">
                    <i class="bi bi-wallet-fill"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Stat 2: This Month's Spend -->
    <div class="col-sm-6 col-lg-3">
        <div class="card cred-card h-100 p-3 shadow-sm" style="background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">This Month</span>
                    <h3 class="fw-bold my-1 text-dark">₹{$monthly_spend|default:'0.00'}</h3>
                    <span class="badge bg-primary-subtle text-primary-emphasis border border-primary-subtle rounded-pill px-2 py-1 small">
                        <i class="bi bi-calendar3 me-1"></i> Current Cycle
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 50px; height: 50px; background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); border: 1px solid #3b82f6; color: #1e3a8a; font-size: 1.4rem; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);">
                    <i class="bi bi-graph-up-arrow"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Stat 3: Successful Payments -->
    <div class="col-sm-6 col-lg-3">
        <div class="card cred-card h-100 p-3 shadow-sm" style="background: linear-gradient(135deg, #faf5ff 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Payments</span>
                    <h3 class="fw-bold my-1 text-dark">{$successful_count|default:0} <span class="fs-6 fw-normal text-muted">Cleared</span></h3>
                    <span class="badge bg-secondary-subtle text-secondary-emphasis border border-secondary-subtle rounded-pill px-2 py-1 small">
                        Avg: ₹{$avg_txn_value|default:'0.00'}
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 50px; height: 50px; background: linear-gradient(135deg, #f3e8ff 0%, #e9d5ff 100%); border: 1px solid #a855f7; color: #6b21a8; font-size: 1.4rem; box-shadow: 0 4px 12px rgba(168, 85, 247, 0.2);">
                    <i class="bi bi-check2-all"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Stat 4: Total Cashback Earned -->
    <div class="col-sm-6 col-lg-3">
        <div class="card cred-card h-100 p-3 shadow-sm" style="background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Total Cashback</span>
                    <h3 class="fw-bold my-1 text-dark">₹{$total_cashback|default:'0.00'}</h3>
                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-2 py-1 small">
                        <i class="bi bi-gift-fill me-1"></i> 1% Rebate
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 50px; height: 50px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1px solid #f59e0b; color: #b45309; font-size: 1.4rem; box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);">
                    <i class="bi bi-gift-fill"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Analytics Body -->
{if $raw_total_paid > 0}
    <div class="row g-4 mb-4">
        
        <!-- 6-Month Monthly Spending Trend Chart -->
        <div class="col-lg-8">
            <div class="card cred-card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="fw-bold mb-1 d-flex align-items-center gap-2 text-dark">
                            <i class="bi bi-bar-chart-fill text-warning"></i>
                            <span>Monthly Spending Trend (Last 6 Months)</span>
                        </h5>
                        <p class="text-muted small mb-0">Historical settled volumes from your persistent payment records.</p>
                    </div>
                    <span class="badge bg-light text-muted border rounded-pill px-3 py-1 small">
                        Real-time Ledger
                    </span>
                </div>

                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <!-- Dynamic CSS Bar Chart -->
                    <div class="d-flex align-items-end justify-content-between gap-3 pt-4 pb-2" style="min-height: 220px;">
                        {foreach $trend_chart as $m}
                            <div class="d-flex flex-column align-items-center flex-grow-1 text-center" style="max-width: 80px;">
                                <div class="small fw-bold text-dark mb-1" style="font-size: 0.75rem;">
                                    {if $m.amount > 0}₹{$m.formatted_amount}{else}<span class="text-muted opacity-50">₹0</span>{/if}
                                </div>
                                
                                <div class="w-100 d-flex align-items-end justify-content-center bg-light rounded-4 p-1" style="height: 150px; background-color: #f8fafc !important;">
                                    <div class="w-100 rounded-3 shadow-sm transition-all" 
                                         style="height: {$m.bar_height_percent}%; 
                                                background: {if $m.amount > 0}linear-gradient(180deg, #f59e0b 0%, #b45309 100%){else}#e2e8f0{/if}; 
                                                transition: height 0.5s ease;"
                                         title="{$m.month_label}: ₹{$m.formatted_amount} ({$m.count} txns)">
                                    </div>
                                </div>

                                <div class="mt-2 text-muted fw-semibold small" style="font-size: 0.78rem;">
                                    {$m.month_label}
                                </div>
                                {if $m.count > 0}
                                    <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2 py-0" style="font-size: 0.65rem;">
                                        {$m.count} paid
                                    </span>
                                {/if}
                            </div>
                        {/foreach}
                    </div>

                    <div class="border-top pt-3 mt-3 d-flex flex-wrap align-items-center justify-content-between gap-2 small text-muted">
                        <div>
                            <i class="bi bi-info-circle me-1 text-primary"></i> Bars scale dynamically based on monthly transaction volume.
                        </div>
                        <div class="fw-semibold text-dark">
                            Total Processed: ₹{$total_paid}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Method Breakdown -->
        <div class="col-lg-4">
            <div class="card cred-card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom p-4">
                    <h5 class="fw-bold mb-1 d-flex align-items-center gap-2 text-dark">
                        <i class="bi bi-pie-chart-fill text-primary"></i>
                        <span>Payment Channels</span>
                    </h5>
                    <p class="text-muted small mb-0">Distribution across settlement gateways.</p>
                </div>

                <div class="card-body p-4">
                    <div class="d-flex flex-column gap-3">
                        {foreach $method_breakdown as $method}
                            <div class="p-3 rounded-3 bg-light border">
                                <div class="d-flex align-items-center justify-content-between mb-1">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi {$method.icon} fs-5"></i>
                                        <span class="fw-bold text-dark">{$method.label}</span>
                                    </div>
                                    <span class="fw-bold text-dark">₹{$method.formatted_amount}</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between small text-muted mb-2">
                                    <span>{$method.count} transaction{if $method.count != 1}s{/if}</span>
                                    <span class="fw-semibold text-primary">{$method.percentage}%</span>
                                </div>
                                <div class="progress" style="height: 6px; background-color: #e2e8f0;">
                                    <div class="progress-bar bg-warning" role="progressbar" style="width: {$method.percentage}%;" aria-valuenow="{$method.percentage}" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- CRED Rewards Privilege & Recent Settlements Section -->
    <div class="row g-4 mb-4">
        
        <!-- Rewards Rules & Privileges (CRED Demonstration) -->
        <div class="col-lg-5">
            <div class="card cred-card shadow-sm border-0 h-100" style="background: linear-gradient(135deg, #fffdfa 0%, #ffffff 100%);">
                <div class="card-header bg-white border-bottom p-4">
                    <h5 class="fw-bold mb-1 d-flex align-items-center gap-2 text-dark">
                        <i class="bi bi-shield-lock-fill text-warning"></i>
                        <span>CRED Privilege & Rewards</span>
                    </h5>
                    <p class="text-muted small mb-0">Demonstration rewards structure & benefits.</p>
                </div>

                <div class="card-body p-4">
                    <div class="d-flex flex-column gap-3">
                        <div class="d-flex align-items-start gap-3 p-3 rounded-3 bg-light border">
                            <div class="p-2 rounded-3 bg-warning-subtle text-warning-emphasis">
                                <i class="bi bi-percent fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-1 text-dark">1% Guaranteed Cashback</h6>
                                <p class="text-muted small mb-0">Every cleared bill statement earns an automatic 1% cashback credited directly to your account balance.</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-start gap-3 p-3 rounded-3 bg-light border">
                            <div class="p-2 rounded-3 bg-primary-subtle text-primary-emphasis">
                                <i class="bi bi-stars fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-1 text-dark">10x Reward Points Multiplier</h6>
                                <p class="text-muted small mb-0">Earn 10 CRED reward points for every ₹1 settled through any supported gateway channel.</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-start gap-3 p-3 rounded-3 bg-light border">
                            <div class="p-2 rounded-3 bg-success-subtle text-success-emphasis">
                                <i class="bi bi-journal-check fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-1 text-dark">Immutable Transaction Ledger</h6>
                                <p class="text-muted small mb-0">All settlements are permanently recorded with unique gateway references and bank-grade isolation.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Settlements -->
        <div class="col-lg-7">
            <div class="card cred-card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="fw-bold mb-1 d-flex align-items-center gap-2 text-dark">
                            <i class="bi bi-clock-history text-primary"></i>
                            <span>Recent Settlements</span>
                        </h5>
                        <p class="text-muted small mb-0">Latest verified transactions from your ledger.</p>
                    </div>
                    <a href="/cred-app/public/payments/history" class="btn btn-sm btn-royal-outline rounded-pill px-3">
                        View All
                    </a>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light" style="background-color: #faf8f5;">
                                <tr class="text-uppercase small fw-bold text-muted">
                                    <th class="ps-4 py-3">Transaction</th>
                                    <th class="py-3">Method</th>
                                    <th class="py-3">Amount</th>
                                    <th class="pe-4 py-3 text-end">Cashback</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $recent_payments as $rp}
                                    <tr>
                                        <td class="ps-4 py-3">
                                            <div class="font-monospace fw-bold text-dark small">{$rp.transaction_id}</div>
                                            <small class="text-muted">{$rp.bank_name} &bull; {$rp.masked_card}</small>
                                        </td>
                                        <td class="py-3">
                                            <span class="badge bg-light text-dark border rounded-pill px-2 py-1 small">
                                                {$rp.payment_method_label}
                                            </span>
                                        </td>
                                        <td class="py-3">
                                            <span class="fw-bold text-dark">₹{$rp.amount}</span>
                                        </td>
                                        <td class="pe-4 py-3 text-end">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2 py-1">
                                                +₹{$rp.cashback_earned}
                                            </span>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Exclusive CRED Rewards & Perks Catalog Section -->
    <div class="card cred-card shadow-sm border-0 mb-4" style="background: linear-gradient(135deg, #1e1b4b 0%, #1e3a8a 50%, #0f172a 100%); color: #ffffff;">
        <div class="card-header border-bottom border-white border-opacity-10 p-4 d-flex flex-wrap align-items-center justify-content-between gap-3 bg-transparent">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge bg-warning text-dark rounded-pill px-3 py-1 fw-bold">
                        <i class="bi bi-gift-fill me-1"></i> EXCLUSIVE REWARDS STORE
                    </span>
                    <span class="badge bg-white bg-opacity-20 text-white rounded-pill px-2 py-1 small">
                        Balance: {$total_reward_points|default:'0'} Coins
                    </span>
                </div>
                <h4 class="fw-bold text-white mb-0">Claim Your Member Perks</h4>
                <p class="text-white text-opacity-75 small mb-0">Redeem accumulated CRED Coins for curated lifestyle vouchers and statement credits.</p>
            </div>

            <div class="d-flex align-items-center gap-2">
                <span class="text-warning fw-bold fs-5 d-flex align-items-center gap-1">
                    <i class="bi bi-coin"></i> {$total_reward_points|default:'0'} <span class="fs-6 text-white text-opacity-75 fw-normal">Coins Available</span>
                </span>
            </div>
        </div>

        <div class="card-body p-4">
            <div class="row g-3">
                <!-- Perk 1 -->
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 bg-white bg-opacity-10 border border-white border-opacity-20 rounded-4 text-white p-3 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="badge bg-warning text-dark rounded-pill px-2 py-1 fw-bold small">
                                    <i class="bi bi-bag-heart-fill"></i> Shopping
                                </span>
                                <span class="badge bg-white bg-opacity-20 text-warning fw-bold rounded-pill px-2 py-1">
                                    10,000 Coins
                                </span>
                            </div>
                            <h5 class="fw-bold text-white mb-1">₹100 Bill Credit</h5>
                            <p class="text-white text-opacity-75 small mb-3">Instant cash rebate credited directly to your next credit card settlement.</p>
                        </div>
                        <button class="btn btn-warning btn-sm w-100 rounded-pill fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#perkClaimModal" data-perk-name="₹100 Instant Statement Credit" data-perk-coins="10000">
                            <i class="bi bi-check2-circle me-1"></i> Redeem Perk
                        </button>
                    </div>
                </div>

                <!-- Perk 2 -->
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 bg-white bg-opacity-10 border border-white border-opacity-20 rounded-4 text-white p-3 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="badge bg-info text-dark rounded-pill px-2 py-1 fw-bold small">
                                    <i class="bi bi-cup-hot-fill"></i> Dining
                                </span>
                                <span class="badge bg-white bg-opacity-20 text-warning fw-bold rounded-pill px-2 py-1">
                                    20,000 Coins
                                </span>
                            </div>
                            <h5 class="fw-bold text-white mb-1">10% Off Fine Dining</h5>
                            <p class="text-white text-opacity-75 small mb-3">Exclusive table reservation privilege at luxury 5-star partner hotels.</p>
                        </div>
                        <button class="btn btn-warning btn-sm w-100 rounded-pill fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#perkClaimModal" data-perk-name="10% Off Fine Dining at Partner Luxury Hotels" data-perk-coins="20000">
                            <i class="bi bi-check2-circle me-1"></i> Redeem Perk
                        </button>
                    </div>
                </div>

                <!-- Perk 3 -->
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 bg-white bg-opacity-10 border border-white border-opacity-20 rounded-4 text-white p-3 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="badge bg-success text-white rounded-pill px-2 py-1 fw-bold small">
                                    <i class="bi bi-airplane-engines-fill"></i> Travel
                                </span>
                                <span class="badge bg-white bg-opacity-20 text-warning fw-bold rounded-pill px-2 py-1">
                                    30,000 Coins
                                </span>
                            </div>
                            <h5 class="fw-bold text-white mb-1">Lounge Access Pass</h5>
                            <p class="text-white text-opacity-75 small mb-3">Complimentary domestic airport lounge pass with gourmet refreshments.</p>
                        </div>
                        <button class="btn btn-warning btn-sm w-100 rounded-pill fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#perkClaimModal" data-perk-name="Complimentary Airport Lounge Access Pass" data-perk-coins="30000">
                            <i class="bi bi-check2-circle me-1"></i> Redeem Perk
                        </button>
                    </div>
                </div>

                <!-- Perk 4 -->
                <div class="col-md-6 col-lg-3">
                    <div class="card h-100 bg-white bg-opacity-10 border border-white border-opacity-20 rounded-4 text-white p-3 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="badge bg-primary text-white rounded-pill px-2 py-1 fw-bold small">
                                    <i class="bi bi-cart-check-fill"></i> Shopping
                                </span>
                                <span class="badge bg-white bg-opacity-20 text-warning fw-bold rounded-pill px-2 py-1">
                                    50,000 Coins
                                </span>
                            </div>
                            <h5 class="fw-bold text-white mb-1">₹500 Gift Voucher</h5>
                            <p class="text-white text-opacity-75 small mb-3">Premium brand voucher usable on Amazon, Flipkart, or Apple Store.</p>
                        </div>
                        <button class="btn btn-warning btn-sm w-100 rounded-pill fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#perkClaimModal" data-perk-name="₹500 Multi-Brand Shopping Gift Card" data-perk-coins="50000">
                            <i class="bi bi-check2-circle me-1"></i> Redeem Perk
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Perk Redemption Modal -->
    <div class="modal fade" id="perkClaimModal" tabindex="-1" aria-labelledby="perkClaimModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg text-start">
                <div class="modal-header border-0 pb-0 text-center d-flex flex-column align-items-center position-relative pt-4">
                    <button type="button" class="btn-close position-absolute end-0 top-0 m-3" data-bs-dismiss="modal" aria-label="Close"></button>
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-2" 
                         style="width: 60px; height: 60px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; color: #b45309; font-size: 1.8rem; box-shadow: 0 4px 14px rgba(245, 158, 11, 0.3);">
                        <i class="bi bi-gift-fill"></i>
                    </div>
                    <h5 class="modal-title fw-bold text-dark" id="perkClaimModalLabel">CRED Privilege Claim</h5>
                    <p class="text-muted small mb-0">Exclusive Royal Member Benefit</p>
                </div>

                <div class="modal-body p-4 text-center">
                    <h5 class="fw-bold text-dark mb-2" id="modalPerkTitle">Member Benefit</h5>
                    <p class="text-muted small mb-3">
                        Your claim has been verified against your available CRED Coins balance (<span class="fw-bold text-warning-emphasis">{$total_reward_points|default:'0'} pts</span>).
                    </p>
                    <div class="p-3 bg-light rounded-3 border mb-3 text-start small">
                        <div class="d-flex justify-content-between py-1 border-bottom">
                            <span class="text-muted">Benefit Status</span>
                            <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2 py-0">Active & Available</span>
                        </div>
                        <div class="d-flex justify-content-between py-1 border-bottom">
                            <span class="text-muted">Multiplier</span>
                            <span class="fw-semibold text-dark">10x Points on every ₹1 settled</span>
                        </div>
                        <div class="d-flex justify-content-between py-1">
                            <span class="text-muted">Cashback Guarantee</span>
                            <span class="fw-semibold text-success">1% Auto-Credited</span>
                        </div>
                    </div>
                    <div class="alert alert-warning py-2 px-3 small rounded-3 mb-0 text-start">
                        <i class="bi bi-stars text-warning me-1"></i> <strong>CRED Demonstration:</strong> Settle more credit card statements to continuously accumulate Coins & Cashback!
                    </div>
                </div>

                <div class="modal-footer border-0 pt-0 justify-content-center pb-4">
                    <button type="button" class="btn btn-royal-primary rounded-pill px-4 btn-sm" data-bs-dismiss="modal">
                        <i class="bi bi-check-lg"></i> Great, Thanks!
                    </button>
                </div>
            </div>
        </div>
    </div>
{else}
    <!-- Empty Analytics State -->
    <div class="card cred-card shadow-sm border-0 p-5 text-center my-4">
        <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3 mx-auto" 
             style="width: 80px; height: 80px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; color: #b45309; font-size: 2.5rem; box-shadow: 0 6px 18px rgba(245, 158, 11, 0.2);">
            <i class="bi bi-graph-up"></i>
        </div>
        <h4 class="fw-bold mb-2 text-dark">No Settled Payments Yet</h4>
        <p class="text-muted mb-4" style="max-width: 480px; margin: 0 auto;">
            Once you settle credit card statements using any supported payment channel, comprehensive spending trends, method distributions, and cashback rewards analytics will appear here.
        </p>
        <div class="d-flex align-items-center justify-content-center gap-2">
            <a href="/cred-app/public/bills" class="btn btn-royal-primary">
                <i class="bi bi-receipt-cutoff"></i>
                <span>View Bills & Settle</span>
            </a>
            <a href="/cred-app/public/" class="btn btn-royal-outline">
                <i class="bi bi-house-door"></i>
                <span>Dashboard</span>
            </a>
        </div>
    </div>
{/if}

{/block}
