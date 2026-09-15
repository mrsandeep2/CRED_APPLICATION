{extends file="../layouts/main.tpl"}

{block name="title"}
    Payment Failed | CRED Platform
{/block}

{block name="content"}

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        
        <div class="card cred-card shadow-lg border-0 mb-4">
            
            <div class="card-body p-4 p-md-5 text-center">
                
                <!-- Failure Icon -->
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" 
                     style="width: 80px; height: 80px; background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); border: 2px solid #ef4444; color: #b91c1c; font-size: 2.5rem; box-shadow: 0 8px 20px rgba(239, 68, 68, 0.25);">
                    <i class="bi bi-x-circle-fill"></i>
                </div>

                <h3 class="fw-bold text-dark mb-1">
                    Payment Simulation Declined
                </h3>
                <p class="text-muted small mb-4">
                    Your payment could not be processed by the simulated gateway channel.
                </p>

                <!-- Amount & Status Info -->
                <div class="p-4 rounded-4 mb-4" style="background: linear-gradient(135deg, #fef2f2 0%, #ffffff 100%); border: 1px solid rgba(239, 68, 68, 0.25);">
                    <span class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.8px;">Attempted Amount</span>
                    <h2 class="fw-bold my-1 text-danger">₹{$payment.amount}</h2>
                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-3 py-1 small fw-semibold">
                        <i class="bi bi-exclamation-octagon-fill me-1"></i> Statement Remains Pending
                    </span>
                </div>

                <!-- Reassurance Note -->
                <div class="p-3 bg-light rounded-3 border text-start mb-4 small text-muted">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="fw-semibold text-dark">Transaction ID</span>
                        <span class="font-monospace">{$payment.transaction_id}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="fw-semibold text-dark">Gateway Reference</span>
                        <span class="font-monospace">{$payment.gateway_reference}</span>
                    </div>
                    <div class="text-muted border-top pt-2">
                        <i class="bi bi-info-circle text-primary me-1"></i> No funds were deducted. You can retry anytime before the due date.
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex flex-wrap align-items-center justify-content-center gap-3">
                    <a href="/cred-app/public/payments/checkout?bill_id={$payment.bill_id}" class="btn btn-royal-primary rounded-pill px-4 shadow">
                        <i class="bi bi-arrow-repeat"></i>
                        <span>Retry Payment</span>
                    </a>

                    <a href="/cred-app/public/bills" class="btn btn-royal-outline rounded-pill px-4">
                        <i class="bi bi-receipt-cutoff"></i>
                        <span>Back to Bills</span>
                    </a>
                </div>

            </div>
        </div>

    </div>
</div>

{/block}
