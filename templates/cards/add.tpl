{extends file="../layouts/main.tpl"}

{block name="title"}
    Add Credit Card | CRED Heritage & Modern
{/block}

{block name="content"}

<!-- Top Navigation & Home Button -->
<div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4 p-3 bg-white border rounded-4 shadow-sm" style="border-color: rgba(217, 119, 6, 0.15) !important;">
    <div class="d-flex align-items-center gap-2">
        <a href="/cred-app/public/" class="btn btn-sm btn-outline-warning text-dark fw-semibold rounded-pill px-3 d-inline-flex align-items-center gap-1 shadow-sm" style="border-color: #f59e0b; background: #fffdf5;">
            <i class="bi bi-house-door-fill text-warning"></i>
            <span>Home</span>
        </a>
        <span class="text-muted opacity-50">/</span>
        <a href="/cred-app/public/" class="text-decoration-none text-muted small hover-gold">Dashboard</a>
        <span class="text-muted opacity-50">/</span>
        <span class="fw-bold text-dark">Add Credit Card</span>
    </div>

    <div>
        <a href="/cred-app/public/" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
            <i class="bi bi-arrow-left"></i>
            <span>Back to Dashboard</span>
        </a>
    </div>
</div>

<div class="row g-4 justify-content-center align-items-start">

    <!-- Interactive Card Visualizer (Left Column on Desktop) -->
    <div class="col-lg-5">
        <div class="card cred-card shadow-sm sticky-top" style="top: 100px;">
            <div class="card-body p-4 text-center">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-1 fw-semibold small">
                        <i class="bi bi-eye-fill me-1"></i> Live Card Preview
                    </span>
                    <span class="small text-muted">
                        <i class="bi bi-shield-check text-success"></i> 256-bit Secure
                    </span>
                </div>

                <!-- 3D Luxury Credit Card Widget -->
                <div class="virtual-card p-4 text-white text-start rounded-4 position-relative overflow-hidden mb-3 shadow-lg"
                     style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 50%, #b45309 100%); min-height: 220px; border: 1.5px solid rgba(254, 243, 199, 0.4); box-shadow: 0 20px 35px -10px rgba(30, 58, 138, 0.4);">
                    
                    <!-- Decorative Traditional Watermark Pattern -->
                    <div style="position: absolute; right: -20px; bottom: -20px; opacity: 0.12; font-size: 10rem; pointer-events: none; line-height: 1;">
                        <i class="bi bi-shield-fill-check"></i>
                    </div>

                    <!-- Card Header: Bank & Contactless -->
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <div class="fw-bold fs-5 text-truncate pe-2 text-warning" id="previewBank">
                            {if !empty($old.bank_name)}{$old.bank_name}{else}ROYAL BANK{/if}
                        </div>
                        <div class="fs-4 text-warning">
                            <i class="bi bi-wifi"></i>
                        </div>
                    </div>

                    <!-- EMV Chip -->
                    <div class="mb-3 d-inline-flex align-items-center justify-content-center rounded-2 px-2 py-1"
                         style="background: linear-gradient(135deg, #fde68a 0%, #d97706 100%); border: 1px solid #fef3c7; width: 42px; height: 32px;">
                        <div style="width: 100%; height: 1px; background: rgba(0,0,0,0.2);"></div>
                    </div>

                    <!-- 16-Digit Card Number -->
                    <div class="fs-5 fw-bold mb-3 tracking-widest font-monospace text-light" id="previewNumber" style="letter-spacing: 2px;">
                        •••• •••• •••• ••••
                    </div>

                    <!-- Card Holder & Expiry -->
                    <div class="d-flex align-items-end justify-content-between">
                        <div>
                            <div class="text-uppercase small text-white-50" style="font-size: 0.7rem; letter-spacing: 1px;">Card Holder</div>
                            <div class="fw-bold text-uppercase text-truncate" id="previewHolder" style="max-width: 180px; letter-spacing: 1px;">
                                {if !empty($old.card_holder_name)}{$old.card_holder_name}{else}YOUR NAME{/if}
                            </div>
                        </div>

                        <div class="text-end">
                            <div class="text-uppercase small text-white-50" style="font-size: 0.7rem; letter-spacing: 1px;">Expires</div>
                            <div class="fw-bold font-monospace" id="previewExpiry">
                                {if !empty($old.expiry_month)}{$old.expiry_month}{else}MM{/if}/{if !empty($old.expiry_year)}{$old.expiry_year|substr:2:2}{else}YY{/if}
                            </div>
                        </div>
                    </div>
                </div>

                <p class="small text-muted mb-0">
                    <i class="bi bi-info-circle me-1 text-primary"></i>
                    Details sync in real time as you enter them in the form.
                </p>
            </div>
        </div>
    </div>

    <!-- Form Column (Right Column) -->
    <div class="col-lg-7">

        <div class="card cred-card shadow-sm">

            <div class="card-body p-4 p-md-5">

                <div class="mb-4 pb-2 border-bottom">
                    <h2 class="fw-bold mb-1 text-dark">
                        Card Information
                    </h2>
                    <p class="text-muted small">
                        Please fill in your authentic card credentials to connect with CRED.
                    </p>
                </div>

                {if !empty($errors)}
                    <div class="alert alert-danger border-danger-subtle rounded-3 shadow-sm mb-4">
                        <div class="d-flex align-items-center gap-2 mb-2 fw-bold text-danger">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span>Please fix the following issues:</span>
                        </div>
                        <ul class="mb-0 ps-3">
                            {foreach $errors as $error}
                                <li>{$error}</li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}

                <form method="POST" action="/cred-app/public/cards/add" id="cardForm">

                    <!-- Card Holder Name -->
                    <div class="mb-3">
                        <label for="card_holder_name" class="form-label">
                            <i class="bi bi-person-fill text-warning me-1"></i> Card Holder Name
                        </label>
                        <input
                            type="text"
                            class="form-control"
                            id="card_holder_name"
                            name="card_holder_name"
                            value="{$old.card_holder_name|default:''}"
                            placeholder="e.g. Rahul Sharma"
                            required
                        >
                        <div class="form-text text-muted small">Enter full name as printed on the card.</div>
                    </div>

                    <!-- Bank Name -->
                    <div class="mb-3">
                        <label for="bank_name" class="form-label">
                            <i class="bi bi-bank2 text-warning me-1"></i> Bank Name
                        </label>
                        <input
                            type="text"
                            class="form-control"
                            id="bank_name"
                            name="bank_name"
                            value="{$old.bank_name|default:''}"
                            placeholder="e.g. HDFC Bank, SBI Card, ICICI Bank"
                            required
                        >
                    </div>

                    <!-- Card Number -->
                    <div class="mb-3">
                        <label for="card_number" class="form-label">
                            <i class="bi bi-credit-card text-warning me-1"></i> 16-Digit Card Number
                        </label>
                        <input
                            type="text"
                            class="form-control font-monospace"
                            id="card_number"
                            name="card_number"
                            placeholder="4532 8901 2345 6789"
                            maxlength="19"
                            required
                        >
                        <div class="form-text text-muted small">We secure your card number with industry-leading encryption.</div>
                    </div>

                    <!-- Expiry Date Row -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="expiry_month" class="form-label">
                                <i class="bi bi-calendar-event text-warning me-1"></i> Expiry Month
                            </label>
                            <select
                                class="form-select"
                                id="expiry_month"
                                name="expiry_month"
                                required
                            >
                                <option value="" disabled {if empty($old.expiry_month)}selected{/if}>Select Month</option>
                                <option value="01" {if ($old.expiry_month|default:'') == '01'}selected{/if}>01 - January</option>
                                <option value="02" {if ($old.expiry_month|default:'') == '02'}selected{/if}>02 - February</option>
                                <option value="03" {if ($old.expiry_month|default:'') == '03'}selected{/if}>03 - March</option>
                                <option value="04" {if ($old.expiry_month|default:'') == '04'}selected{/if}>04 - April</option>
                                <option value="05" {if ($old.expiry_month|default:'') == '05'}selected{/if}>05 - May</option>
                                <option value="06" {if ($old.expiry_month|default:'') == '06'}selected{/if}>06 - June</option>
                                <option value="07" {if ($old.expiry_month|default:'') == '07'}selected{/if}>07 - July</option>
                                <option value="08" {if ($old.expiry_month|default:'') == '08'}selected{/if}>08 - August</option>
                                <option value="09" {if ($old.expiry_month|default:'') == '09'}selected{/if}>09 - September</option>
                                <option value="10" {if ($old.expiry_month|default:'') == '10'}selected{/if}>10 - October</option>
                                <option value="11" {if ($old.expiry_month|default:'') == '11'}selected{/if}>11 - November</option>
                                <option value="12" {if ($old.expiry_month|default:'') == '12'}selected{/if}>12 - December</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="expiry_year" class="form-label">
                                <i class="bi bi-calendar-range text-warning me-1"></i> Expiry Year
                            </label>
                            <select
                                class="form-select"
                                id="expiry_year"
                                name="expiry_year"
                                required
                            >
                                <option value="" disabled {if empty($old.expiry_year)}selected{/if}>Select Year</option>
                                {for $y = 2026 to 2040}
                                    <option value="{$y}" {if ($old.expiry_year|default:'') == $y}selected{/if}>{$y}</option>
                                {/for}
                            </select>
                        </div>
                    </div>

                    <!-- Credit Limit -->
                    <div class="mb-4">
                        <label for="credit_limit" class="form-label">
                            <i class="bi bi-currency-rupee text-warning me-1"></i> Credit Limit
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-dark fw-bold">₹</span>
                            <input
                                type="number"
                                class="form-control"
                                id="credit_limit"
                                name="credit_limit"
                                value="{$old.credit_limit|default:''}"
                                placeholder="e.g. 150000"
                                min="0"
                                step="any"
                                required
                            >
                        </div>
                    </div>

                    <!-- Action Buttons with Home and Submit -->
                    <div class="d-flex flex-column flex-sm-row gap-2 pt-2">
                        <button
                            type="submit"
                            class="btn btn-royal-primary flex-grow-1"
                        >
                            <i class="bi bi-check-circle-fill"></i>
                            <span>Save & Verify Card</span>
                        </button>

                        <a
                            href="/cred-app/public/"
                            class="btn btn-royal-outline"
                        >
                            <i class="bi bi-house-door"></i>
                            <span>Home</span>
                        </a>
                    </div>

                </form>

            </div>

        </div>

    </div>

