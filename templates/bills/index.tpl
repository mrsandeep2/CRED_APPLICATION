{extends file="../layouts/main.tpl"}

{block name="title"}
    My Bills & Statements | CRED Heritage & Modern
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
        <span class="fw-bold text-dark">Credit Card Bills</span>
    </div>

    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/payments/history" class="btn btn-sm btn-outline-warning text-dark rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b;">
            <i class="bi bi-journal-text text-warning"></i>
            <span>Transaction Ledger</span>
        </a>
        <a href="/cred-app/public/cards" class="btn btn-sm btn-outline-primary rounded-pill px-3">
            <i class="bi bi-wallet2"></i>
            <span>My Cards</span>
        </a>
        <a href="/cred-app/public/bills/add" class="btn btn-royal-primary btn-sm px-3 py-2 rounded-pill shadow-sm">
            <i class="bi bi-plus-circle-fill"></i>
            <span>Add Bill</span>
        </a>
    </div>
</div>

<!-- Header Section & Quick Metrics -->
<div class="row g-4 mb-4 align-items-stretch">
    <div class="col-lg-6">
        <div class="card cred-card h-100 p-4" style="background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Total Outstanding Balance</span>
                    <h2 class="fw-bold my-2 text-dark">₹{$total_due|default:'0.00'}</h2>
                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-1 small">
                        <i class="bi bi-clock-history me-1"></i> {$pending_bills|default:0} Active Statements Due
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 58px; height: 58px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1px solid #f59e0b; color: #b45309; font-size: 1.6rem; box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);">
                    <i class="bi bi-receipt-cutoff"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-6">
        <div class="card cred-card h-100 p-4" style="background: linear-gradient(135deg, #f0fdf4 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Cleared & Settled Statements</span>
                    <h2 class="fw-bold my-2 text-dark">{$paid_bills|default:0} <span class="fs-6 fw-normal text-muted">Statements</span></h2>
                    <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-3 py-1 small">
                        <i class="bi bi-check-circle-fill me-1"></i> {if $paid_bills > 0}{$paid_bills} Settled Statements{else}0 Settled Statements{/if}
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 58px; height: 58px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1px solid #10b981; color: #047857; font-size: 1.6rem; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);">
                    <i class="bi bi-patch-check-fill"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bills Table Card with Tab Filters -->
