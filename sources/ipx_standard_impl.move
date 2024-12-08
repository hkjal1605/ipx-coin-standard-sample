module ipx_standard_sample::ipx_standard_impl {
    use sui::coin::{Self, TreasuryCap};

    use ipx_coin_standard::ipx_coin_standard::{Self};

    const MAX_SUPPLY: u64 = 100_000_000_000_000; // 100 million

    #[allow(lint(self_transfer, share_owned))]
    public fun mint_and_lock_treasury<T>(
        treasury_cap: TreasuryCap<T>,
        ctx: &mut TxContext
    ) {
        // Get the treasury standard and witness from ipx_coin_standard
        let (mut ipx_treasury_standard, mut witness) = ipx_coin_standard::new<T>(
            treasury_cap,
            ctx
        );

        // Set the maximum supply of the coin
        ipx_coin_standard::set_maximum_supply(&mut witness, MAX_SUPPLY);

        // Get the mint cap
        let mint_cap = ipx_coin_standard::create_mint_cap(&mut witness, ctx);

        // Mint the MAX_SUPPLY of the coin and transfer to creator
        let mut coins = ipx_coin_standard::mint<T>(
            &mint_cap,
            &mut ipx_treasury_standard,
            MAX_SUPPLY,
            ctx
        );

        // Burn the mint cap
        ipx_coin_standard::destroy_mint_cap(
            &mut ipx_treasury_standard,
            mint_cap
        );

        // Get the burn cap and burn 2% of the total supply
        let burn_cap = ipx_coin_standard::create_burn_cap(&mut witness, ctx);
        let coins_to_burn = coin::split(&mut coins, MAX_SUPPLY / 50, ctx);

        ipx_coin_standard::cap_burn<T>(
            &burn_cap,
            &mut ipx_treasury_standard,
            coins_to_burn,
        );

        // Destroy the burn cap (don't allow burning anymore using the burn cap)
        ipx_coin_standard::destroy_burn_cap(
            &mut ipx_treasury_standard,
            burn_cap
        );

        ipx_coin_standard::destroy_witness<T>(
            &mut ipx_treasury_standard,
            witness
        );

        transfer::public_share_object(ipx_treasury_standard);
        transfer::public_transfer(coins, tx_context::sender(ctx));
    }
}