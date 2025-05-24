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
    title: felt252,
    description: felt252,
    creation_time: u64,
    end_time: u64,
    is_resolved: bool,
    outcome: bool,
    total_staked: u256,
    yes_staked: u256,
    no_staked: u256
}

#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, title: felt252, description: felt252, end_time: u64);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market(self: @TContractState, market_id: u32) -> Market;
    fn get_market_count(self: @TContractState) -> u32;
    fn stake_yes(ref self: TContractState, market_id: u32, amount: u256);
    fn stake_no(ref self: TContractState, market_id: u32, amount: u256);
    fn claim_winnings(ref self: TContractState, market_id: u32);
}

#[starknet::contract]
mod PredictionMarket {
    use super::{Market, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        markets: StorageMap::<u32, Market>,
        market_count: u32,
        token_contract: ContractAddress,
        user_stakes: StorageMap::<(ContractAddress, u32), (u256, u256)>, // (yes_amount, no_amount)
        has_claimed: StorageMap::<(ContractAddress, u32), bool>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MarketCreated: MarketCreated,
        MarketResolved: MarketResolved,
        TokensStaked: TokensStaked,
        WinningsClaimed: WinningsClaimed,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketCreated {
        market_id: u32,
        creator: ContractAddress,
        title: felt252,
        end_time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct MarketResolved {
        market_id: u32,
        outcome: bool
    }

    #[derive(Drop, starknet::Event)]
    struct TokensStaked {
        market_id: u32,
        user: ContractAddress,
        amount: u256,
        is_yes: bool
    }

    #[derive(Drop, starknet::Event)]
    struct WinningsClaimed {
        market_id: u32,
        user: ContractAddress,
        amount: u256
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn get_token_contract(self: @ContractState) -> ContractAddress {
            self.token_contract.read()
        }
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of super::IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, title: felt252, description: felt252, end_time: u64) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            assert(end_time > current_time, 'End time must be in the future');

            let market_id = self.market_count.read();
            self.market_count.write(market_id + 1);

            let market = Market {
                creator: caller,
                title,
                description,
                creation_time: current_time,
                end_time,
                is_resolved: false,
                outcome: false,
                total_staked: 0,
                yes_staked: 0,
                no_staked: 0
            };

            self.markets.write(market_id, market);

            self.emit(MarketCreated {
                market_id,
                creator: caller,
                title,
                end_time
            });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let caller = get_caller_address();
            let mut market = self.markets.read(market_id);
            
            assert(caller == market.creator, 'Only creator can resolve');
            assert(!market.is_resolved, 'Market already resolved');
            assert(get_block_timestamp() >= market.end_time, 'Market not ended');

            market.is_resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);

            self.emit(MarketResolved {
                market_id,
                outcome
            });
        }

        fn get_market(self: @ContractState, market_id: u32) -> Market {
            self.markets.read(market_id)
        }

        fn get_market_count(self: @ContractState) -> u32 {
            self.market_count.read()
        }

        fn stake_yes(ref self: ContractState, market_id: u32, amount: u256) {
            let caller = get_caller_address();
            let mut market = self.markets.read(market_id);
            
            assert(!market.is_resolved, 'Market already resolved');
            assert(get_block_timestamp() < market.end_time, 'Market ended');

            // Call token contract to stake
            let token_contract = self.get_token_contract();
            // TODO: Implement token contract call

            let mut user_stake = self.user_stakes.read((caller, market_id));
            user_stake.0 += amount;
            self.user_stakes.write((caller, market_id), user_stake);

            market.yes_staked += amount;
            market.total_staked += amount;
            self.markets.write(market_id, market);

            self.emit(TokensStaked {
                market_id,
                user: caller,
                amount,
                is_yes: true
            });
        }

        fn stake_no(ref self: ContractState, market_id: u32, amount: u256) {
            let caller = get_caller_address();
            let mut market = self.markets.read(market_id);
            
            assert(!market.is_resolved, 'Market already resolved');
            assert(get_block_timestamp() < market.end_time, 'Market ended');

            // Call token contract to stake
            let token_contract = self.get_token_contract();
            // TODO: Implement token contract call

            let mut user_stake = self.user_stakes.read((caller, market_id));
            user_stake.1 += amount;
            self.user_stakes.write((caller, market_id), user_stake);

            market.no_staked += amount;
            market.total_staked += amount;
            self.markets.write(market_id, market);

            self.emit(TokensStaked {
                market_id,
                user: caller,
                amount,
                is_yes: false
            });
        }

        fn claim_winnings(ref self: ContractState, market_id: u32) {
            let caller = get_caller_address();
            let market = self.markets.read(market_id);
            
            assert(market.is_resolved, 'Market not resolved');
            assert(!self.has_claimed.read((caller, market_id)), 'Already claimed');

            let user_stake = self.user_stakes.read((caller, market_id));
            let (yes_stake, no_stake) = user_stake;

            let winning_amount = if market.outcome {
                if yes_stake > 0 {
                    (yes_stake * market.total_staked) / market.yes_staked
                } else {
                    0
                }
            } else {
                if no_stake > 0 {
                    (no_stake * market.total_staked) / market.no_staked
                } else {
                    0
                }
            };

            if winning_amount > 0 {
                // Call token contract to transfer winnings
                let token_contract = self.get_token_contract();
                // TODO: Implement token contract call

                self.has_claimed.write((caller, market_id), true);

                self.emit(WinningsClaimed {
                    market_id,
                    user: caller,
                    amount: winning_amount
                });
            }
        }
    }
} 