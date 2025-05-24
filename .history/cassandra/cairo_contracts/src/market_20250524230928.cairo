use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;
use starknet::storage::StoragePointerReadAccess;
use starknet::storage::StoragePointerWriteAccess;

#[derive(Drop, starknet::Store)]
struct MarketInfo {
    description: felt252,
    creator: ContractAddress,
    end_time: u64,
    total_yes: u256,
    total_no: u256,
    resolved: bool,
    outcome: bool,
}

#[starknet::interface]
trait IMarket<TContractState> {
    fn create_market(ref self: TContractState, description: felt252, end_time: u64);
    fn place_bet(ref self: TContractState, market_id: u32, amount: u256, is_yes: bool);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn get_market_info(self: @TContractState, market_id: u32) -> MarketInfo;
}

#[starknet::contract]
mod Market {
    use super::{MarketInfo, IMarket};
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;
    use starknet::storage::StoragePointerReadAccess;
    use starknet::storage::StoragePointerWriteAccess;

    #[storage]
    struct Storage {
        markets: StorageMap::<u32, MarketInfo>,
        next_market_id: u32,
        token_contract: ContractAddress,
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
    fn constructor(ref self: ContractState, token_contract: ContractAddress) {
        self.next_market_id.write(1);
        self.token_contract.write(token_contract);
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn validate_market_exists(self: @ContractState, market_id: u32) {
            let market = self.markets.read(market_id);
            assert(market.creator != ContractAddress::default(), 'Market does not exist');
        }

        fn validate_market_not_resolved(self: @ContractState, market_id: u32) {
            let market = self.markets.read(market_id);
            assert(!market.resolved, 'Market already resolved');
        }

        fn validate_market_not_ended(self: @ContractState, market_id: u32) {
            let market = self.markets.read(market_id);
            assert(get_block_timestamp() < market.end_time, 'Market has ended');
        }
    }

    #[abi(embed_v0)]
    impl MarketImpl of super::IMarket<ContractState> {
        fn create_market(ref self: ContractState, description: felt252, end_time: u64) {
            let caller = get_caller_address();
            let market_id = self.next_market_id.read();
            
            let market = MarketInfo {
                description,
                creator: caller,
                end_time,
                total_yes: 0,
                total_no: 0,
                resolved: false,
                outcome: false,
            };

            self.markets.write(market_id, market);
            self.next_market_id.write(market_id + 1);

            self.emit(MarketCreated {
                market_id,
                creator: caller,
                description,
                end_time,
            });
        }

        fn place_bet(ref self: ContractState, market_id: u32, amount: u256, is_yes: bool) {
            let caller = get_caller_address();
            
            self.validate_market_exists(market_id);
            self.validate_market_not_resolved(market_id);
            self.validate_market_not_ended(market_id);

            let mut market = self.markets.read(market_id);
            if is_yes {
                market.total_yes += amount;
            } else {
                market.total_no += amount;
            }
            self.markets.write(market_id, market);

            self.emit(BetPlaced {
                market_id,
                user: caller,
                amount,
                is_yes,
            });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let caller = get_caller_address();
            
            self.validate_market_exists(market_id);
            self.validate_market_not_resolved(market_id);

            let mut market = self.markets.read(market_id);
            assert(caller == market.creator, 'Only creator can resolve');
            assert(get_block_timestamp() >= market.end_time, 'Market not ended yet');

            market.resolved = true;
            market.outcome = outcome;
            self.markets.write(market_id, market);

            self.emit(MarketResolved {
                market_id,
                outcome,
            });
        }

        fn get_market_info(self: @ContractState, market_id: u32) -> MarketInfo {
            self.markets.read(market_id)
        }
    }
} 