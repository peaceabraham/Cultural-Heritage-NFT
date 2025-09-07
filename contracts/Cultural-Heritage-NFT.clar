;; Cultural Heritage NFT Contract
;; A simple contract for tokenizing historical artifacts with community royalties

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-listing-not-found (err u102))
(define-constant err-insufficient-funds (err u103))
(define-constant err-token-not-found (err u104))

;; Data Variables
(define-data-var last-token-id uint u0)
(define-data-var royalty-percentage uint u10) ;; 10% royalty to community

;; Data Maps
(define-map tokens 
  { token-id: uint }
  {
    owner: principal,
    artifact-name: (string-ascii 100),
    description: (string-ascii 500),
    image-uri: (string-ascii 200),
    community: principal,
    cultural-significance: (string-ascii 300)
  }
)

(define-map token-listings
  { token-id: uint }
  { price: uint, seller: principal }
)

;; Read-only functions
(define-read-only (get-last-token-id)
  (var-get last-token-id)
)

(define-read-only (get-token-owner (token-id uint))
  (match (map-get? tokens { token-id: token-id })
    token-data (ok (get owner token-data))
    (err err-token-not-found)
  )
)

(define-read-only (get-token-info (token-id uint))
  (map-get? tokens { token-id: token-id })
)

(define-read-only (get-token-listing (token-id uint))
  (map-get? token-listings { token-id: token-id })
)

(define-read-only (get-royalty-percentage)
  (var-get royalty-percentage)
)

;; Private functions
(define-private (is-token-owner (token-id uint) (user principal))
  (match (map-get? tokens { token-id: token-id })
    token-data (is-eq (get owner token-data) user)
    false
  )
)

;; Public functions
(define-public (mint-heritage-nft 
  (artifact-name (string-ascii 100))
  (description (string-ascii 500))
  (image-uri (string-ascii 200))
  (community principal)
  (cultural-significance (string-ascii 300))
)
  (let 
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (map-set tokens 
      { token-id: token-id }
      {
        owner: tx-sender,
        artifact-name: artifact-name,
        description: description,
        image-uri: image-uri,
        community: community,
        cultural-significance: cultural-significance
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer-token (token-id uint) (recipient principal))
  (if (is-token-owner token-id tx-sender)
    (begin
      (map-set tokens 
        { token-id: token-id }
        (merge 
          (unwrap-panic (map-get? tokens { token-id: token-id }))
          { owner: recipient }
        )
      )
      (map-delete token-listings { token-id: token-id })
      (ok true)
    )
    (err err-not-token-owner)
  )
)

(define-public (list-token (token-id uint) (price uint))
  (if (is-token-owner token-id tx-sender)
    (begin
      (map-set token-listings 
        { token-id: token-id }
        { price: price, seller: tx-sender }
      )
      (ok true)
    )
    (err err-not-token-owner)
  )
)

(define-public (unlist-token (token-id uint))
  (if (is-token-owner token-id tx-sender)
    (begin
      (map-delete token-listings { token-id: token-id })
      (ok true)
    )
    (err err-not-token-owner)
  )
)

(define-public (buy-token (token-id uint))
  (let
    (
      (listing-data (unwrap! (map-get? token-listings { token-id: token-id }) (err err-listing-not-found)))
      (token-data (unwrap! (map-get? tokens { token-id: token-id }) (err err-token-not-found)))
      (price (get price listing-data))
      (seller (get seller listing-data))
      (community (get community token-data))
      (royalty-amount (/ (* price (var-get royalty-percentage)) u100))
      (seller-amount (- price royalty-amount))
    )
(begin
      (unwrap! (stx-transfer? seller-amount tx-sender seller) (err err-insufficient-funds))
      (unwrap! (stx-transfer? royalty-amount tx-sender community) (err err-insufficient-funds))
      (map-set tokens 
        { token-id: token-id }
        (merge token-data { owner: tx-sender })
      )
      (map-delete token-listings { token-id: token-id })
      (ok true)
    )
  )
)

(define-public (set-royalty-percentage (new-percentage uint))
  (if (is-eq tx-sender contract-owner)
    (begin
      (var-set royalty-percentage new-percentage)
      (ok true)
    )
    (err err-owner-only)
  )
)