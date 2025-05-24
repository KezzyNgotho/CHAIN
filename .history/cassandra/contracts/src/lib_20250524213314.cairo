mod prediction_market;
mod auth;
mod token;
mod social;
mod economic;
mod security;

use prediction_market::PredictionMarket;
use auth::Auth;
use token::Token;
use social::Social;
use economic::Economic;
use security::Security;

// Re-export the main contract interface
pub use prediction_market::IPredictionMarket;

use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct Market {
    creator: ContractAddress,
    description: felt252,
    end_time: u64,
    resolved: bool,
    outcome: bool,
}

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct Comment {
    creator: ContractAddress,
    content: felt252,
    timestamp: u64,
    likes: u32
}

#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, description: felt252, end_time: u64) -> u32;
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn add_comment(ref self: TContractState, market_id: u32, content: felt252);
    fn like_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn get_comment(self: @TContractState, market_id: u32, comment_id: u32) -> Comment;
    fn get_comment_count(self: @TContractState, market_id: u32) -> u32;
    fn get_market(self: @TContractState, market_id: u32) -> Market;
}

#[starknet::contract]
mod PredictionMarket {
    use super::{Market, Comment, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        markets: StorageMap::<u32, Market>,
        next_market_id: u32,
        comments: StorageMap::<(u32, u32), Comment>,
        comment_likes: StorageMap::<(u32, u32, ContractAddress), bool>,
        user_comments: StorageMap::<(ContractAddress, u32), bool>,
        comment_counts: StorageMap::<u32, u32>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MarketCreated: MarketCreated,
        MarketResolved: MarketResolved,
        CommentAdded: CommentAdded,
        CommentLiked: CommentLiked,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketCreated {
        market_id: u32,
        creator: ContractAddress,
        description: felt252,
        end_time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketResolved {
        market_id: u32,
        outcome: bool,
    }

    #[derive(Drop, starknet::Event)]
    struct CommentAdded {
        market_id: u32,
        comment_id: u32,
        creator: ContractAddress,
        content: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct CommentLiked {
        market_id: u32,
        comment_id: u32,
        liker: ContractAddress,
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of super::IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) -> u32 {
            let market_id = self.next_market_id.read();
            self.next_market_id.write(market_id + 1);

            let creator = get_caller_address();
            let market = Market {
                creator,
                description,
                end_time,
                resolved: false,
                outcome: false,
            };

            self.markets.write(market_id, market);
            
            self.emit(MarketCreated { 
                market_id, 
                creator, 
                description, 
                end_time 
            });

            market_id
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(get_block_timestamp() >= market.end_time, 'Market not ended');
            assert(market.creator == get_caller_address(), 'Only creator can resolve');

            market.resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);

            self.emit(MarketResolved { 
                market_id, 
                outcome 
            });
        }

        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Cannot comment on resolved market');

            let caller = get_caller_address();
            let comment_id = self.comment_counts.read(market_id);
            
            let comment = Comment {
                creator: caller,
                content,
                timestamp: get_block_timestamp(),
                likes: 0
            };
            
            self.comments.write((market_id, comment_id), comment);
            self.comment_counts.write(market_id, comment_id + 1);
            self.user_comments.write((caller, market_id), true);

            self.emit(CommentAdded {
                market_id,
                comment_id,
                creator: caller,
                content
            });
        }

        fn like_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comment = self.comments.read((market_id, comment_id));
            
            let already_liked = self.comment_likes.read((market_id, comment_id, caller));
            if !already_liked {
                comment.likes += 1;
                self.comments.write((market_id, comment_id), comment);
                self.comment_likes.write((market_id, comment_id, caller), true);

                self.emit(CommentLiked {
                    market_id,
                    comment_id,
                    liker: caller
                });
            }
        }

        fn get_comment(self: @ContractState, market_id: u32, comment_id: u32) -> Comment {
            self.comments.read((market_id, comment_id))
        }

        fn get_comment_count(self: @ContractState, market_id: u32) -> u32 {
            self.comment_counts.read(market_id)
        }

        fn get_market(self: @ContractState, market_id: u32) -> Market {
            self.markets.read(market_id)
        }
    }
} 