</div>

<!-- Client-side Interactive Card Preview Sync Script -->
{literal}
<script>
document.addEventListener('DOMContentLoaded', function() {
    const holderInput = document.getElementById('card_holder_name');
    const bankInput = document.getElementById('bank_name');
    const numberInput = document.getElementById('card_number');
    const monthSelect = document.getElementById('expiry_month');
    const yearSelect = document.getElementById('expiry_year');

    const previewHolder = document.getElementById('previewHolder');
    const previewBank = document.getElementById('previewBank');
    const previewNumber = document.getElementById('previewNumber');
    const previewExpiry = document.getElementById('previewExpiry');

    function updatePreview() {
        if (holderInput && previewHolder) {
            previewHolder.textContent = holderInput.value.trim().toUpperCase() || 'YOUR NAME';
        }
        if (bankInput && previewBank) {
            previewBank.textContent = bankInput.value.trim().toUpperCase() || 'ROYAL BANK';
        }
        if (numberInput && previewNumber) {
            const raw = numberInput.value.replace(/\D/g, '');
            if (raw.length === 0) {
                previewNumber.textContent = '•••• •••• •••• ••••';
            } else {
                let formatted = '';
                for (let i = 0; i < 16; i++) {
                    if (i > 0 && i % 4 === 0) formatted += ' ';
                    formatted += raw[i] ? raw[i] : '•';
                }
                previewNumber.textContent = formatted;
            }
        }
        if (previewExpiry) {
            const m = monthSelect && monthSelect.value ? monthSelect.value : 'MM';
            const y = yearSelect && yearSelect.value ? yearSelect.value.slice(-2) : 'YY';
            previewExpiry.textContent = m + '/' + y;
        }
    }

    if (holderInput) holderInput.addEventListener('input', updatePreview);
    if (bankInput) bankInput.addEventListener('input', updatePreview);
    if (numberInput) {
        numberInput.addEventListener('input', function(e) {
            // Auto format with spaces for readability
            let val = e.target.value.replace(/\D/g, '').substring(0, 16);
            let formatted = val.match(/.{1,4}/g)?.join(' ') || val;
            e.target.value = formatted;
            updatePreview();
        });
    }
    if (monthSelect) monthSelect.addEventListener('change', updatePreview);
    if (yearSelect) yearSelect.addEventListener('change', updatePreview);

    updatePreview();
});
</script>
{/literal}

{/block}
