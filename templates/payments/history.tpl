{extends file="../layouts/main.tpl"}

{block name="title"}
    Payment History & Transaction Ledger | CRED Royal Experience
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
        <span class="fw-bold text-dark">Payment History</span>
    </div>

    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/payments/analytics" class="btn btn-sm btn-outline-warning text-dark rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b;">
            <i class="bi bi-graph-up-arrow text-warning"></i>
            <span>Analytics</span>
        </a>
        <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-primary rounded-pill px-3">
            <i class="bi bi-receipt-cutoff"></i>
            <span>View Bills</span>
        </a>
        <a href="/cred-app/public/cards" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
            <i class="bi bi-wallet2"></i>
            <span>My Cards</span>
        </a>
    </div>
</div>

<!-- Header Section & Quick Metrics -->
<div class="row g-4 mb-4 align-items-stretch">
    <!-- Metric 1: Total Volume Settled -->
    <div class="col-md-4">
        <div class="card cred-card h-100 p-4 shadow-sm" style="background: linear-gradient(135deg, #f0fdf4 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Total Volume Settled</span>
                    <h2 class="fw-bold my-2 text-dark">₹{$total_settled_amount|default:'0.00'}</h2>
                    <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-3 py-1 small">
                        <i class="bi bi-check-circle-fill me-1"></i> {$success_count|default:0} Cleared Payments
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 56px; height: 56px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1px solid #10b981; color: #047857; font-size: 1.6rem; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);">
                    <i class="bi bi-cash-stack"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Metric 2: Cashback & Rewards Earned -->
    <div class="col-md-4">
        <div class="card cred-card h-100 p-4 shadow-sm" style="background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Total Cashback Earned</span>
                    <h2 class="fw-bold my-2 text-dark">₹{$total_cashback_earned|default:'0.00'}</h2>
                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-1 small">
                        <i class="bi bi-stars me-1"></i> CRED Rewards Active
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 56px; height: 56px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1px solid #f59e0b; color: #b45309; font-size: 1.6rem; box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);">
                    <i class="bi bi-gift-fill"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Metric 3: Total Transactions -->
    <div class="col-md-4">
        <div class="card cred-card h-100 p-4 shadow-sm" style="background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Ledger Records</span>
                    <h2 class="fw-bold my-2 text-dark">{$all_count|default:0} <span class="fs-6 fw-normal text-muted">Transactions</span></h2>
                    <span class="badge bg-primary-subtle text-primary-emphasis border border-primary-subtle rounded-pill px-3 py-1 small">
                        <i class="bi bi-shield-check me-1"></i> Immutable Audit
                    </span>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-4" style="width: 56px; height: 56px; background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); border: 1px solid #3b82f6; color: #1e3a8a; font-size: 1.6rem; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);">
                    <i class="bi bi-journal-text"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Ledger Card -->
