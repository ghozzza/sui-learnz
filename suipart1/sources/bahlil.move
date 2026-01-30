/// Implements a coin with unlimited supply. TreasuryCap owner can mint
/// any amount at any time.
///
/// Keep the ability to update Currency metadata, such as name, symbol,
/// description, and icon URL.
module suipart1::bahlil;

use sui::coin::{Self, TreasuryCap};
use sui::coin_registry::{Self, CoinRegistry};

// The type identifier of coin. The coin will have a type
// tag of kind: `Coin<package_object::bahlil::BAHLIL>`
public struct BAHLIL has key { id: UID }

#[allow(lint(self_transfer))]
/// Creates a new currency. Caller receives TreasuryCap for unlimited minting.
public fun new_currency(registry: &mut CoinRegistry, ctx: &mut TxContext) {
    let (currency, treasury_cap) = coin_registry::new_currency<BAHLIL>(
        registry,
        6, // Decimals
        b"BAHLIL".to_string(), // Symbol
        b"BAHLIL".to_string(), // Name
        b"BAHLIL Token".to_string(), // Description
        b"https://www.obsessionnews.com/uploads/media/2025/02/03/012-ca7e79.jpeg".to_string(), // Icon URL
        ctx,
    );

    // Transfer caps to caller for future use
    let metadata_cap = currency.finalize(ctx);
    transfer::public_transfer(metadata_cap, ctx.sender());
    transfer::public_transfer(treasury_cap, ctx.sender());
}

/// Mint any amount of tokens to any address (requires TreasuryCap ownership)
public fun mint(
    treasury_cap: &mut TreasuryCap<BAHLIL>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}