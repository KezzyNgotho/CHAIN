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
    created_at: u64,
    end_time: u64,
    is_resolved: bool,
    outcome: bool
}

#[starknet::interface]
trait IPredictionMarket<TContractState> {
    fn create_market(ref self: TContractState, title: felt252, description: felt252, end_time: u64);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market(self: @TContractState, market_id: u32) -> Market;
    fn get_market_count(self: @TContractState) -> u32;
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
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MarketCreated: MarketCreated,
        MarketResolved: MarketResolved,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketCreated {
        creator: ContractAddress,
        market_id: u32,
        title: felt252,
        end_time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketResolved {
        market_id: u32,
        outcome: bool,
        timestamp: u64,
    }

    #[abi(embed_v0)]
    impl PredictionMarketImpl of super::IPredictionMarket<ContractState> {
        fn create_market(ref self: ContractState, title: felt252, description: felt252, end_time: u64) {
            let caller = get_caller_address();
            let market_id = self.market_count.read();
            
            let market = Market {
                creator: caller,
                title,
                description,
                created_at: get_block_timestamp(),
                end_time,
                is_resolved: false,
                outcome: false
            };

            self.markets.write(market_id, market);
            self.market_count.write(market_id + 1);

            self.emit(MarketCreated {
                creator: caller,
                market_id,
                title,
                end_time
            });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let caller = get_caller_address();
            let mut market = self.markets.read(market_id);
            
            // Only creator can resolve
            assert(caller == market.creator, 'Only creator can resolve');
            assert(!market.is_resolved, 'Market already resolved');
            assert(get_block_timestamp() >= market.end_time, 'Market not ended');

            market.is_resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);

            self.emit(MarketResolved {
                market_id,
                outcome,
                timestamp: get_block_timestamp()
            });
        }

        fn get_market(self: @ContractState, market_id: u32) -> Market {
            self.markets.read(market_id)
        }

        fn get_market_count(self: @ContractState) -> u32 {
            self.market_count.read()
        }
    }
} 