;; Insurance Provider Verification Contract
;; Validates and manages crop insurance providers

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PROVIDER_EXISTS (err u101))
(define-constant ERR_PROVIDER_NOT_FOUND (err u102))
(define-constant ERR_INVALID_LICENSE (err u103))

;; Data Variables
(define-data-var next-provider-id uint u1)

;; Data Maps
(define-map providers
  { provider-id: uint }
  {
    name: (string-ascii 100),
    license-number: (string-ascii 50),
    wallet-address: principal,
    is-verified: bool,
    registration-date: uint,
    total-policies: uint
  }
)

(define-map provider-by-address
  { wallet-address: principal }
  { provider-id: uint }
)

;; Public Functions
(define-public (register-provider (name (string-ascii 100)) (license-number (string-ascii 50)))
  (let
    (
      (provider-id (var-get next-provider-id))
      (caller tx-sender)
    )
    (asserts! (is-none (map-get? provider-by-address { wallet-address: caller })) ERR_PROVIDER_EXISTS)
    (asserts! (> (len license-number) u0) ERR_INVALID_LICENSE)

    (map-set providers
      { provider-id: provider-id }
      {
        name: name,
        license-number: license-number,
        wallet-address: caller,
        is-verified: false,
        registration-date: block-height,
        total-policies: u0
      }
    )

    (map-set provider-by-address
      { wallet-address: caller }
      { provider-id: provider-id }
    )

    (var-set next-provider-id (+ provider-id u1))
    (ok provider-id)
  )
)

(define-public (verify-provider (provider-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? providers { provider-id: provider-id })
      provider-data
      (begin
        (map-set providers
          { provider-id: provider-id }
          (merge provider-data { is-verified: true })
        )
        (ok true)
      )
      ERR_PROVIDER_NOT_FOUND
    )
  )
)

;; Read-only Functions
(define-read-only (get-provider (provider-id uint))
  (map-get? providers { provider-id: provider-id })
)

(define-read-only (get-provider-by-address (wallet-address principal))
  (match (map-get? provider-by-address { wallet-address: wallet-address })
    provider-ref
    (map-get? providers { provider-id: (get provider-id provider-ref) })
    none
  )
)

(define-read-only (is-verified-provider (provider-id uint))
  (match (map-get? providers { provider-id: provider-id })
    provider-data
    (get is-verified provider-data)
    false
  )
)
