// SPDX-License-Identifier: MIT
// Token contract in Cairo 2.11.4

use starknet::contract_address::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;
use starknet::storage::StorageMapAccess;

#[derive(Drop, starknet::Store, starknet::Copy)]
struct TokenBalance {
    amount: u256,
}

#[starknet::contract]
mod token {
    use super::*;

    #[storage]
    struct Storage {
        balances: StorageMap::<ContractAddress, TokenBalance>,
        total_supply: u256,
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    struct TokensMinted {
        to: ContractAddress,
        amount: u256,
    }

    #[event]
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
    impl TokenImpl of ContractState {
        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can mint');

            let mut balance = self.balances.read(to);
            balance.amount += amount;
            self.balances.write(to, balance);

            self.total_supply.write(self.total_supply.read() + amount);

            self.emit(TokensMinted { to, amount });
        }

        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();

            let mut from_balance = self.balances.read(caller);
            assert(from_balance.amount >= amount, 'Insufficient balance');

            from_balance.amount -= amount;
            self.balances.write(caller, from_balance);

            let mut to_balance = self.balances.read(to);
            to_balance.amount += amount;
            self.balances.write(to, to_balance);

            self.emit(TokensTransferred { from: caller, to, amount });
        }

        fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
            self.balances.read(user).amount
        }

        fn get_total_supply(self: @ContractState) -> u256 {
            self.total_supply.read()
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}