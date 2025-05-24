// SPDX-License-Identifier: MIT

use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;
use starknet::storage::StorageAccess;

#[starknet::interface]
trait IToken<TContractState> {
    fn mint(ref self: TContractState, to: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u256);
    fn get_balance(self: @TContractState, user: ContractAddress) -> u256;
    fn get_total_supply(self: @TContractState) -> u256;
    fn get_owner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod Token {
    use super::{ContractAddress, IToken};
    use starknet::get_caller_address;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;
    use starknet::storage::StorageAccess;

    #[storage]
    struct Storage {
        balances: StorageMap::<ContractAddress, u256>,
        total_supply: u256,
        owner: ContractAddress,
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

    #[abi(per_item)]
    #[generate_trait]
    impl Constructor of ConstructorTrait {
        fn constructor(ref self: ContractState, owner: ContractAddress) {
            self.owner.write(owner);
            self.total_supply.write(0);
        }
    }

    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can mint');

            let mut balance = self.balances.read(to);
            balance += amount;
            self.balances.write(to, balance);

            let mut supply = self.total_supply.read();
            supply += amount;
            self.total_supply.write(supply);

            self.emit(TokensMinted { to, amount });
        }

        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();

            let mut from_balance = self.balances.read(caller);
            assert(from_balance >= amount, 'Insufficient balance');
            from_balance -= amount;
            self.balances.write(caller, from_balance);

            let mut to_balance = self.balances.read(to);
            to_balance += amount;
            self.balances.write(to, to_balance);

            self.emit(TokensTransferred { from: caller, to, amount });
        }

        fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
            self.balances.read(user)
        }

        fn get_total_supply(self: @ContractState) -> u256 {
            self.total_supply.read()
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}