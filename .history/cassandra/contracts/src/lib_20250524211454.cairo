// Add necessary imports at the top
use starknet::StorageMap;
use array::ArrayTrait;
use serde::Serde;
use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

// Define the interface with proper generics
#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, description: felt252, end_time: u64) -> u32;
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn add_comment(ref self: TContractState, market_id: u32, content: felt252);
    fn like_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn get_comment(self: @TContractState, market_id: u32, comment_id: u32) -> Comment;
    fn get_comment_count(self: @TContractState, market_id: u32) -> u32;
}

// Add proper derive attributes to structs
#[derive(Drop, Serde, Copy)]
struct Market {
    id: u32,
    creator: ContractAddress,
    description: felt252,
    end_time: u64,
    resolved: bool,
    outcome: bool,
}

#[derive(Drop, Serde, Copy)]
struct Comment {
    id: u32,
    creator: ContractAddress,
    content: felt252,
    timestamp: u64,
    likes: u32,
}

#[starknet::contract]
mod PredictionMarket {
    use super::{Market, Comment, ContractAddress, ArrayTrait};
    use starknet::{get_contract_address, get_block_timestamp};
    use array::ArrayTrait;
    
    #[storage]
    struct Storage {
        markets: StorageMap<u32, Market>,
        // Use separate storage for comments and likes
        comments: StorageMap<(u32, u32), Comment>,  // (market_id, comment_id)
        comment_likes: StorageMap<(u32, u32, ContractAddress), bool>,  // (market_id, comment_id, user)
        user_comments: StorageMap<ContractAddress, Array<u32>>,
        next_market_id: u32,
        next_comment_id: u32,
        comment_counts: StorageMap<u32, u32>, // market_id -> comment_count
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of super::IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) -> u32 {
            let market_id = self.next_market_id.read();
            self.next_market_id.write(market_id + 1);

            let market = Market {
                id: market_id,
                creator: get_caller_address(),
                description,
                end_time,
                resolved: false,
                outcome: false,
            };
            
            self.markets.write(market_id, market);
            market_id
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, "Market already resolved");
            assert(get_block_timestamp() >= market.end_time, "Market not ended");
            
            market.resolved = true;
            market.outcome = outcome;
            
            self.markets.write(market_id, market);
        }

        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            let comment_id = self.next_comment_id.read();
            let caller = get_caller_address();
            
            let comment = Comment {
                id: comment_id,
                creator: caller,
                content,
                timestamp: get_block_timestamp(),
                likes: 0,
            };
            
            // Store comment
            self.comments.write((market_id, comment_id), comment);
            
            // Update user comments
            let mut user_comments = self.user_comments.read(caller);
            user_comments.append(comment_id);
            self.user_comments.write(caller, user_comments);
            
            self.next_comment_id.write(comment_id + 1);
            self.comment_counts.write(market_id, comment_id + 1);
        }

        fn like_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let key = (market_id, comment_id, caller);
            
            // Check if already liked
            if !self.comment_likes.read(key) {
                self.comment_likes.write(key, true);
                
                // Update comment likes count
                let mut comment = self.comments.read((market_id, comment_id));
                comment.likes += 1;
                self.comments.write((market_id, comment_id), comment);
            }
        }

        fn get_comment(self: @ContractState, market_id: u32, comment_id: u32) -> Comment {
            self.comments.read((market_id, comment_id))
        }

        fn get_comment_count(self: @ContractState, market_id: u32) -> u32 {
            self.comment_counts.read(market_id)
        }
    }
}