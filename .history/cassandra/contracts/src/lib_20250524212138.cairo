// src/lib.cairo
%[PS_1]
use starknet::StorageMap;
use starknet::ContractAddress;
use array::ArrayTrait;

#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(self: @TContractState, description: felt252, end_time: u64);
    fn resolve_market(self: @TContractState, market_id: u32, outcome: bool);
    fn add_comment(self: @TContractState, market_id: u32, content: felt252);
    fn like_comment(self: @TContractState, market_id: u32, comment_id: u32);
    fn get_comments(self: @TContractState, market_id: u32) -> Array<Comment>;
}

#[starknet::contract]
mod PredictionMarket {
    use super::{IPredictionMarket, ContractAddress, ArrayTrait};
    use starknet::{get_caller_address, get_block_timestamp};
    
    #[derive(Drop, Serde, Copy, starknet::Store)]
    struct Market {
        id: u32,
        creator: ContractAddress,
        description: felt252,
        end_time: u64,
        resolved: bool,
        outcome: bool,
    }

    #[derive(Drop, Serde, Copy, starknet::Store)]
    struct Comment {
        id: u32,
        creator: ContractAddress,
        content: felt252,
        timestamp: u64,
        likes: u32,
    }

    #[storage]
    struct Storage {
        markets: StorageMap<u32, Market>,
        comments: StorageMap<(u32, u32), Comment>,  // (market_id, comment_id)
        comment_likes: StorageMap<(u32, u32, ContractAddress), bool>,
        user_comments: StorageMap<ContractAddress, Array<u32>>,
        next_market_id: u32,
        next_comment_id: u32,
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

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(market.creator == get_caller_address(), 'Unauthorized');
            
            let mut new_market = market;
            new_market.resolved = true;
            new_market.outcome = outcome;
            
            self.markets.write(market_id, new_market);
        }

        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Market resolved');
            
            let comment_id = self.next_comment_id.read();
            let caller = get_caller_address();
            
            let comment = Comment {
                id: comment_id,
                creator: caller,
                content,
                timestamp: get_block_timestamp(),
                likes: 0,
            };
            
            self.comments.write((market_id, comment_id), comment);
            
            // Update user comments
            let mut user_comments = self.user_comments.read(caller);
            user_comments.append(comment_id);
            self.user_comments.write(caller, user_comments);
            
            self.next_comment_id.write(comment_id + 1);
        }

        fn like_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let key = (market_id, comment_id, caller);
            
            if !self.comment_likes.read(key) {
                self.comment_likes.write(key, true);
                
                let mut comment = self.comments.read((market_id, comment_id));
                comment.likes += 1;
                self.comments.write((market_id, comment_id), comment);
            }
        }

        fn get_comments(self: @ContractState, market_id: u32) -> Array<Comment> {
            let mut result = ArrayTrait::new();
            let comment_count = self.next_comment_id.read();
            
            let mut i = 0;
            loop {
                if i >= comment_count {
                    break result;
                }
                
                if self.comments.read((market_id, i)).is_some() {
                    result.append(*self.comments.read((market_id, i)));
                }
                i += 1;
            }
        }
    }
}
%[PS_2]