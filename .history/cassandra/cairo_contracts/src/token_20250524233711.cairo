// src/lib.cairo
use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::StorageMap;
use array::ArrayTrait;

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
    use super::{IPredictionMarket, ContractAddress, ArrayTrait};
    use starknet::{get_caller_address, get_block_timestamp};
    use starknet::storage::StorageMap;
    
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
        owner: ContractAddress,
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
    }

    #[derive(Drop, starknet::Event)]
    struct CommentLiked {
        market_id: u32,
        comment_id: u32,
        user: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
        self.next_market_id.write(0);
        self.next_comment_id.write(0);
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) {
            let creator = get_caller_address();
            let market_id = self.next_market_id.read();
            
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
            self.emit(MarketCreated { market_id, creator });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let caller = get_caller_address();
            let mut market = self.markets.read(market_id);
            
            assert(!market.resolved, 'Market already resolved'.into());
            assert(market.creator == caller, 'Unauthorized'.into());
            
            market.resolved = true;
            market.outcome = outcome;
            
            self.markets.write(market_id, market);
            self.emit(MarketResolved { market_id, outcome });
        }

        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Market resolved'.into());
            
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
            self.emit(CommentAdded { market_id, comment_id, creator: caller });
        }

        fn like_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let key = (market_id, comment_id, caller);
            
            if !self.comment_likes.read(key) {
                self.comment_likes.write(key, true);
                
                let mut comment = self.comments.read((market_id, comment_id));
                comment.likes += 1;
                self.comments.write((market_id, comment_id), comment);
                
                self.emit(CommentLiked { market_id, comment_id, user: caller });
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