{extends file="../layouts/main.tpl"}

{block name="title"}
    Payment Successful | CRED Royal Experience
{/block}

{block name="content"}

<div class="row justify-content-center">
    <div class="col-md-9 col-lg-7">
        
        <!-- Luxury Success Card -->
        <div class="card cred-card shadow-lg border-0 mb-4" id="successReceiptCard">
            
            <div class="card-body p-4 p-md-5 text-center">
                
                <!-- Success Seal -->
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3 position-relative" 
                     style="width: 84px; height: 84px; background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%); border: 2px solid #10b981; color: #047857; font-size: 2.8rem; box-shadow: 0 10px 25px rgba(16, 185, 129, 0.3);">
                    <i class="bi bi-patch-check-fill"></i>
                </div>

                <h2 class="fw-bold text-dark mb-1">
                    Payment Completed Successfully
                </h2>
                <p class="text-muted small mb-4">
                    Your credit card statement has been verified, cleared, and permanently logged in your ledger.
                </p>

                <!-- Amount Banner -->
                <div class="p-4 rounded-4 mb-4" style="background: linear-gradient(135deg, #f8fafc 0%, #fef3c7 100%); border: 1.5px solid rgba(217, 119, 6, 0.25);">
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Amount Settled</span>
                    <h1 class="display-6 fw-bold my-1 text-dark">₹{$payment.amount}</h1>
                    <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-3 py-1 small fw-semibold">
                        <i class="bi bi-check-all me-1"></i> Instant Clearance &bull; 100% On-Time
                    </span>
                </div>

                <!-- Reward Banner -->
                <div class="p-3 rounded-4 mb-4 d-flex align-items-center justify-content-between text-start" 
                     style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; box-shadow: 0 4px 15px rgba(245, 158, 11, 0.2);">
                    <div class="d-flex align-items-center gap-3">
                        <div class="fs-2 text-warning">
                            <i class="bi bi-gift-fill" style="color: #b45309;"></i>
                        </div>
                        <div>
                            <div class="fw-bold text-dark fs-6">₹{$payment.cashback_earned} Cashback &bull; {$payment.reward_points} CRED Coins</div>
                            <small class="text-muted">Rewards successfully credited to your member account.</small>
                        </div>
                    </div>
                    <span class="badge bg-white text-warning-emphasis border rounded-pill px-3 py-2 fw-bold shadow-sm">
                        <i class="bi bi-stars text-warning me-1"></i> Claimed
                    </span>
                </div>

                <!-- Transaction Details Table -->
                <div class="bg-light p-4 rounded-4 border text-start mb-4">
                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-receipt text-warning"></i>
                        <span>Permanent Transaction Record</span>
                    </h6>

                    <div class="d-flex justify-content-between py-2 border-bottom small">
                        <span class="text-muted">Transaction ID</span>
                        <span class="font-monospace fw-bold text-dark">{$payment.transaction_id}</span>
                    </div>

                    <div class="d-flex justify-content-between py-2 border-bottom small">
                        <span class="text-muted">Gateway Reference</span>
                        <span class="font-monospace text-muted">{$payment.gateway_reference}</span>
                    </div>

                    <div class="d-flex justify-content-between py-2 border-bottom small">
                        <span class="text-muted">Payment Channel</span>
                        <span class="fw-semibold text-dark">{$payment.payment_method_label}</span>
                    </div>

                    <div class="d-flex justify-content-between py-2 border-bottom small">
                        <span class="text-muted">Card Details</span>
                        <span class="fw-semibold text-dark">{$payment.bank_name} ({$payment.masked_card})</span>
                    </div>

                    <div class="d-flex justify-content-between py-2 border-bottom small">
                        <span class="text-muted">Card Holder</span>
                        <span class="fw-semibold text-dark">{$payment.card_holder}</span>
                    </div>

                    <div class="d-flex justify-content-between py-2 small">
                        <span class="text-muted">Settlement Date & Time</span>
                        <span class="fw-semibold text-dark">{$payment.paid_at}</span>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex flex-wrap align-items-center justify-content-center gap-3">
                    <button type="button" class="btn btn-royal-outline rounded-pill px-4" onclick="window.print();">
                        <i class="bi bi-printer"></i>
                        <span>Print Official Receipt</span>
                    </button>

                    <a href="/cred-app/public/bills" class="btn btn-royal-primary rounded-pill px-4 shadow">
                        <i class="bi bi-receipt-cutoff"></i>
                        <span>View All Bills</span>
                    </a>

                    <a href="/cred-app/public/" class="btn btn-outline-secondary rounded-pill px-4">
                        <i class="bi bi-house-door"></i>
                        <span>Dashboard</span>
                    </a>
                </div>

            </div>
        </div>

    </div>
</div>

{/block}
