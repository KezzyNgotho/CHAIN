#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, question: felt252, end_time: u64) -> u32;
    fn place_bet(ref self: TContractState, market_id: u32, outcome: bool, amount: u256);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market_details(self: @TContractState, market_id: u32) -> (felt252, u64, bool, u256, u256);
    fn add_comment(ref self: TContractState, market_id: u32, content: felt252);
    fn delete_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn like_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn unlike_comment(ref self: TContractState, market_id: u32, comment_id: u32);
    fn get_comment(self: @TContractState, market_id: u32, comment_id: u32) -> Comment;
    fn get_comment_count(self: @TContractState, market_id: u32) -> u32;
}

#[starknet::contract]
mod PredictionMarket {
    use starknet::ContractAddress;
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
        comments: StorageMap::<(u32, u32), Comment>, // (market_id, comment_id) -> Comment
        comment_likes: StorageMap::<(u32, u32, ContractAddress), bool>, // (market_id, comment_id, user) -> bool
        user_comments: StorageMap::<(ContractAddress, u32), bool>, // (user, market_id) -> bool
        comment_counts: StorageMap::<u32, u32>, // market_id -> comment_count
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
        author: ContractAddress,
        content: felt252,
        timestamp: u64,
        likes: u32
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

        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            let caller = get_caller_address();
            let comment_id = self.comment_counts.read(market_id);
            
            let comment = Comment {
                author: caller,
                content,
                timestamp: get_block_timestamp(),
                likes: 0
            };
            
            self.comments.write((market_id, comment_id), comment);
            self.comment_counts.write(market_id, comment_id + 1);
            self.user_comments.write((caller, market_id), true);
        }

        fn delete_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let comment = self.comments.read((market_id, comment_id));
            
            assert(comment.author == caller, 'Only author can delete comment');
            
            self.comments.write((market_id, comment_id), Comment {
                author: comment.author,
                content: 0,
                timestamp: comment.timestamp,
                likes: comment.likes
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
            }
        }

        fn unlike_comment(ref self: ContractState, market_id: u32, comment_id: u32) {
            let caller = get_caller_address();
            let mut comment = self.comments.read((market_id, comment_id));
            
            let already_liked = self.comment_likes.read((market_id, comment_id, caller));
            if already_liked {
                comment.likes -= 1;
                self.comments.write((market_id, comment_id), comment);
                self.comment_likes.write((market_id, comment_id, caller), false);
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