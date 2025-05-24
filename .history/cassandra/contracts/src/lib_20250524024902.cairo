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
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use zeroable::Zeroable;
    use array::ArrayTrait;
    use box::BoxTrait;
    use option::OptionTrait;
    use traits::TryInto;
    use integer::{u256_from_felt252, U256TryIntoFelt252};
    use starknet::get_block_timestamp;

    #[storage]
    struct Storage {
        #[feature("deprecated_legacy_map")]
        markets: LegacyMap::<u32, Market>,
        next_market_id: u32,
        #[feature("deprecated_legacy_map")]
        comments: LegacyMap::<u32, Array<Comment>>,
        #[feature("deprecated_legacy_map")]
        comment_likes: LegacyMap::<u32, Array<ContractAddress>>,
        #[feature("deprecated_legacy_map")]
        user_comments: LegacyMap::<ContractAddress, Array<u32>>,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Market {
        question: felt252,
        end_time: u64,
        resolved: bool,
        outcome: bool,
        yes_amount: u256,
        no_amount: u256,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Comment {
        id: u32,
        user: ContractAddress,
        text: felt252,
        timestamp: u64,
        likes: u32,
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
            let mut comments = self.comments.read(market_id);
            let comment_id = comments.len();
            
            let comment = Comment {
                id: comment_id,
                user: caller,
                text,
                timestamp: get_block_timestamp(),
                likes: 0,
            };
            
            comments.append(comment);
            self.comments.write(market_id, comments);
            
            // Add to user's comments
            let mut user_comments = self.user_comments.read(caller);
            user_comments.append(market_id);
            self.user_comments.write(caller, user_comments);
        }

        fn delete_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comments = self.comments.read(market_id);
            let comment = comments.at(comment_id);
            assert(comment.user == caller, 'Not comment owner');
            
            // Remove comment
            comments.pop_front();
            self.comments.write(market_id, comments);
            
            // Remove from user's comments
            let mut user_comments = self.user_comments.read(caller);
            user_comments.pop_front();
            self.user_comments.write(caller, user_comments);
        }

        fn like_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comments = self.comments.read(market_id);
            let mut comment = comments.at(comment_id);
            
            // Check if already liked
            let likes = self.comment_likes.read(comment_id);
            let mut has_liked = false;
            let mut i = 0;
            loop {
                if i >= likes.len() {
                    break;
                }
                if likes.at(i) == caller {
                    has_liked = true;
                    break;
                }
                i += 1;
            }
            
            if !has_liked {
                comment.likes += 1;
                comments.set(comment_id, comment);
                self.comments.write(market_id, comments);
                
                // Add to likes
                let mut new_likes = likes;
                new_likes.append(caller);
                self.comment_likes.write(comment_id, new_likes);
            }
        }

        fn unlike_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comments = self.comments.read(market_id);
            let mut comment = comments.at(comment_id);
            
            // Check if liked
            let likes = self.comment_likes.read(comment_id);
            let mut has_liked = false;
            let mut i = 0;
            loop {
                if i >= likes.len() {
                    break;
                }
                if likes.at(i) == caller {
                    has_liked = true;
                    break;
                }
                i += 1;
            }
            
            if has_liked {
                comment.likes -= 1;
                comments.set(comment_id, comment);
                self.comments.write(market_id, comments);
                
                // Remove from likes
                let mut new_likes = likes;
                new_likes.pop_front();
                self.comment_likes.write(comment_id, new_likes);
            }
        }

        fn get_comments(self: @ContractState, market_id: u32) -> Array<Comment> {
            self.comments.read(market_id)
        }
    }
}