<div class="card cred-card shadow-sm border-0">
    <div class="card-header bg-white border-bottom p-4 d-flex flex-wrap align-items-center justify-content-between gap-3">
        <div>
            <h4 class="fw-bold mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-wallet2 text-warning"></i>
                <span>Statement History & Active Bills</span>
            </h4>
            <p class="text-muted small mb-0">Track upcoming dues, partial allocations, and settle statements.</p>
        </div>

        <!-- Filter Tabs -->
        <div class="d-flex align-items-center gap-2 p-1 bg-light rounded-pill border">
            <button class="btn btn-sm rounded-pill px-3 fw-semibold bill-filter-btn active" data-filter="all" onclick="filterBills('all', this)">
                All <span class="badge bg-secondary ms-1">{$all_count|default:0}</span>
            </button>
            <button class="btn btn-sm rounded-pill px-3 fw-semibold bill-filter-btn text-warning-emphasis" data-filter="pending" onclick="filterBills('pending', this)">
                Active Due <span class="badge bg-warning text-dark ms-1">{$pending_bills|default:0}</span>
            </button>
            <button class="btn btn-sm rounded-pill px-3 fw-semibold bill-filter-btn text-success" data-filter="paid" onclick="filterBills('paid', this)">
                Settled <span class="badge bg-success ms-1">{$paid_bills|default:0}</span>
            </button>
        </div>
    </div>

    <div class="card-body p-0">
        {if !empty($bills)}
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="billsTable">
                    <thead class="table-light" style="background-color: #faf8f5;">
                        <tr class="text-uppercase small fw-bold text-muted">
                            <th class="ps-4 py-3">Card Details</th>
                            <th class="py-3">Statement Due</th>
                            <th class="py-3">Min Due</th>
                            <th class="py-3">Due Date & Urgency</th>
                            <th class="py-3">Status</th>
                            <th class="pe-4 py-3 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $bills as $bill}
                        <tr class="bill-row" data-status="{if $bill.derived_code == 'paid'}paid{else}pending{/if}">
                            <td class="ps-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-light border p-2 text-primary" style="width: 44px; height: 44px;">
                                        <i class="bi bi-credit-card-2-front-fill fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">{$bill.bank_name|default:$bill.card|default:'Credit Card'}</div>
                                        <small class="text-muted">
                                            {if !empty($bill.card_holder)}{$bill.card_holder}{/if}
                                            {if !empty($bill.masked_card_number)} &bull; {$bill.masked_card_number}{/if}
                                        </small>
                                    </div>
                                </div>
                            </td>
                            <td class="py-3">
                                <span class="fw-bold text-dark fs-6">₹{$bill.remaining_amount}</span>
                                {if $bill.paid_amount > 0 && $bill.derived_code != 'paid'}
                                    <div class="small text-muted">
                                        Total: ₹{$bill.amount} &bull; <span class="text-success fw-semibold">₹{$bill.paid_amount} paid</span>
                                    </div>
                                {/if}
                            </td>
                            <td class="py-3">
                                <span class="small fw-semibold text-secondary">₹{$bill.min_due|default:$bill.remaining_amount}</span>
                            </td>
                            <td class="py-3">
                                <div class="d-flex flex-column gap-1">
                                    <span class="small fw-semibold text-dark">
                                        <i class="bi bi-calendar3 me-1 text-muted"></i> {$bill.due_date}
                                    </span>
                                    {if $bill.derived_code == 'overdue'}
                                        <span class="badge bg-danger text-white rounded-pill px-2 py-1 text-start" style="width: fit-content;">
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
                                    {elseif $bill.derived_code == 'paid'}
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
                                <span class="badge {$bill.derived_badge} rounded-pill px-3 py-2 fw-semibold">
                                    {if $bill.derived_code == 'paid'}
                                        <i class="bi bi-check-circle-fill me-1"></i> Paid
                                    {elseif $bill.derived_code == 'overdue'}
                                        <i class="bi bi-exclamation-octagon-fill me-1"></i> Overdue
                                    {elseif $bill.derived_code == 'partially_paid'}
                                        <i class="bi bi-pie-chart-fill me-1"></i> Partially Paid
                                    {else}
                                        <i class="bi bi-hourglass-split me-1"></i> Pending
                                    {/if}
                                </span>
                            </td>
                            <td class="pe-4 py-3 text-end">
                                <div class="d-flex align-items-center justify-content-end gap-2">
                                    {if $bill.derived_code == 'paid'}
                                        <button class="btn btn-sm btn-outline-success rounded-pill px-3" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#receiptModal{$bill.id}">
                                            <i class="bi bi-receipt"></i> Receipt
                                        </button>
                                    {else}
                                        <a href="/cred-app/public/payments/checkout?bill_id={$bill.id}" class="btn btn-sm btn-royal-primary rounded-pill px-3 shadow-sm text-decoration-none">
                                            <i class="bi bi-lightning-charge-fill"></i> Pay Bill
                                        </a>
                                    {/if}

                                    <!-- Delete Bill Action -->
                                    <form method="POST" action="/cred-app/public/bills/delete" class="d-inline m-0" onsubmit="return confirm('Are you sure you want to remove this statement record?');">
                                        <input type="hidden" name="id" value="{$bill.id|default:0}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2" title="Remove Statement">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </form>
                                </div>

                                {if $bill.derived_code == 'paid'}
                                    <!-- Payment Receipt Modal -->
                                    <div class="modal fade" id="receiptModal{$bill.id}" tabindex="-1" aria-labelledby="receiptModalLabel{$bill.id}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 border-0 shadow-lg" id="receiptCard{$bill.id}">
                                                
                                                <!-- Modal Header -->
                                                <div class="modal-header border-0 pb-0 text-center d-flex flex-column align-items-center position-relative pt-4">
                                                    <button type="button" class="btn-close position-absolute end-0 top-0 m-3" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-2" 
                                                         style="width: 58px; height: 58px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1.5px solid #10b981; color: #047857; font-size: 1.8rem; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25);">
                                                        <i class="bi bi-shield-check"></i>
                                                    </div>
                                                    <h5 class="modal-title fw-bold text-dark" id="receiptModalLabel{$bill.id}">Payment Verified & Cleared</h5>
                                                    <p class="text-muted small mb-0">CRED Instant Settlement Receipt</p>
                                                </div>

                                                <!-- Modal Body: Receipt Details -->
                                                <div class="modal-body p-4">
                                                    
                                                    <!-- Amount Banner -->
                                                    <div class="p-3 rounded-4 mb-3 text-center" style="background: linear-gradient(135deg, #f8fafc 0%, #fef3c7 100%); border: 1px solid rgba(217, 119, 6, 0.2);">
                                                        <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Settled Statement Amount</span>
                                                        <h2 class="fw-bold my-1 text-dark">₹{$bill.amount}</h2>
                                                        <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-3 py-1 small">
                                                            <i class="bi bi-check-all me-1"></i> Success & Verified
                                                        </span>
                                                    </div>

                                                    <!-- Receipt Meta List -->
                                                    <div class="bg-light p-3 rounded-3 border text-start mb-3">
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Statement Reference</span>
                                                            <span class="font-monospace fw-bold text-dark">#STMT-{$bill.id}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Card Account</span>
                                                            <span class="fw-semibold text-dark">{$bill.bank_name} ({$bill.masked_card_number})</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 border-bottom small">
                                                            <span class="text-muted">Card Holder</span>
                                                            <span class="fw-semibold text-dark">{$bill.card_holder}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between py-1 small">
                                                            <span class="text-muted">Statement Due Date</span>
                                                            <span class="fw-semibold text-dark">{$bill.due_date}</span>
                                                        </div>
                                                    </div>

                                                    <div class="text-center small text-muted">
                                                        <i class="bi bi-shield-lock-fill text-success me-1"></i> Recorded in audited financial ledger.
                                                    </div>
                                                </div>

                                                <!-- Modal Footer -->
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
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>

            <!-- Empty Filter State (Shown when no bills match selected tab) -->
            <div id="noFilterResults" class="text-center py-5 d-none">
                <div class="display-6 text-muted mb-2">
                    <i class="bi bi-funnel"></i>
                </div>
                <h6 class="fw-bold text-dark">No bills in this category</h6>
                <p class="text-muted small mb-0">Switch tabs to view other statement records.</p>
            </div>
        {else}
            <!-- Empty State -->
            <div class="text-center py-5">
                <div class="display-6 text-muted mb-3">
                    <i class="bi bi-receipt"></i>
                </div>
                <h5 class="fw-bold text-dark">No Bills Found</h5>
                <p class="text-muted mb-4" style="max-width: 420px; margin: 0 auto;">
                    You do not have any bills recorded yet. Add your first credit card bill to track statements and manage payments.
                </p>
                <div class="d-flex align-items-center justify-content-center gap-2">
                    <a href="/cred-app/public/bills/add" class="btn btn-royal-primary">
                        <i class="bi bi-plus-circle-fill"></i>
                        <span>Add Bill</span>
                    </a>
                    <a href="/cred-app/public/" class="btn btn-royal-outline">
                        <i class="bi bi-house-door"></i>
                        <span>Back to Dashboard</span>
                    </a>
                </div>
            </div>
        {/if}
    </div>
</div>

<script>
function filterBills(status, btn) {
    // Update active tab styles
    document.querySelectorAll('.bill-filter-btn').forEach(function(b) {
        b.classList.remove('active', 'bg-white', 'shadow-sm');
    });
    btn.classList.add('active', 'bg-white', 'shadow-sm');

    var rows = document.querySelectorAll('.bill-row');
    var visibleCount = 0;

    rows.forEach(function(row) {
        var rowStatus = row.getAttribute('data-status');
        if (status === 'all' || rowStatus === status) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    var emptyNotice = document.getElementById('noFilterResults');
    if (emptyNotice) {
        if (visibleCount === 0) {
            emptyNotice.classList.remove('d-none');
        } else {
            emptyNotice.classList.add('d-none');
        }
    }
}
</script>

{/block}
