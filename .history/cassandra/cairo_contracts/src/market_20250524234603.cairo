// src/market.cairo
use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use array::ArrayTrait;

#[derive(Drop, Serde, starknet::Store)]
struct MarketInfo {
    description: felt252,
    creator: ContractAddress,
    end_time: u64,
    total_yes: u256,
    total_no: u256,
    resolved: bool,
    outcome: bool,
}

#[starknet::interface]
trait IMarket<TContractState> {
    fn create_market(ref self: TContractState, description: felt252, end_time: u64);
    fn place_bet(ref self: TContractState, market_id: u32, amount: u256, is_yes: bool);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market_info(self: @TContractState, market_id: u32) -> MarketInfo;
}

#[starknet::contract]
mod MarketContract {
    use super::{MarketInfo, IMarket, ContractAddress, ArrayTrait};
    use starknet::{get_caller_address, get_block_timestamp, StorageMapAccess};
    
    #[storage]
    struct Storage {
        markets: StorageMap<u32, MarketInfo>,
        next_market_id: u32,
        // Add other storage items as needed
    }

    #[abi(embed_v0)]
    impl MarketImpl of IMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) {
            let market_id = self.next_market_id.read();
            
            let new_market = MarketInfo {
                description,
                creator: get_caller_address(),
                end_time,
                total_yes: 0,
                total_no: 0,
                resolved: false,
                outcome: false,
            };

            self.markets.write(market_id, new_market);
            self.next_market_id.write(market_id + 1);
        }

        // Rest of implementation
        // ... (maintain same pattern for other functions)
    }
}