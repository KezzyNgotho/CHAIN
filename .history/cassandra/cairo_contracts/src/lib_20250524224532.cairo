/// Simple contract for managing balance.
#[starknet::contract]
mod Token {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[abi(embed_v0)]
    impl TokenImpl of ContractState {
        /// Increase contract balance.
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            self.balance.write(self.balance.read() + amount);
        }

        /// Retrieve contract balance.
        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}