use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;

#[derive(Drop, starknet::Store)]
pub struct MarketInfo {
    description: felt252,
    creator: ContractAddress,
    end_time: u64,
    total_yes: u256,
    total_no: u256,
    resolved: bool,
    outcome: bool,
}

#[derive(Drop, Serde, Copy, starknet::Store)]
pub struct Comment {
    creator: ContractAddress,
    content: felt252,
    timestamp: u64,
    likes: u32,
}

#[starknet::interface]
pub trait IMarket<TContractState> {
    // Market functions
    fn create_market(ref self: TContractState, description: felt252, end_time: u64);
    fn place_bet(ref self: TContractState, market_id: u32, amount: u256, is_yes: bool);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market_info(self: @TContractState, market_id: u32) -> MarketInfo;
    
    // Comment functions
    fn add_comment(ref self: TContractState, market_id: u32, content: felt252);
    fn like_comment(ref self: TContractState, comment_id: u32);
    fn get_comments(self: @TContractState, market_id: u32) -> Array<Comment>;
}

#[starknet::contract]
pub mod Market {
    use super::{MarketInfo, Comment, IMarket};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use starknet::storage::StorageMap;
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        // Market storage
        markets: StorageMap<u32, MarketInfo>,
        next_market_id: u32,
        
        // Comment storage
        market_comments: StorageMap<u32, Array<u32>>,  // market_id -> comment_ids
        comments: StorageMap<u32, Comment>,            // comment_id -> Comment
        comment_likes: StorageMap<(u32, ContractAddress), bool>, // (comment_id, user)
        user_comments: StorageMap<ContractAddress, Array<u32>>, // user -> comment_ids
        next_comment_id: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MarketCreated: MarketCreated,
        BetPlaced: BetPlaced,
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
    struct BetPlaced {
        market_id: u32,
        user: ContractAddress,
        amount: u256,
        is_yes: bool,
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
        user: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct CommentLiked {
        comment_id: u32,
        user: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.next_market_id.write(1);
        self.next_comment_id.write(1);
    }

    #[abi(embed_v0)]
    impl MarketImpl of IMarket<ContractState> {
        // Market functions implementation
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) {
            let market_id = self.next_market_id.read();
            let creator = get_caller_address();

            let new_market = MarketInfo {
                description,
                creator,
                end_time,
                total_yes: 0,
                total_no: 0,
                resolved: false,
                outcome: false,
            };

            self.markets.write(market_id, new_market);
            self.next_market_id.write(market_id + 1);

            self.emit(MarketCreated {
                market_id,
                creator,
                description,
                end_time,
            });
        }

        fn place_bet(ref self: ContractState, market_id: u32, amount: u256, is_yes: bool) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, 'Market resolved');
            assert(get_block_timestamp() < market.end_time, 'Market ended');

            if is_yes {
                market.total_yes += amount;
            } else {
                market.total_no += amount;
            }

            self.markets.write(market_id, market);
            self.emit(BetPlaced {
                market_id,
                user: get_caller_address(),
                amount,
                is_yes,
            });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let mut market = self.markets.read(market_id);
            assert(market.creator == get_caller_address(), 'Not creator');
            assert(!market.resolved, 'Already resolved');
            assert(get_block_timestamp() >= market.end_time, 'Market ongoing');

            market.resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);
            self.emit(MarketResolved { market_id, outcome });
        }

        fn get_market_info(self: @ContractState, market_id: u32) -> MarketInfo {
            self.markets.read(market_id)
        }

        // Comment functions implementation
        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            assert(self.markets.contains(market_id), 'Invalid market');
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Market resolved');

            let comment_id = self.next_comment_id.read();
            let caller = get_caller_address();
            let timestamp = get_block_timestamp();

            let comment = Comment {
                creator: caller,
                content,
                timestamp,
                likes: 0,
            };

            // Store comment
            self.comments.write(comment_id, comment);

            // Update market comments
            let mut m_comments = self.market_comments.read(market_id);
            m_comments.append(comment_id);
            self.market_comments.write(market_id, m_comments);

            // Update user comments
            let mut u_comments = self.user_comments.read(caller);
            u_comments.append(comment_id);
            self.user_comments.write(caller, u_comments);

            self.next_comment_id.write(comment_id + 1);
            self.emit(CommentAdded { market_id, comment_id, user: caller });
        }

        fn like_comment(ref self: ContractState, comment_id: u32) {
            assert(self.comments.contains(comment_id), 'Invalid comment');
            let caller = get_caller_address();
            let key = (comment_id, caller);

            if !self.comment_likes.read(key) {
                self.comment_likes.write(key, true);

                let mut comment = self.comments.read(comment_id);
                comment.likes += 1;
                self.comments.write(comment_id, comment);

                self.emit(CommentLiked { comment_id, user: caller });
            }
        }

        fn get_comments(self: @ContractState, market_id: u32) -> Array<Comment> {
            let comment_ids = self.market_comments.read(market_id);
            let mut result = ArrayTrait::new();
            
            let len = comment_ids.len();
            let mut i = 0;
            loop {
                if i >= len {
                    break result;
                }
                let comment_id = *comment_ids.at(i);
                result.append(self.comments.read(comment_id));
                i += 1;
            }
        }
    }
}