{extends file="../layouts/main.tpl"}

{block name="title"}
    Dashboard | CRED Heritage & Modern
{/block}

{block name="content"}

<!-- Dashboard Top Navigation & Breadcrumb / Home Bar -->
<div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 p-3 bg-white border rounded-4 shadow-sm" style="border-color: rgba(217, 119, 6, 0.15) !important;">
    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/" class="btn btn-sm btn-outline-warning text-dark fw-semibold rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b; background: #fffdf5;">
            <i class="bi bi-house-door-fill text-warning"></i>
            <span>Home</span>
        </a>
        <span class="text-muted opacity-50">/</span>
        <span class="fw-bold text-dark">Dashboard</span>
    </div>

    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/cards" class="btn btn-sm btn-outline-primary rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm">
            <i class="bi bi-wallet2 text-primary"></i>
            <span>My Cards</span>
        </a>
        <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-success rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm">
            <i class="bi bi-receipt-cutoff text-success"></i>
            <span>Bills</span>
        </a>
        <a href="/cred-app/public/payments/history" class="btn btn-sm btn-outline-warning text-dark rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b;">
            <i class="bi bi-journal-check text-warning"></i>
            <span>History</span>
        </a>
        <a href="/cred-app/public/payments/analytics" class="btn btn-sm btn-outline-primary rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm">
            <i class="bi bi-graph-up-arrow text-primary"></i>
            <span>Analytics</span>
        </a>
        <a href="/cred-app/public/bills/add" class="btn btn-royal-primary btn-sm px-3 py-2 rounded-pill shadow-sm">
            <i class="bi bi-plus-circle-fill"></i>
            <span>Add Bill</span>
        </a>
    </div>
</div>

<!-- Hero Welcome Section -->
<div class="card cred-card border-0 mb-4 text-dark" style="background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 50%, #ffffff 100%); border: 1.5px solid rgba(245, 158, 11, 0.3) !important;">
    <div class="card-body p-4 p-lg-5 position-relative">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <div class="d-inline-flex align-items-center gap-2 badge bg-white text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-2 mb-3 shadow-sm">
                    <i class="bi bi-award-fill text-warning"></i>
                    <span class="fw-semibold">Royal Tier Member • 100% Protected</span>
                </div>
                <h1 class="display-6 fw-bold mb-2 text-dark">
                    Welcome back, <span style="background: linear-gradient(135deg, #1e3a8a 0%, #b45309 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">{$name|default:'Member'}</span>
                </h1>
                <p class="text-secondary fs-6 mb-4 mb-lg-0" style="max-width: 580px;">
                    Track and manage your credit cards with elegance. Instant bill notifications, rewarding payments, and seamless card controls.
                </p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <div class="d-inline-flex flex-column gap-2">
                    <a href="/cred-app/public/bills/add" class="btn btn-royal-primary">
                        <i class="bi bi-receipt-cutoff"></i>
                        <span>Add New Bill</span>
                    </a>
                    <span class="small text-muted text-center">
                        <i class="bi bi-shield-check text-success"></i> Instant Verification
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Key Stat Cards -->
<div class="row g-3 mb-4">
    <!-- Stat 1: Total Due -->
    <div class="col-sm-6 col-lg-3">
        <a href="/cred-app/public/bills" class="text-decoration-none">
            <div class="card cred-card h-100 p-3">
                <div class="card-body d-flex align-items-center justify-content-between p-2">
                    <div>
                        <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.6px;">Current Due</span>
                        <h3 class="fw-bold my-1 text-dark">₹{$total_due|default:'0.00'}</h3>
                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-2 py-0 small">
                            <i class="bi bi-receipt-cutoff me-1"></i> View Bills &rarr;
                        </span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 48px; height: 48px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1px solid #f59e0b; color: #b45309; font-size: 1.3rem; box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Stat 2: Total Available Credit -->
    <div class="col-sm-6 col-lg-3">
        <a href="/cred-app/public/cards" class="text-decoration-none">
            <div class="card cred-card h-100 p-3">
                <div class="card-body d-flex align-items-center justify-content-between p-2">
                    <div>
                        <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.6px;">Available Credit</span>
                        <h3 class="fw-bold my-1 text-success">₹{$total_available_credit|default:'0.00'}</h3>
                        <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-2 py-0 small">
                            <i class="bi bi-wallet2 me-1"></i> Ready to spend
                        </span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 48px; height: 48px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1px solid #10b981; color: #047857; font-size: 1.3rem; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);">
                        <i class="bi bi-check-circle-fill"></i>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Stat 3: Active Cards -->
    <div class="col-sm-6 col-lg-3">
        <a href="/cred-app/public/cards" class="text-decoration-none">
            <div class="card cred-card h-100 p-3">
                <div class="card-body d-flex align-items-center justify-content-between p-2">
                    <div>
                        <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.6px;">Active Cards</span>
                        <h3 class="fw-bold my-1 text-dark">{$card_count} <span class="fs-6 fw-normal text-muted">Cards</span></h3>
                        <span class="badge bg-primary-subtle text-primary-emphasis border border-primary-subtle rounded-pill px-2 py-0 small">
                            <i class="bi bi-credit-card me-1"></i> Limit: ₹{$total_credit_limit}
                        </span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 48px; height: 48px; background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); border: 1px solid #3b82f6; color: #1e3a8a; font-size: 1.3rem; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);">
                        <i class="bi bi-credit-card"></i>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <!-- Stat 4: Paid Bills -->
    <div class="col-sm-6 col-lg-3">
        <a href="/cred-app/public/bills" class="text-decoration-none">
            <div class="card cred-card h-100 p-3">
                <div class="card-body d-flex align-items-center justify-content-between p-2">
                    <div>
                        <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.6px;">Paid Bills</span>
                        <h3 class="fw-bold my-1 text-dark">{$paid_bills} <span class="fs-6 fw-normal text-muted">Cleared</span></h3>
                        <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-2 py-0 small">
                            <i class="bi bi-check-circle-fill me-1"></i> 100% On Time
                        </span>
                    </div>
                    <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 48px; height: 48px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1px solid #f59e0b; color: #b45309; font-size: 1.3rem; box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                </div>
            </div>
        </a>
    </div>
