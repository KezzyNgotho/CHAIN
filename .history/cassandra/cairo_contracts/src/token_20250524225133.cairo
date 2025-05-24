use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
trait IToken<TContractState> {
    fn set_value(ref self: TContractState, value: u256);
    fn get_value(self: @TContractState) -> u256;
}

#[starknet::contract]
mod Token {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        value: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TokensMinted: TokensMinted,
        TokensTransferred: TokensTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct TokensMinted {
        to: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct TokensTransferred {
        from: ContractAddress,
        to: ContractAddress,
        amount: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.value.write(42);
    }

    #[external(v0)]
    fn get_value(self: @ContractState) -> u256 {
        self.value.read()
    }

    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        fn set_value(ref self: ContractState, value: u256) {
            self.value.write(value);
        }

        fn get_value(self: @ContractState) -> u256 {
            self.value.read()
        }
    }
}