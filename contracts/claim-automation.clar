;; Claim Automation Contract
;; Automates crop insurance claims processing

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_POLICY_NOT_FOUND (err u401))
(define-constant ERR_CLAIM_EXISTS (err u402))
(define-constant ERR_INSUFFICIENT_LOSS (err u403))
(define-constant ERR_INVALID_AMOUNT (err u404))

;; Minimum loss percentage to trigger claim (50%)
(define-constant MIN_LOSS_THRESHOLD u50)

;; Data Variables
(define-data-var next-policy-id uint u1)
(define-data-var next-claim-id uint u1)

;; Data Maps
(define-map insurance-policies
  { policy-id: uint }
  {
    farm-id: uint,
    farmer: principal,
    provider-id: uint,
    coverage-amount: uint, ;; in microSTX
    premium-paid: uint,
    policy-start: uint,
    policy-end: uint,
    is-active: bool
  }
)

(define-map insurance-claims
  { claim-id: uint }
  {
    policy-id: uint,
    farm-id: uint,
    claimant: principal,
    claim-amount: uint,
    loss-percentage: uint,
    claim-date: uint,
    status: (string-ascii 20), ;; "pending", "approved", "rejected", "paid"
    weather-triggered: bool,
    yield-triggered: bool
  }
)

(define-map policy-claims
  { policy-id: uint }
  { claim-id: uint }
)

;; Public Functions
(define-public (create-policy
  (farm-id uint)
  (provider-id uint)
  (coverage-amount uint)
  (premium-paid uint)
  (policy-duration uint))
  (let
    (
      (policy-id (var-get next-policy-id))
      (policy-start block-height)
      (policy-end (+ block-height policy-duration))
    )
    (asserts! (> coverage-amount u0) ERR_INVALID_AMOUNT)
    (asserts! (> premium-paid u0) ERR_INVALID_AMOUNT)

    (map-set insurance-policies
      { policy-id: policy-id }
      {
        farm-id: farm-id,
        farmer: tx-sender,
        provider-id: provider-id,
        coverage-amount: coverage-amount,
        premium-paid: premium-paid,
        policy-start: policy-start,
        policy-end: policy-end,
        is-active: true
      }
    )

    (var-set next-policy-id (+ policy-id u1))
    (ok policy-id)
  )
)

(define-public (submit-claim (policy-id uint) (loss-percentage uint))
  (let
    (
      (claim-id (var-get next-claim-id))
    )
    (match (map-get? insurance-policies { policy-id: policy-id })
      policy-data
      (let
        (
          (coverage-amount (get coverage-amount policy-data))
          (claim-amount (/ (* coverage-amount loss-percentage) u100))
        )
        (asserts! (is-eq tx-sender (get farmer policy-data)) ERR_UNAUTHORIZED)
        (asserts! (get is-active policy-data) ERR_POLICY_NOT_FOUND)
        (asserts! (>= loss-percentage MIN_LOSS_THRESHOLD) ERR_INSUFFICIENT_LOSS)
        (asserts! (is-none (map-get? policy-claims { policy-id: policy-id })) ERR_CLAIM_EXISTS)

        (map-set insurance-claims
          { claim-id: claim-id }
          {
            policy-id: policy-id,
            farm-id: (get farm-id policy-data),
            claimant: tx-sender,
            claim-amount: claim-amount,
            loss-percentage: loss-percentage,
            claim-date: block-height,
            status: "pending",
            weather-triggered: false,
            yield-triggered: true
          }
        )

        (map-set policy-claims
          { policy-id: policy-id }
          { claim-id: claim-id }
        )

        (var-set next-claim-id (+ claim-id u1))
        (ok claim-id)
      )
      ERR_POLICY_NOT_FOUND
    )
  )
)

(define-public (process-claim (claim-id uint) (approve bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? insurance-claims { claim-id: claim-id })
      claim-data
      (let
        (
          (new-status (if approve "approved" "rejected"))
        )
        (map-set insurance-claims
          { claim-id: claim-id }
          (merge claim-data { status: new-status })
        )
        (ok approve)
      )
      ERR_POLICY_NOT_FOUND
    )
  )
)

;; Automated claim trigger based on weather conditions
(define-public (trigger-weather-claim (policy-id uint) (station-id uint))
  (let
    (
      (claim-id (var-get next-claim-id))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? insurance-policies { policy-id: policy-id })
      policy-data
      (let
        (
          (coverage-amount (get coverage-amount policy-data))
          (claim-amount (/ (* coverage-amount u75) u100)) ;; 75% payout for weather events
        )
        (asserts! (get is-active policy-data) ERR_POLICY_NOT_FOUND)

        (map-set insurance-claims
          { claim-id: claim-id }
          {
            policy-id: policy-id,
            farm-id: (get farm-id policy-data),
            claimant: (get farmer policy-data),
            claim-amount: claim-amount,
            loss-percentage: u75,
            claim-date: block-height,
            status: "approved",
            weather-triggered: true,
            yield-triggered: false
          }
        )

        (var-set next-claim-id (+ claim-id u1))
        (ok claim-id)
      )
      ERR_POLICY_NOT_FOUND
    )
  )
)

;; Read-only Functions
(define-read-only (get-policy (policy-id uint))
  (map-get? insurance-policies { policy-id: policy-id })
)

(define-read-only (get-claim (claim-id uint))
  (map-get? insurance-claims { claim-id: claim-id })
)

(define-read-only (get-policy-claim (policy-id uint))
  (match (map-get? policy-claims { policy-id: policy-id })
    claim-ref
    (map-get? insurance-claims { claim-id: (get claim-id claim-ref) })
    none
  )
)