<div class="card cred-card shadow-sm border-0">
    
    <div class="card-header bg-white border-bottom p-4 d-flex flex-wrap align-items-center justify-content-between gap-3">
        <div>
            <h4 class="fw-bold mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-journal-check text-warning"></i>
                <span>Payment History & Transaction Ledger</span>
            </h4>
            <p class="text-muted small mb-0">Permanent financial records of all processed statement settlements.</p>
        </div>

        <div class="d-flex flex-wrap align-items-center gap-2">
            <!-- Search Input -->
            <div class="input-group input-group-sm" style="max-width: 250px;">
                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                <input type="text" class="form-control border-start-0 bg-light" id="historySearchInput" placeholder="Search by Txn ID..." onkeyup="filterHistory()">
            </div>

            <!-- Filter Tabs -->
            <div class="d-flex align-items-center gap-1 p-1 bg-light rounded-pill border">
                <button class="btn btn-sm rounded-pill px-3 fw-semibold hist-filter-btn active bg-white shadow-sm" data-status="all" onclick="setHistoryFilter('all', this)">
                    All <span class="badge bg-secondary ms-1">{$all_count|default:0}</span>
                </button>
                <button class="btn btn-sm rounded-pill px-3 fw-semibold hist-filter-btn text-success" data-status="success" onclick="setHistoryFilter('success', this)">
                    Success <span class="badge bg-success ms-1">{$success_count|default:0}</span>
                </button>
                {if $failed_count > 0}
                    <button class="btn btn-sm rounded-pill px-3 fw-semibold hist-filter-btn text-danger" data-status="failed" onclick="setHistoryFilter('failed', this)">
                        Failed <span class="badge bg-danger ms-1">{$failed_count|default:0}</span>
                    </button>
                {/if}
            </div>
        </div>
    </div>

    <div class="card-body p-0">
        {if !empty($payments)}
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="historyTable">
                    <thead class="table-light" style="background-color: #faf8f5;">
                        <tr class="text-uppercase small fw-bold text-muted">
                            <th class="ps-4 py-3">Transaction Info</th>
                            <th class="py-3">Card / Bill</th>
                            <th class="py-3">Amount</th>
                            <th class="py-3">Method</th>
                            <th class="py-3">Status</th>
                            <th class="pe-4 py-3 text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $payments as $p}
                        <tr class="payment-row" data-status="{$p.status}" data-search="{$p.transaction_id|lower} {$p.gateway_reference|lower} {$p.bank_name|lower} {$p.payment_method_label|lower}">
                            
                            <!-- Transaction Info -->
                            <td class="ps-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-light border p-2 text-primary" style="width: 44px; height: 44px;">
                                        <i class="bi {$p.payment_method_icon} fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="font-monospace fw-bold text-dark small" style="letter-spacing: 0.5px;">{$p.transaction_id}</div>
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>{$p.paid_at}
                                        </small>
                                    </div>
                                </div>
                            </td>

                            <!-- Card / Bill -->
                            <td class="py-3">
                                <div class="fw-semibold text-dark">{$p.bank_name}</div>
                                <small class="text-muted">{$p.masked_card} &bull; {$p.card_holder}</small>
                            </td>

                            <!-- Amount & Cashback -->
                            <td class="py-3">
                                <span class="fw-bold text-dark fs-6">₹{$p.amount}</span>
                                {if (float)$p.cashback_earned > 0}
                                    <div class="text-success small fw-semibold">
                                        <i class="bi bi-gift-fill me-1"></i>+₹{$p.cashback_earned} Cashback
                                    </div>
                                {/if}
                            </td>

                            <!-- Method Badge -->
                            <td class="py-3">
                                <span class="badge bg-light text-dark border rounded-pill px-3 py-1 fw-semibold small">
                                    {$p.payment_method_label}
                                </span>
                            </td>

                            <!-- Status Badge -->
                            <td class="py-3">
                                <span class="badge {$p.status_badge_class} rounded-pill px-3 py-2 fw-semibold">
                                    {if $p.status == 'success'}
                                        <i class="bi bi-check-circle-fill me-1"></i> Success
                                    {elseif $p.status == 'failed'}
                                        <i class="bi bi-x-circle-fill me-1"></i> Failed
                                    {else}
                                        <i class="bi bi-hourglass-split me-1"></i> Processing
                                    {/if}
                                </span>
                            </td>

                            <!-- Actions: Details Modal -->
                            <td class="pe-4 py-3 text-end">
                                <button class="btn btn-sm btn-royal-outline rounded-pill px-3" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#paymentDetailModal{$p.id}">
                                    <i class="bi bi-receipt"></i> Details
                                </button>

                                <!-- Transaction Detail Modal -->
                                <div class="modal fade text-start" id="paymentDetailModal{$p.id}" tabindex="-1" aria-labelledby="detailLabel{$p.id}" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content rounded-4 border-0 shadow-lg">
                                            
                                            <!-- Modal Header -->
                                            <div class="modal-header border-0 pb-0 text-center d-flex flex-column align-items-center position-relative pt-4">
                                                <button type="button" class="btn-close position-absolute end-0 top-0 m-3" data-bs-dismiss="modal" aria-label="Close"></button>
                                                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-2" 
                                                     style="width: 58px; height: 58px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 1.5px solid #10b981; color: #047857; font-size: 1.8rem; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25);">
                                                    <i class="bi bi-shield-check"></i>
                                                </div>
                                                <h5 class="modal-title fw-bold text-dark" id="detailLabel{$p.id}">Official Transaction Receipt</h5>
                                                <p class="text-muted small mb-0">CRED Verified Payment Record</p>
                                            </div>

                                            <!-- Modal Body -->
                                            <div class="modal-body p-4">
                                                
                                                <!-- Amount Banner -->
                                                <div class="p-3 rounded-4 mb-3 text-center" style="background: linear-gradient(135deg, #f8fafc 0%, #fef3c7 100%); border: 1px solid rgba(217, 119, 6, 0.2);">
                                                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Settled Amount</span>
                                                    <h2 class="fw-bold my-1 text-dark">₹{$p.amount}</h2>
                                                    <span class="badge {$p.status_badge_class} rounded-pill px-3 py-1 small">
                                                        <i class="bi bi-check-all me-1"></i> {$p.status_label} &bull; 100% Verified
                                                    </span>
                                                </div>

                                                <!-- Meta List -->
                                                <div class="bg-light p-3 rounded-3 border text-start mb-3">
                                                    <div class="d-flex justify-content-between py-1 border-bottom small">
                                                        <span class="text-muted">Transaction ID</span>
                                                        <span class="font-monospace fw-bold text-dark">{$p.transaction_id}</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between py-1 border-bottom small">
                                                        <span class="text-muted">Gateway Reference</span>
                                                        <span class="font-monospace text-muted">{$p.gateway_reference}</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between py-1 border-bottom small">
                                                        <span class="text-muted">Payment Channel</span>
                                                        <span class="fw-semibold text-dark">{$p.payment_method_label}</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between py-1 border-bottom small">
                                                        <span class="text-muted">Card Account</span>
                                                        <span class="fw-semibold text-dark">{$p.bank_name} ({$p.masked_card})</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between py-1 border-bottom small">
                                                        <span class="text-muted">Card Holder</span>
                                                        <span class="fw-semibold text-dark">{$p.card_holder}</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between py-1 border-bottom small">
                                                        <span class="text-muted">Cashback Credited</span>
                                                        <span class="fw-bold text-success">₹{$p.cashback_earned}</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between py-1 small">
                                                        <span class="text-muted">Timestamp</span>
                                                        <span class="fw-semibold text-dark">{$p.paid_at}</span>
                                                    </div>
                                                </div>

                                                <div class="text-center small text-muted">
                                                    <i class="bi bi-shield-lock-fill text-success me-1"></i> Recorded in permanent encrypted ledger.
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
                            </td>

                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>

            <!-- No Results from Search/Filter -->
            <div id="noHistoryResults" class="text-center py-5 d-none">
                <div class="display-6 text-muted mb-2">
                    <i class="bi bi-funnel"></i>
                </div>
                <h6 class="fw-bold text-dark">No matching transactions found</h6>
                <p class="text-muted small mb-0">Try adjusting your search query or filter criteria.</p>
            </div>
        {else}
            <!-- Empty State -->
            <div class="text-center py-5">
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" 
                     style="width: 80px; height: 80px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; color: #b45309; font-size: 2.5rem; box-shadow: 0 6px 18px rgba(245, 158, 11, 0.2);">
                    <i class="bi bi-journal-x"></i>
                </div>
                <h4 class="fw-bold mb-2 text-dark">No Payment Transactions Yet</h4>
                <p class="text-muted mb-4" style="max-width: 440px; margin: 0 auto;">
                    When you settle credit card statements through the checkout flow, permanent immutable transaction records and receipts will appear here.
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
    </div>

