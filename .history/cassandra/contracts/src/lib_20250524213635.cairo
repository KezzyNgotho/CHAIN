mod auth;
mod token;
mod social;
mod economic;
mod security;

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
    use super::auth::IAuth;
    use super::token::IToken;
    use super::social::ISocial;
    use super::economic::IEconomic;
    use super::security::ISecurity;
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
        owner: ContractAddress,
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
            
            // Check user security status
            let user_sec = self.get_security().get_user_security(caller);
            assert(!user_sec.is_blacklisted, 'User is blacklisted');
            
            // Check market creation limits
            let config = self.get_security().get_security_config();
            assert(user_sec.markets_created < config.max_markets_per_user, 'Market creation limit reached');
            
            // Create market
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

            // Create market pool
            self.get_economic().create_market_pool(market_id);

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

            // Resolve market pool
            self.get_economic().resolve_market(market_id, outcome);

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

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn get_security(self: @ContractState) -> ISecurity::ISecurityDispatcher {
            ISecurity::ISecurityDispatcher { contract_address: self.owner.read() }
        }

        fn get_economic(self: @ContractState) -> IEconomic::IEconomicDispatcher {
            IEconomic::IEconomicDispatcher { contract_address: self.owner.read() }
        }
    }
} 