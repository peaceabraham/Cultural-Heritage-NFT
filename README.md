📜 Cultural Heritage NFT Contract

A Clarity smart contract for tokenizing historical and cultural artifacts as NFTs with built-in royalty mechanisms that support local communities. This contract ensures artifact preservation, transparent ownership transfer, and fair royalty distribution whenever NFTs are traded.

🚀 Features

NFT Minting:

Create unique cultural heritage tokens representing historical artifacts.

Each NFT stores metadata: artifact name, description, image URI, cultural significance, and community beneficiary.

Ownership & Transfer:

NFT ownership can be transferred between users.

Token listings are automatically removed upon transfer.

Marketplace Functionality:

List NFTs for sale with a fixed price.

Unlist tokens anytime before sale.

Purchase tokens securely using STX.

Community Royalties:

A percentage of each sale is automatically distributed to the associated community.

Contract owner can update the royalty percentage.

📂 Contract Structure

Constants:

contract-owner: Address that deployed the contract.

Error codes for standardized failure handling.

Data Variables:

last-token-id: Keeps track of the most recent token ID.

royalty-percentage: Defines percentage of royalties paid to communities.

Data Maps:

tokens: Stores NFT ownership and metadata.

token-listings: Stores listed tokens and their sale details.

🔍 Functions
Read-Only

get-last-token-id → Returns the most recent token ID.

get-token-owner → Returns the owner of a specific token.

get-token-info → Returns metadata of a token.

get-token-listing → Returns listing info for a token.

get-royalty-percentage → Returns current royalty percentage.

Public

mint-heritage-nft → Mint a new cultural heritage NFT.

transfer-token → Transfer ownership of an NFT.

list-token → List a token for sale.

unlist-token → Remove a token from marketplace listings.

buy-token → Purchase a token with STX, automatically distributing royalties.

set-royalty-percentage → Update royalty percentage (owner-only).

⚖️ Royalty Distribution

Royalties are calculated as a percentage of the sale price.

Distribution:

Community: Receives royalty amount.

Seller: Receives the remaining amount after royalties.

✅ Usage Flow

Mint Artifact NFT → Token created with cultural data & linked community.

List NFT for Sale → Token owner sets price.

Buy NFT → Buyer pays STX → Contract transfers funds (seller + community royalty).

Ownership Updated → Buyer becomes new owner.

🔐 Security Considerations

Only the contract owner can update royalty percentages.

Token transfers automatically remove market listings to avoid stale sales.

Uses error constants for predictable transaction failures.

📜 License

This smart contract is released under the MIT License.