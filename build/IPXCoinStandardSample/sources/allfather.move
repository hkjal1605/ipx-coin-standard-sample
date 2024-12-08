module ipx_standard_sample::allfather {
    use sui::coin;
    use sui::url::{Self, Url};

    public struct ALLFATHER has drop {}

    fun init(witness: ALLFATHER, ctx: &mut TxContext) {
        let (treasury_cap, coin_metadata) = coin::create_currency<ALLFATHER>(
            witness, 
            6, 
            b"ALLFATHER", 
            b"AllFather of the SUI devs" , 
            b"ALLFATHER of Sui devs, he thinks he's Odin but codes in Move. He's got the whole blockchain wrapped around his finger, or at least he'd like you to think so with his divine tech wisdom!", 
            option::some<Url>(
                url::new_unsafe_from_bytes(b"https://pbs.twimg.com/profile_images/1821959939197177858/1QiIq0i3_400x400.jpg")
            ),
            ctx
        );

        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
        transfer::public_freeze_object(coin_metadata);
    }
}