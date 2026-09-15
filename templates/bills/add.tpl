{extends file="../layouts/main.tpl"}

{block name="title"}
    Add Bill | CRED Heritage & Modern
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
        <span class="fw-bold text-dark">Add New Bill</span>
    </div>

    <div>
        <a href="/cred-app/public/bills" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
            <i class="bi bi-arrow-left"></i>
            <span>Back to Bills</span>
        </a>
    </div>
</div>

<div class="row justify-content-center">

    <div class="col-md-8 col-lg-6">

        <div class="card cred-card shadow-sm">

            <div class="card-body p-4 p-md-5">

                <div class="text-center mb-4">
                    <div class="d-inline-flex align-items-center justify-content-center mb-3 rounded-circle" 
                         style="width: 60px; height: 60px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border: 1.5px solid #f59e0b; color: #b45309; font-size: 1.8rem; box-shadow: 0 6px 16px rgba(245, 158, 11, 0.25);">
                        <i class="bi bi-receipt-cutoff"></i>
                    </div>

                    <h2 class="fw-bold text-dark mb-1">
                        Add Credit Card Bill
                    </h2>

                    <p class="text-muted small">
                        Generate and track statement dues for your connected cards.
                    </p>
                </div>

                {if !empty($errors)}
                    <div class="alert alert-danger border-danger-subtle rounded-3 shadow-sm mb-4">
                        <div class="d-flex align-items-center gap-2 mb-1 fw-bold text-danger">
                            <i class="bi bi-exclamation-octagon-fill"></i>
                            <span>Please fix the following:</span>
                        </div>
                        <ul class="mb-0 ps-3">
                            {foreach $errors as $error}
                                <li>{$error}</li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}

                {if empty($cards)}
                    <!-- No Cards Empty State Warning -->
                    <div class="alert alert-warning border-warning-subtle rounded-4 p-4 text-center">
                        <div class="display-6 text-warning mb-2">
                            <i class="bi bi-credit-card-2-front"></i>
                        </div>
                        <h5 class="fw-bold text-dark mb-2">No Credit Cards Found</h5>
                        <p class="text-muted small mb-3">
                            Please add a credit card before creating a bill.
                        </p>
                        <a href="/cred-app/public/cards/add" class="btn btn-royal-primary">
                            <i class="bi bi-plus-circle-fill"></i>
                            <span>Add a Credit Card First</span>
                        </a>
                    </div>
                {else}
                    <form method="POST" action="/cred-app/public/bills/add">

                        <!-- Select Credit Card -->
                        <div class="mb-3">
                            <label for="card_id" class="form-label">
                                <i class="bi bi-credit-card text-warning me-1"></i> Select Credit Card
                            </label>

                            <select
                                class="form-select"
                                id="card_id"
                                name="card_id"
                                required
                            >
                                <option value="" disabled {if empty($old.card_id)}selected{/if}>Choose a card...</option>
                                {foreach $cards as $card}
                                    <option value="{$card.id}" {if ($old.card_id|default:0) == $card.id}selected{/if}>
                                        {$card.bank_name} &bull; {$card.card_holder} ({$card.masked_number})
                                    </option>
                                {/foreach}
                            </select>
                            <div class="form-text text-muted small">Only cards linked to your account are displayed.</div>
                        </div>

                        <!-- Bill Amount -->
                        <div class="mb-3">
                            <label for="amount" class="form-label">
                                <i class="bi bi-currency-rupee text-warning me-1"></i> Statement Amount
                            </label>

                            <div class="input-group">
                                <span class="input-group-text bg-light text-dark fw-bold">₹</span>
                                <input
                                    type="number"
                                    class="form-control"
                                    id="amount"
                                    name="amount"
                                    value="{$old.amount|default:''}"
                                    placeholder="e.g. 4500.00"
                                    min="0.01"
                                    step="0.01"
                                    required
                                >
                            </div>
                        </div>

                        <!-- Due Date -->
                        <div class="mb-4">
                            <label for="due_date" class="form-label">
                                <i class="bi bi-calendar-event text-warning me-1"></i> Statement Due Date
                            </label>

                            <input
                                type="date"
                                class="form-control"
                                id="due_date"
                                name="due_date"
                                value="{$old.due_date|default:''}"
                                required
                            >
                        </div>

                        <!-- Submit & Cancel Buttons -->
                        <div class="d-flex flex-column flex-sm-row gap-2 pt-2">
                            <button
                                type="submit"
                                class="btn btn-royal-primary flex-grow-1"
                            >
                                <i class="bi bi-plus-circle-fill"></i>
                                <span>Save & Create Bill</span>
                            </button>

                            <a
                                href="/cred-app/public/bills"
                                class="btn btn-royal-outline"
                            >
                                <span>Cancel</span>
                            </a>
                        </div>

                    </form>
                {/if}

            </div>

        </div>

    </div>

</div>

{/block}
