// src/token.cairo
use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::StorageMap;
use array::ArrayTrait;

#[derive(Drop, Serde, Copy, starknet::Store)]
struct Comment {
    creator: ContractAddress,
    content: felt252,
    timestamp: u64,
    likes: u32,
}

#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, description: felt252, end_time: u64);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn add_comment(ref self: TContractState, market_id: u32, content: felt252);
    fn like_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn get_comments(self: @TContractState, market_id: u32) -> Array<Comment>;
}

#[starknet::contract]
mod PredictionMarket {
    use super::{IPredictionMarket, Comment, ContractAddress, ArrayTrait};
    use starknet::{get_caller_address, get_block_timestamp, StorageMapAccess};
    
    #[storage]
    struct Storage {
        markets: StorageMap<u32, Market>,
        comments: StorageMap<(u32, u32), Comment>,
        comment_likes: StorageMap<(u32, u32, ContractAddress), bool>,
        user_comments: StorageMap<ContractAddress, Array<u32>>,
        next_market_id: u32,
        next_comment_id: u32,
    }

    #[derive(Drop, Serde, Copy, starknet::Store)]
    struct Market {
        id: u32,
        creator: ContractAddress,
        description: felt252,
        end_time: u64,
        resolved: bool,
        outcome: bool,
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) {
            let market_id = self.next_market_id.read();
            let creator = get_caller_address();
            
            let market = Market {
                id: market_id,
                creator,
                description,
                end_time,
                resolved: false,
                outcome: false,
            };
            
            self.markets.write(market_id, market);
            self.next_market_id.write(market_id + 1);
        }

        // Rest of implementation matching previous working version
        // ... (maintain same pattern for other functions)
    }
}