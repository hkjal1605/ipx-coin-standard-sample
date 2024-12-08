module ipx_standard_sample::app {
    public struct AdminCap has store, key {
        id: UID
    }
    
    fun init(tx_context: &mut TxContext) {
        let admin_cap = AdminCap { id: object::new(tx_context) };
        transfer::transfer<AdminCap>(admin_cap, tx_context::sender(tx_context));
    }
}