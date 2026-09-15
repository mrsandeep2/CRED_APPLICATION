{extends file="../layouts/main.tpl"}

{block name="title"}
    Secure Flexible Checkout | CRED Royal Experience
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
        <span class="fw-bold text-dark">Flexible Checkout</span>
    </div>

    <div>
        <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
            <i class="bi bi-arrow-left"></i>
            <span>Back to Bills</span>
        </a>
    </div>
</div>

<div class="row g-4 justify-content-center align-items-start">

    <!-- Left Column: Bill Summary & Card Badge -->
    <div class="col-lg-5">
        <div class="card cred-card shadow-sm sticky-top" style="top: 100px;">
            <div class="card-body p-4">
                
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-1 fw-semibold small">
                        <i class="bi bi-receipt-cutoff me-1"></i> Statement Summary
                    </span>
                    <span class="badge bg-{$bill.urgency_class|default:'secondary'}-subtle text-{$bill.urgency_class|default:'secondary'} border border-{$bill.urgency_class|default:'secondary'}-subtle rounded-pill px-2 py-1 small">
                        {$bill.urgency_badge}
                    </span>
                </div>

                <!-- 3D Mini Credit Card Card -->
                <div class="p-4 text-white text-start rounded-4 position-relative overflow-hidden mb-3 shadow"
                     style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 50%, #b45309 100%); min-height: 180px; border: 1.5px solid rgba(254, 243, 199, 0.4);">
                    
                    <div style="position: absolute; right: -15px; bottom: -15px; opacity: 0.12; font-size: 8rem; pointer-events: none; line-height: 1;">
                        <i class="bi bi-shield-fill-check"></i>
                    </div>

                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <div class="fw-bold fs-6 text-truncate pe-2 text-warning">
                            {$bill.bank_name|upper}
                        </div>
                        <div class="fs-5 text-warning">
                            <i class="bi bi-wifi"></i>
                        </div>
                    </div>

                    <div class="mb-2 d-inline-flex align-items-center justify-content-center rounded-2 px-1"
                         style="background: linear-gradient(135deg, #fde68a 0%, #d97706 100%); border: 1px solid #fef3c7; width: 34px; height: 26px;">
                        <div style="width: 100%; height: 1px; background: rgba(0,0,0,0.2);"></div>
                    </div>

                    <div class="fs-6 fw-bold mb-3 font-monospace text-light" style="letter-spacing: 2px;">
                        {$bill.masked_card_number}
                    </div>

                    <div class="d-flex align-items-end justify-content-between">
                        <div>
                            <div class="text-uppercase text-white-50" style="font-size: 0.65rem; letter-spacing: 0.8px;">Card Holder</div>
                            <div class="fw-bold text-uppercase text-truncate small" style="max-width: 160px; letter-spacing: 0.5px;">
                                {$bill.card_holder}
                            </div>
                        </div>

                        <div class="text-end">
                            <div class="text-uppercase text-white-50" style="font-size: 0.65rem; letter-spacing: 0.8px;">Due Date</div>
                            <div class="fw-bold font-monospace small">
                                {$bill.due_date}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Amount Breakdown -->
                <div class="p-3 bg-light rounded-3 border mb-3">
                    <div class="d-flex align-items-center justify-content-between mb-2 small">
                        <span class="text-muted">Total Statement Bill</span>
                        <span class="fw-semibold text-dark">₹{$bill.total_amount}</span>
                    </div>
                    {if $bill.paid_amount > 0}
                    <div class="d-flex align-items-center justify-content-between mb-2 small">
                        <span class="text-muted">Previously Paid / Allocated</span>
                        <span class="text-success fw-semibold">- ₹{$bill.paid_amount}</span>
                    </div>
                    {/if}
                    <div class="d-flex align-items-center justify-content-between mb-2 small">
                        <span class="text-muted">Remaining Balance Due</span>
                        <span class="fw-bold text-dark fs-6">₹{$bill.remaining_due}</span>
                    </div>
                    <div class="d-flex align-items-center justify-content-between mb-2 small text-muted">
                        <span>Platform Convenience Fee</span>
                        <span class="text-success fw-semibold">FREE (₹0.00)</span>
                    </div>
                    <hr class="my-2 opacity-25">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="fw-bold text-dark d-block">You are Paying</span>
                            <small class="text-muted" id="summarySelectedLabel">Full Remaining Balance</small>
                        </div>
                        <span class="fw-bold fs-4" style="color: #b45309;" id="summaryPayAmount">₹{$bill.remaining_due}</span>
                    </div>
                </div>

                <!-- Reward Highlight -->
                <div class="p-3 rounded-3 mb-2 d-flex align-items-center gap-3" style="background: linear-gradient(135deg, #fef3c7 0%, #fffbeb 100%); border: 1px solid #f59e0b;">
                    <div class="fs-3 text-warning">
                        <i class="bi bi-gift-fill"></i>
                    </div>
                    <div>
                        <div class="fw-bold text-dark small">Instant CRED Rewards</div>
                        <small class="text-muted">Earn guaranteed cashback & 10x reward coins on settled amount.</small>
                    </div>
                </div>

                <div class="text-center small text-muted mt-3">
                    <i class="bi bi-shield-lock-fill text-success me-1"></i> Bank-grade simulated end-to-end encryption.
                </div>

            </div>
        </div>
    </div>

    <!-- Right Column: Interactive Amount Selector, Method Selector & Checkout Form -->
    <div class="col-lg-7">
        <div class="card cred-card shadow-sm">
            <div class="card-body p-4 p-md-5">

                <!-- Step 1: Flexible Payment Amount Selection -->
                <div class="mb-4">
                    <span class="badge bg-warning text-dark fw-bold rounded-pill px-3 py-1 mb-2">Step 1</span>
                    <h4 class="fw-bold text-dark mb-1">Choose Payment Amount</h4>
                    <p class="text-muted small mb-0">Select how much of your statement balance you want to settle today.</p>
                </div>

                <form method="POST" action="/cred-app/public/payments/process" id="paymentCheckoutForm" onsubmit="return handlePaymentSubmit(event);">
                    
                    <!-- Hidden Bill ID & Idempotency Key -->
                    <input type="hidden" name="bill_id" value="{$bill.id}">
                    <input type="hidden" name="idempotency_key" value="{$bill.idempotency_key}">

                    <!-- Amount Options Grid -->
                    <div class="row g-3 mb-4">
                        
                        <!-- Option A: Pay Full Due -->
                        <div class="col-md-6">
                            <label class="p-3 border rounded-4 w-100 cursor-pointer amount-option-card active shadow-sm" id="optCardFull" for="optFull">
                                <div class="form-check d-flex align-items-start gap-2">
                                    <input class="form-check-input mt-1" type="radio" name="payment_option" id="optFull" value="full" checked onchange="handleAmountOptionChange('full')">
                                    <div>
                                        <div class="fw-bold text-dark">Pay Full Amount</div>
                                        <div class="fs-5 fw-bold text-success my-1">₹{$bill.remaining_due}</div>
                                        <div class="text-muted small">Clears entire statement balance</div>
                                    </div>
                                </div>
                            </label>
                        </div>

                        <!-- Option B: Pay Minimum Due -->
                        <div class="col-md-6">
                            <label class="p-3 border rounded-4 w-100 cursor-pointer amount-option-card" id="optCardMin" for="optMin">
                                <div class="form-check d-flex align-items-start gap-2">
                                    <input class="form-check-input mt-1" type="radio" name="payment_option" id="optMin" value="minimum" onchange="handleAmountOptionChange('minimum')">
                                    <div>
                                        <div class="fw-bold text-dark">Pay Minimum Due</div>
                                        <div class="fs-5 fw-bold text-warning-emphasis my-1">₹{$bill.min_due}</div>
                                        <div class="text-muted small">5% floor threshold payment</div>
                                    </div>
                                </div>
                            </label>
                        </div>

                        <!-- Option C: Custom Partial Amount -->
                        <div class="col-12">
                            <label class="p-3 border rounded-4 w-100 cursor-pointer amount-option-card" id="optCardCustom" for="optCustom">
                                <div class="form-check d-flex align-items-start gap-2">
                                    <input class="form-check-input mt-1" type="radio" name="payment_option" id="optCustom" value="custom" onchange="handleAmountOptionChange('custom')">
                                    <div class="w-100">
                                        <div class="fw-bold text-dark">Enter Custom Amount</div>
                                        <div class="text-muted small mb-2">Pay any custom partial or full amount</div>
                                        
                                        <div class="input-group d-none" id="customAmountGroup">
                                            <span class="input-group-text bg-white fw-bold">₹</span>
                                            <input type="number" step="0.01" min="1" max="{$bill.raw_remaining_due}" class="form-control form-control-lg font-monospace fw-bold" id="customAmountInput" name="custom_amount" placeholder="Enter amount" value="{$bill.raw_remaining_due}" oninput="updateCustomAmount(this.value)">
                                        </div>
                                    </div>
                                </div>
                            </label>
                        </div>

                    </div>

                    <!-- Custom Amount Warning / Note Banner -->
                    <div id="belowMinWarning" class="alert alert-warning border border-warning d-none rounded-3 py-2 px-3 small d-flex align-items-center gap-2 mb-4">
                        <i class="bi bi-exclamation-triangle-fill fs-5 text-warning"></i>
                        <div>
                            <strong>Note:</strong> This payment amount is below the Minimum Amount Due (₹{$bill.min_due}). The remaining balance will remain outstanding on your statement.
                        </div>
                    </div>

                    <hr class="my-4 opacity-25">

                    <!-- Step 2: Payment Method Selector -->
                    <div class="mb-3">
                        <span class="badge bg-warning text-dark fw-bold rounded-pill px-3 py-1 mb-2">Step 2</span>
                        <h4 class="fw-bold text-dark mb-1">Select Payment Channel</h4>
                        <p class="text-muted small mb-0">Choose your secure payment method.</p>
                    </div>

                    <div class="d-flex flex-column gap-3 mb-4">
                        
                        <!-- Option 1: UPI -->
                        <div class="p-3 border rounded-4 payment-option-card active shadow-sm" id="optCardUpi" onclick="selectPaymentMethod('upi')">
                            <div class="form-check d-flex align-items-center justify-content-between w-100 ps-0 mb-0">
                                <div class="d-flex align-items-center gap-3">
                                    <input class="form-check-input ms-0 me-2" type="radio" name="payment_method" id="methodUpi" value="upi" checked>
                                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-warning-subtle text-warning-emphasis p-2" style="width: 42px; height: 42px;">
                                        <i class="bi bi-qr-code-scan fs-5"></i>
                                    </div>
                                    <div>
                                        <label class="form-check-label fw-bold text-dark mb-0 cursor-pointer" for="methodUpi">
                                            UPI (Google Pay, PhonePe, Paytm)
                                        </label>
                                        <div class="text-muted small">Fast, instant & zero transaction fee</div>
                                    </div>
                                </div>
                                <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle rounded-pill px-2 py-1 small">Popular</span>
                            </div>

                            <!-- UPI Fields -->
                            <div class="mt-3 pt-3 border-top method-fields" id="fieldsUpi">
                                <label for="upi_id" class="form-label small fw-bold text-dark">Enter UPI VPA ID</label>
                                <div class="input-group mb-2">
                                    <span class="input-group-text bg-white"><i class="bi bi-person-badge text-warning"></i></span>
                                    <input type="text" class="form-control" id="upi_id" name="upi_id" placeholder="e.g. yourname@okhdfcbank" value="sandeep@cred">
                                </div>
                                <div class="d-flex flex-wrap gap-1 mt-2">
                                    <button type="button" class="btn btn-sm btn-light border rounded-pill py-0 px-2 small text-muted" onclick="document.getElementById('upi_id').value='member@okhdfcbank'">@okhdfcbank</button>
                                    <button type="button" class="btn btn-sm btn-light border rounded-pill py-0 px-2 small text-muted" onclick="document.getElementById('upi_id').value='member@ybl'">@ybl</button>
                                    <button type="button" class="btn btn-sm btn-light border rounded-pill py-0 px-2 small text-muted" onclick="document.getElementById('upi_id').value='member@paytm'">@paytm</button>
                                    <button type="button" class="btn btn-sm btn-light border rounded-pill py-0 px-2 small text-muted" onclick="document.getElementById('upi_id').value='member@cred'">@cred</button>
                                </div>
                            </div>
                        </div>

                        <!-- Option 2: Net Banking -->
                        <div class="p-3 border rounded-4 payment-option-card" id="optCardNetbanking" onclick="selectPaymentMethod('netbanking')">
                            <div class="form-check d-flex align-items-center justify-content-between w-100 ps-0 mb-0">
                                <div class="d-flex align-items-center gap-3">
                                    <input class="form-check-input ms-0 me-2" type="radio" name="payment_method" id="methodNetbanking" value="netbanking">
                                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-primary-subtle text-primary p-2" style="width: 42px; height: 42px;">
                                        <i class="bi bi-bank fs-5"></i>
                                    </div>
                                    <div>
                                        <label class="form-check-label fw-bold text-dark mb-0 cursor-pointer" for="methodNetbanking">
                                            Net Banking
                                        </label>
                                        <div class="text-muted small">Pay directly from all major Indian financial institutions</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Net Banking Fields -->
                            <div class="mt-3 pt-3 border-top method-fields d-none" id="fieldsNetbanking">
                                <label for="bank_code" class="form-label small fw-bold text-dark">Select Your Bank</label>
                                <select class="form-select" id="bank_code" name="bank_code">
                                    <option value="HDFC">HDFC Bank</option>
                                    <option value="ICICI">ICICI Bank</option>
                                    <option value="SBI">State Bank of India</option>
                                    <option value="AXIS">Axis Bank</option>
                                    <option value="KOTAK">Kotak Mahindra Bank</option>
                                    <option value="OTHER">Other Supported Bank</option>
                                </select>
                            </div>
                        </div>

                        <!-- Option 3: Debit Card -->
                        <div class="p-3 border rounded-4 payment-option-card" id="optCardDebit" onclick="selectPaymentMethod('debit_card')">
                            <div class="form-check d-flex align-items-center justify-content-between w-100 ps-0 mb-0">
                                <div class="d-flex align-items-center gap-3">
                                    <input class="form-check-input ms-0 me-2" type="radio" name="payment_method" id="methodDebit" value="debit_card">
                                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-success-subtle text-success p-2" style="width: 42px; height: 42px;">
                                        <i class="bi bi-credit-card-2-back fs-5"></i>
                                    </div>
                                    <div>
                                        <label class="form-check-label fw-bold text-dark mb-0 cursor-pointer" for="methodDebit">
                                            Debit Card
                                        </label>
                                        <div class="text-muted small">Visa, Mastercard, RuPay & Diners Club</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Debit Card Fields -->
                            <div class="mt-3 pt-3 border-top method-fields d-none" id="fieldsDebit">
                                <div class="mb-3">
                                    <label for="debit_card_number" class="form-label small fw-bold text-dark">16-Digit Debit Card Number</label>
                                    <input type="text" class="form-control font-monospace" id="debit_card_number" name="debit_card_number" placeholder="4123 4567 8901 2345" maxlength="19" value="4532 8765 1098 3456">
                                </div>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <label for="debit_expiry" class="form-label small fw-bold text-dark">Expiry (MM/YY)</label>
                                        <input type="text" class="form-control font-monospace" id="debit_expiry" name="debit_expiry" placeholder="12/28" maxlength="5" value="12/28">
                                    </div>
                                    <div class="col-6">
                                        <label for="debit_cvv" class="form-label small fw-bold text-dark">CVV</label>
                                        <input type="password" class="form-control font-monospace" id="debit_cvv" name="debit_cvv" placeholder="•••" maxlength="4" value="123">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Option 4: CRED Pay -->
                        <div class="p-3 border rounded-4 payment-option-card" id="optCardCredPay" onclick="selectPaymentMethod('cred_pay')">
                            <div class="form-check d-flex align-items-center justify-content-between w-100 ps-0 mb-0">
                                <div class="d-flex align-items-center gap-3">
                                    <input class="form-check-input ms-0 me-2" type="radio" name="payment_method" id="methodCredPay" value="cred_pay">
                                    <div class="d-flex align-items-center justify-content-center rounded-3 p-2" style="width: 42px; height: 42px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #b45309; border: 1px solid #f59e0b;">
                                        <i class="bi bi-lightning-charge-fill fs-5"></i>
                                    </div>
                                    <div>
                                        <label class="form-check-label fw-bold text-dark mb-0 cursor-pointer" for="methodCredPay">
                                            CRED Pay Instant
                                        </label>
                                        <div class="text-muted small">One-click authenticated member settlement</div>
                                    </div>
                                </div>
                                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-2 py-1 small">1-Click</span>
                            </div>

                            <!-- CRED Pay Fields -->
                            <div class="mt-3 pt-3 border-top method-fields d-none" id="fieldsCredPay">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="cred_pay_consent" id="cred_pay_consent" value="yes" checked>
                                    <label class="form-check-label small text-dark" for="cred_pay_consent">
                                        Authorize instant settlement allocation using CRED Pay verified protocol.
                                    </label>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Submit Button & Processing State -->
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-royal-primary btn-lg rounded-4 py-3 fw-bold shadow" id="btnSubmitPayment">
                            <i class="bi bi-shield-fill-check me-1"></i>
                            <span id="btnText">Pay ₹{$bill.remaining_due} Securely</span>
                        </button>
                    </div>

                    <!-- Processing Indicator (Hidden initially) -->
                    <div id="paymentProcessingIndicator" class="text-center py-3 d-none">
                        <div class="spinner-border text-warning mb-2" role="status" style="width: 2.5rem; height: 2.5rem;">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">Processing settlement & allocating payment...</h6>
                        <p class="text-muted small mb-0">Financial transaction in progress. Please do not refresh.</p>
                    </div>

                </form>

            </div>
        </div>
    </div>