</div>

<script>
var currentHistoryStatus = 'all';

function setHistoryFilter(status, btn) {
    currentHistoryStatus = status;
    document.querySelectorAll('.hist-filter-btn').forEach(function(b) {
        b.classList.remove('active', 'bg-white', 'shadow-sm');
    });
    btn.classList.add('active', 'bg-white', 'shadow-sm');
    filterHistory();
}

function filterHistory() {
    var query = (document.getElementById('historySearchInput') ? document.getElementById('historySearchInput').value : '').toLowerCase().trim();
    var rows = document.querySelectorAll('.payment-row');
    var visibleCount = 0;

    rows.forEach(function(row) {
        var rowStatus = row.getAttribute('data-status');
        var rowSearch = row.getAttribute('data-search') || '';

        var matchesStatus = (currentHistoryStatus === 'all' || rowStatus === currentHistoryStatus);
        var matchesSearch = (query === '' || rowSearch.indexOf(query) !== -1);

        if (matchesStatus && matchesSearch) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    var emptyNotice = document.getElementById('noHistoryResults');
    if (emptyNotice) {
        if (visibleCount === 0 && rows.length > 0) {
            emptyNotice.classList.remove('d-none');
        } else {
            emptyNotice.classList.add('d-none');
        }
    }
}
</script>

{/block}