</div>

<!-- Bills Table Card -->
<div class="card cred-card shadow-sm border-0">
    <div class="card-header bg-white border-bottom p-4 d-flex flex-wrap align-items-center justify-content-between gap-3">
        <div>
            <h4 class="fw-bold mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-receipt-cutoff text-warning"></i>
                <span>Upcoming & Recent Bills</span>
            </h4>
            <p class="text-muted small mb-0">Overview of statements and due dates across your linked accounts</p>
        </div>

        <div class="d-flex align-items-center gap-2">
            <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                <i class="bi bi-eye"></i>
                <span>View All Bills</span>
            </a>
            <a href="/cred-app/public/bills/add" class="btn btn-sm btn-royal-outline">
                <i class="bi bi-plus-lg"></i>
                <span>Add Bill</span>
            </a>
        </div>
    </div>

    <div class="card-body p-0">
        {if $bills|@count > 0}
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light" style="background-color: #faf8f5;">
                        <tr class="text-uppercase small fw-bold text-muted">
                            <th class="ps-4 py-3">Credit Card</th>
                            <th class="py-3">Statement Due</th>
                            <th class="py-3">Min Due</th>
                            <th class="py-3">Due Date & Urgency</th>
                            <th class="py-3">Status</th>
                            <th class="pe-4 py-3 text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $bills as $bill}
                        <tr>
                            <td class="ps-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-light border p-2 text-primary" style="width: 42px; height: 42px;">
                                        <i class="bi bi-credit-card-fill fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">{$bill.bank_name|default:$bill.card|default:'Credit Card'}</div>
                                        <small class="text-muted">{if !empty($bill.card_holder)}{$bill.card_holder}{/if}{if !empty($bill.masked_card_number)} &bull; {$bill.masked_card_number}{/if}</small>
                                    </div>
                                </div>
                            </td>
                            <td class="py-3">
                                <span class="fw-bold text-dark fs-6">₹{$bill.amount}</span>
                            </td>
                            <td class="py-3">
                                <span class="small fw-semibold text-secondary">₹{$bill.min_due|default:$bill.amount}</span>
                            </td>
                            <td class="py-3">
                                <div class="d-flex flex-column gap-1">
                                    <span class="small fw-semibold text-dark">
                                        <i class="bi bi-calendar3 me-1 text-muted"></i> {$bill.due_date}
                                    </span>
                                    {if $bill.urgency == 'overdue'}
                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-2 py-1 text-start" style="width: fit-content;">
                                            <i class="bi bi-exclamation-triangle-fill me-1"></i> {$bill.urgency_text}
                                        </span>
                                    {elseif $bill.urgency == 'due_today'}
                                        <span class="badge bg-danger text-white rounded-pill px-2 py-1 text-start" style="width: fit-content;">
                                            <i class="bi bi-clock-fill me-1"></i> {$bill.urgency_text}
                                        </span>
                                    {elseif $bill.urgency == 'due_soon'}
                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning rounded-pill px-2 py-1 text-start" style="width: fit-content;">
                                            <i class="bi bi-hourglass-top me-1"></i> {$bill.urgency_text}
                                        </span>
                                    {elseif $bill.urgency == 'paid'}
                                        <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-2 py-1 text-start" style="width: fit-content;">
                                            <i class="bi bi-check2-circle me-1"></i> Cleared
                                        </span>
                                    {else}
                                        <span class="badge bg-light text-muted border rounded-pill px-2 py-1 text-start" style="width: fit-content;">
                                            {$bill.urgency_text}
                                        </span>
                                    {/if}
                                </div>
                            </td>
                            <td class="py-3">
                                {if $bill.status == 'paid'}
                                    <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-3 py-2 fw-semibold">
                                        <i class="bi bi-check-circle-fill me-1"></i> Paid
                                    </span>
                                {else}
                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-2 fw-semibold">
                                        <i class="bi bi-hourglass-split me-1"></i> Pending
                                    </span>
                                {/if}
                            </td>
                            <td class="pe-4 py-3 text-end">
                                {if $bill.status == 'paid'}
                                    <button class="btn btn-sm btn-outline-success rounded-pill px-3" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#dashReceiptModal{$bill.id}">
                                        <i class="bi bi-receipt"></i> Receipt
                                    </button>

                                    <!-- Payment Receipt Modal -->
                                    <div class="modal fade" id="dashReceiptModal{$bill.id}" tabindex="-1" aria-labelledby="dashReceiptModalLabel{$bill.id}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 border-0 shadow-lg text-start">
                                                
                                                <div class="modal-header border-0 pb-0 text-center d-flex flex-column align-items-center position-relative pt-4">
                                                    <button type="button" class="btn-close position-absolute end-0 top-0 m-3" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-2" 
                                                         style="width: 58px; height: 58px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1.5px solid #10b981; color: #047857; font-size: 1.8rem; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25);">
                                                        <i class="bi bi-shield-check"></i>
                                                    </div>
                                                    <h5 class="modal-title fw-bold text-dark" id="dashReceiptModalLabel{$bill.id}">Payment Verified & Cleared</h5>
                                                    <p class="text-muted small mb-0">CRED Instant Settlement Receipt</p>
                                                </div>

                                                <div class="modal-body p-4">
                                                    <div class="p-3 rounded-4 mb-3 text-center" style="background: linear-gradient(135deg, #f8fafc 0%, #fef3c7 100%); border: 1px solid rgba(217, 119, 6, 0.2);">
                                                        <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Settled Amount</span>
                                                        <h2 class="fw-bold my-1 text-dark">₹{$bill.amount}</h2>
                                                        <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-3 py-1 small">
                                                            <i class="bi bi-check-all me-1"></i> Success & Verified
                                                        </span>
                                                    </div>

                                                    <div class="bg-light p-3 rounded-3 border text-start mb-3">
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Transaction ID</span>
                                                            <span class="font-monospace fw-bold text-dark">{$bill.txn_ref}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Card Details</span>
                                                            <span class="fw-semibold text-dark">{$bill.bank_name} ({$bill.masked_card_number})</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Card Holder</span>
                                                            <span class="fw-semibold text-dark">{$bill.card_holder}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Statement Due Date</span>
                                                            <span class="fw-semibold text-dark">{$bill.due_date}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 small">
                                                            <span class="text-muted">Settlement Time</span>
                                                            <span class="fw-semibold text-dark">{$bill.settlement_date}</span>
                                                        </div>
                                                    </div>

                                                    <div class="text-center small text-muted">
                                                        <i class="bi bi-shield-lock-fill text-success me-1"></i> Secured with 256-bit bank grade encryption.
                                                    </div>
                                                </div>

                                                <div class="modal-footer border-0 pt-0 justify-content-center gap-2 pb-4">
                                                    <button type="button" class="btn btn-royal-outline rounded-pill px-4 btn-sm" onclick="window.print();">
                                                        <i class="bi bi-printer"></i> Print Receipt
                                                    </button>
                                                    <button type="button" class="btn btn-secondary rounded-pill px-4 btn-sm" data-bs-dismiss="modal">
                                                        Close
                                                    </button>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                {else}
                                    <a href="/cred-app/public/payments/checkout?bill_id={$bill.id}" class="btn btn-sm btn-royal-primary rounded-pill px-3 shadow-sm text-decoration-none">
                                        <i class="bi bi-lightning-charge-fill"></i> Pay Now
                                    </a>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
        {else}
            <div class="text-center py-5">
                <div class="display-6 text-muted mb-3">
                    <i class="bi bi-receipt"></i>
                </div>
                <h5 class="fw-bold text-dark">No Bills Found</h5>
                <p class="text-muted mb-3" style="max-width: 400px; margin: 0 auto;">
                    You currently have no upcoming or past bills. When bills are generated for your linked cards, they will appear here.
                </p>
                <div class="d-flex align-items-center justify-content-center gap-2">
                    <a href="/cred-app/public/bills/add" class="btn btn-royal-primary">
                        <i class="bi bi-plus-circle"></i> Add Bill
                    </a>
                    <a href="/cred-app/public/cards/add" class="btn btn-royal-outline">
                        <i class="bi bi-credit-card"></i> Add Card
                    </a>
                </div>
            </div>
        {/if}
    </div>
</div>

{/block}