</div>

<style>
.amount-option-card, .payment-option-card {
    cursor: pointer;
    transition: all 0.25s ease;
    background-color: #ffffff;
}
.amount-option-card:hover, .payment-option-card:hover {
    border-color: #d97706 !important;
    background-color: #fffdfa;
}
.amount-option-card.active, .payment-option-card.active {
    border-color: #f59e0b !important;
    background: linear-gradient(135deg, #fffdf8 0%, #ffffff 100%);
    box-shadow: 0 4px 14px rgba(245, 158, 11, 0.15) !important;
}
</style>

<script>
var RAW_REMAINING_DUE = {$bill.raw_remaining_due|default:0};
var RAW_MIN_DUE = {$bill.raw_min_due|default:0};

function handleAmountOptionChange(option) {
    document.querySelectorAll('.amount-option-card').forEach(function(c) {
        c.classList.remove('active');
    });
    var customGroup = document.getElementById('customAmountGroup');
    var warningEl = document.getElementById('belowMinWarning');

    var currentPay = RAW_REMAINING_DUE;
    var label = "Full Remaining Balance";

    if (option === 'full') {
        document.getElementById('optCardFull').classList.add('active');
        customGroup.classList.add('d-none');
        warningEl.classList.add('d-none');
        currentPay = RAW_REMAINING_DUE;
        label = "Full Remaining Balance";
    } else if (option === 'minimum') {
        document.getElementById('optCardMin').classList.add('active');
        customGroup.classList.add('d-none');
        warningEl.classList.add('d-none');
        currentPay = RAW_MIN_DUE;
        label = "Minimum Amount Due";
    } else if (option === 'custom') {
        document.getElementById('optCardCustom').classList.add('active');
        customGroup.classList.remove('d-none');
        var inputVal = parseFloat(document.getElementById('customAmountInput').value) || 0;
        currentPay = inputVal;
        label = "Custom Partial Amount";
        checkBelowMinDue(inputVal);
    }

    updatePayDisplay(currentPay, label);
}

function updateCustomAmount(val) {
    var num = parseFloat(val) || 0;
    checkBelowMinDue(num);
    updatePayDisplay(num, "Custom Partial Amount");
}

function checkBelowMinDue(amount) {
    var warningEl = document.getElementById('belowMinWarning');
    if (amount > 0 && amount < RAW_MIN_DUE && amount < RAW_REMAINING_DUE) {
        warningEl.classList.remove('d-none');
    } else {
        warningEl.classList.add('d-none');
    }
}

function updatePayDisplay(amount, label) {
    var formatted = Number(amount).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    document.getElementById('summaryPayAmount').innerText = "₹" + formatted;
    document.getElementById('summarySelectedLabel').innerText = label;
    document.getElementById('btnText').innerText = "Pay ₹" + formatted + " Securely";
}

function selectPaymentMethod(method) {
    document.querySelectorAll('.payment-option-card').forEach(function(card) {
        card.classList.remove('active');
    });
    document.querySelectorAll('.method-fields').forEach(function(f) {
        f.classList.add('d-none');
    });

    if (method === 'upi') {
        document.getElementById('methodUpi').checked = true;
        document.getElementById('optCardUpi').classList.add('active');
        document.getElementById('fieldsUpi').classList.remove('d-none');
    } else if (method === 'netbanking') {
        document.getElementById('methodNetbanking').checked = true;
        document.getElementById('optCardNetbanking').classList.add('active');
        document.getElementById('fieldsNetbanking').classList.remove('d-none');
    } else if (method === 'debit_card') {
        document.getElementById('methodDebit').checked = true;
        document.getElementById('optCardDebit').classList.add('active');
        document.getElementById('fieldsDebit').classList.remove('d-none');
    } else if (method === 'cred_pay') {
        document.getElementById('methodCredPay').checked = true;
        document.getElementById('optCardCredPay').classList.add('active');
        document.getElementById('fieldsCredPay').classList.remove('d-none');
    }
}

function handlePaymentSubmit(e) {
    var btn = document.getElementById('btnSubmitPayment');
    var btnText = document.getElementById('btnText');
    var indicator = document.getElementById('paymentProcessingIndicator');

    btn.disabled = true;
    btnText.innerText = "Settling & Allocating...";
    if (indicator) {
        indicator.classList.remove('d-none');
    }
    return true;
}
</script>

{/block}
