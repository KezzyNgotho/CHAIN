use starknet::ContractAddress;
use starknet::get_caller_address;
use zeroable::Zeroable;
use array::ArrayTrait;
use box::BoxTrait;
use option::OptionTrait;
use traits::TryInto;
use integer::{u256_from_felt252, U256TryIntoFelt252};
use starknet::get_block_timestamp;
use starknet::get_contract_address;
use starknet::ContractState;

#[derive(Drop, Serde, starknet::Store)]
struct Comment {
    id: u32,
    user: ContractAddress,
    text: felt252,
    timestamp: u64,
    likes: u32,
}

#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, question: felt252, end_time: u64) -> u32;
    fn place_bet(ref self: TContractState, market_id: u32, outcome: bool, amount: u256);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market_details(self: @TContractState, market_id: u32) -> (felt252, u64, bool, u256, u256);
    fn add_comment(ref self: TContractState, market_id: u32, text: felt252);
    fn delete_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn like_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn unlike_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn get_comments(self: @TContractState, market_id: u32) -> Array<Comment>;
}

#[starknet::contract]
mod PredictionMarket {
    use super::Comment;
    use super::ContractAddress;
    use super::get_caller_address;
    use super::get_block_timestamp;
    use super::get_contract_address;
    use super::ContractState;
    use array::ArrayTrait;
    use box::BoxTrait;
    use option::OptionTrait;
    use traits::TryInto;
    use integer::{u256_from_felt252, U256TryIntoFelt252};

    #[derive(Drop, Serde, starknet::Store)]
    struct Market {
        question: felt252,
        end_time: u64,
        resolved: bool,
        outcome: bool,
        yes_amount: u256,
        no_amount: u256,
    }

    #[storage]
    struct Storage {
        #[feature("deprecated_legacy_map")]
        markets: LegacyMap::<u32, Market>,
        next_market_id: u32,
        #[feature("deprecated_legacy_map")]
        comments: LegacyMap::<(u32, u32), Comment>, // (market_id, comment_index)
        #[feature("deprecated_legacy_map")]
        comments_count: LegacyMap::<u32, u32>, // market_id -> count
        #[feature("deprecated_legacy_map")]
        comment_likes: LegacyMap::<(u32, u32), ContractAddress>, // (comment_id, like_index)
        #[feature("deprecated_legacy_map")]
        comment_likes_count: LegacyMap::<u32, u32>, // comment_id -> count
        #[feature("deprecated_legacy_map")]
        user_comments: LegacyMap::<(ContractAddress, u32), u32>, // (user, index) -> market_id
        #[feature("deprecated_legacy_map")]
        user_comments_count: LegacyMap::<ContractAddress, u32>, // user -> count
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of super::IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, question: felt252, end_time: u64) -> u32 {
            let market_id = self.next_market_id.read();
            self.next_market_id.write(market_id + 1);

            let market = Market {
                question,
                end_time,
                resolved: false,
                outcome: false,
                yes_amount: 0,
                no_amount: 0,
            };

            self.markets.write(market_id, market);
            market_id
        }

        fn place_bet(ref self: ContractState, market_id: u32, outcome: bool, amount: u256) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(get_block_timestamp() < market.end_time, 'Market ended');

            if outcome {
                market.yes_amount += amount;
            } else {
                market.no_amount += amount;
            }

            self.markets.write(market_id, market);
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let mut market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(get_block_timestamp() >= market.end_time, 'Market not ended');

            market.resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);
        }

        fn get_market_details(self: @ContractState, market_id: u32) -> (felt252, u64, bool, u256, u256) {
            let market = self.markets.read(market_id);
            (market.question, market.end_time, market.resolved, market.yes_amount, market.no_amount)
        }

        fn add_comment(ref self: ContractState, market_id: u32, text: felt252) {
            let caller = get_caller_address();
            let count = self.comments_count.read(market_id);
            let comment_id = count;
            
            let comment = Comment {
                id: comment_id,
                user: caller,
                text,
                timestamp: get_block_timestamp(),
                likes: 0,
            };
            
            self.comments.write((market_id, comment_id), comment);
            self.comments_count.write(market_id, count + 1);
            
            // Add to user's comments
            let user_count = self.user_comments_count.read(caller);
            self.user_comments.write((caller, user_count), market_id);
            self.user_comments_count.write(caller, user_count + 1);
        }

        fn delete_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let comment: Comment = self.comments.read((market_id, comment_id));
            assert(comment.user == caller, 'Not comment owner');
            
            // Remove comment by setting to a zeroed comment
            let zero_comment = Comment {
                id: comment_id,
                user: get_contract_address(),
                text: 0,
                timestamp: 0,
                likes: 0,
            };
            self.comments.write((market_id, comment_id), zero_comment);
        }

        fn like_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comment: Comment = self.comments.read((market_id, comment_id));
            
            // Check if already liked
            let likes_count = self.comment_likes_count.read(comment_id);
            let mut has_liked = false;
            let mut i = 0;
            loop {
                if i >= likes_count {
                    break;
                }
                if self.comment_likes.read((comment_id, i)) == caller {
                    has_liked = true;
                    break;
                }
                i += 1;
            }
            
            if !has_liked {
                comment.likes += 1;
                self.comments.write((market_id, comment_id), comment);
                self.comment_likes.write((comment_id, likes_count), caller);
                self.comment_likes_count.write(comment_id, likes_count + 1);
            }
        }

        fn unlike_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comment: Comment = self.comments.read((market_id, comment_id));
            
            // Check if liked
            let likes_count = self.comment_likes_count.read(comment_id);
            let mut has_liked = false;
            let mut i = 0;
            loop {
                if i >= likes_count {
                    break;
                }
                if self.comment_likes.read((comment_id, i)) == caller {
                    has_liked = true;
                    break;
                }
                i += 1;
            }
            
            if has_liked {
                comment.likes -= 1;
                self.comments.write((market_id, comment_id), comment);
                // Note: We don't remove the like from storage as Cairo doesn't support deletion
            }
        }

        fn get_comments(self: @ContractState, market_id: u32) -> Array<Comment> {
            let count = self.comments_count.read(market_id);
            let mut arr = ArrayTrait::new();
            let mut i = 0;
            loop {
                if i >= count {
                    break;
                }
                let comment: Comment = self.comments.read((market_id, i));
                ArrayTrait::append(ref arr, comment);
                i += 1;
            }
            arr
        }
    }
}