use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
trait IToken<TContractState> {
    fn set_value(ref self: TContractState, value: u256);
    fn get_value(self: @TContractState) -> u256;
}

#[starknet::contract]
mod Token {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        value: u256,
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