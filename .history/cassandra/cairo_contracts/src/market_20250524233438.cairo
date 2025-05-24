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

#[starknet::interface]
pub trait IMarket<TContractState> {
    fn create_market(ref self: TContractState, description: felt252, end_time: u64);
    fn place_bet(ref self: TContractState, market_id: u32, amount: u256, is_yes: bool);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market_info(self: @TContractState, market_id: u32) -> MarketInfo;
}

#[starknet::contract]
pub mod Market {
    use super::{MarketInfo, IMarket};
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;

    #[storage]
    struct Storage {
        markets: StorageMap::<u32, MarketInfo>,
        next_market_id: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MarketCreated: MarketCreated,
        BetPlaced: BetPlaced,
        MarketResolved: MarketResolved,
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

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.next_market_id.write(1);
    }

    #[abi(embed_v0)]
    impl MarketImpl of super::IMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) {
            let market_id = self.next_market_id.read();
            let new_market = MarketInfo {
                description,
                creator: get_caller_address(),
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
                creator: get_caller_address(),
                description,
                end_time,
            });
        }

        fn place_bet(ref self: ContractState, market_id: u32, amount: u256, is_yes: bool) {
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
            assert(get_block_timestamp() < market.end_time, 'Market has ended');

            let mut updated_market = market;
            if is_yes {
                updated_market.total_yes += amount;
            } else {
                updated_market.total_no += amount;
            }
            self.markets.write(market_id, updated_market);

            self.emit(BetPlaced {
                market_id,
                user: get_caller_address(),
                amount,
                is_yes,
            });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let market = self.markets.read(market_id);
            assert(get_caller_address() == market.creator, 'Only creator can resolve');
            assert(!market.resolved, 'Market already resolved');
            assert(get_block_timestamp() >= market.end_time, 'Market not ended yet');

            let mut updated_market = market;
            updated_market.resolved = true;
            updated_market.outcome = outcome;
            self.markets.write(market_id, updated_market);

            self.emit(MarketResolved { market_id, outcome });
        }

        fn get_market_info(self: @ContractState, market_id: u32) -> MarketInfo {
            self.markets.read(market_id)
        }
    }
} 