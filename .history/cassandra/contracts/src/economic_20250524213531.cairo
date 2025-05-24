use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct MarketPool {
    total_staked: u256,
    yes_staked: u256,
    no_staked: u256,
    created_at: u64,
    resolved_at: u64,
    is_resolved: bool,
    outcome: bool
}

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct UserStake {
    amount: u256,
    position: bool, // true for yes, false for no
    timestamp: u64
}

#[starknet::interface]
trait IEconomic<TContractState> {
    fn create_market_pool(ref self: TContractState, market_id: u32);
    fn stake_on_market(ref self: TContractState, market_id: u32, amount: u256, position: bool);
    fn resolve_market(ref self: TContractState, market_id: u32, outcome: bool);
    fn claim_rewards(ref self: TContractState, market_id: u32);
    fn get_market_pool(self: @TContractState, market_id: u32) -> MarketPool;
    fn get_user_stake(self: @TContractState, user: ContractAddress, market_id: u32) -> UserStake;
}

#[starknet::contract]
mod Economic {
    use super::{MarketPool, UserStake, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        market_pools: StorageMap::<u32, MarketPool>,
        user_stakes: StorageMap::<(ContractAddress, u32), UserStake>,
        total_rewards: StorageMap::<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MarketPoolCreated: MarketPoolCreated,
        StakePlaced: StakePlaced,
        MarketResolved: MarketResolved,
        RewardsClaimed: RewardsClaimed,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketPoolCreated {
        market_id: u32,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct StakePlaced {
        user: ContractAddress,
        market_id: u32,
        amount: u256,
        position: bool,
    }

    #[derive(Drop, starknet::Event)]
    struct MarketResolved {
        market_id: u32,
        outcome: bool,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct RewardsClaimed {
        user: ContractAddress,
        market_id: u32,
        amount: u256,
    }

    #[abi(embed_v0)]
    impl EconomicImpl of super::IEconomic<ContractState> {
        fn create_market_pool(ref self: ContractState, market_id: u32) {
            let pool = MarketPool {
                total_staked: 0,
                yes_staked: 0,
                no_staked: 0,
                created_at: get_block_timestamp(),
                resolved_at: 0,
                is_resolved: false,
                outcome: false
            };

            self.market_pools.write(market_id, pool);

            self.emit(MarketPoolCreated {
                market_id,
                timestamp: pool.created_at
            });
        }

        fn stake_on_market(ref self: ContractState, market_id: u32, amount: u256, position: bool) {
            let caller = get_caller_address();
            let mut pool = self.market_pools.read(market_id);
            assert(!pool.is_resolved, 'Market already resolved');

            let stake = UserStake {
                amount,
                position,
                timestamp: get_block_timestamp()
            };

            self.user_stakes.write((caller, market_id), stake);

            pool.total_staked += amount;
            if position {
                pool.yes_staked += amount;
            } else {
                pool.no_staked += amount;
            }
            self.market_pools.write(market_id, pool);

            self.emit(StakePlaced {
                user: caller,
                market_id,
                amount,
                position
            });
        }

        fn resolve_market(ref self: ContractState, market_id: u32, outcome: bool) {
            let mut pool = self.market_pools.read(market_id);
            assert(!pool.is_resolved, 'Market already resolved');

            pool.is_resolved = true;
            pool.outcome = outcome;
            pool.resolved_at = get_block_timestamp();
            self.market_pools.write(market_id, pool);

            self.emit(MarketResolved {
                market_id,
                outcome,
                timestamp: pool.resolved_at
            });
        }

        fn claim_rewards(ref self: ContractState, market_id: u32) {
            let caller = get_caller_address();
            let pool = self.market_pools.read(market_id);
            assert(pool.is_resolved, 'Market not resolved');

            let stake = self.user_stakes.read((caller, market_id));
            assert(stake.amount > 0, 'No stake found');

            let reward = if stake.position == pool.outcome {
                // Calculate reward based on total pool and position
                let winning_pool = if pool.outcome { pool.yes_staked } else { pool.no_staked };
                let losing_pool = if pool.outcome { pool.no_staked } else { pool.yes_staked };
                
                if winning_pool > 0 {
                    (stake.amount * (winning_pool + losing_pool)) / winning_pool
                } else {
                    stake.amount
                }
            } else {
                0
            };

            if reward > 0 {
                let mut total_rewards = self.total_rewards.read(caller);
                total_rewards += reward;
                self.total_rewards.write(caller, total_rewards);
            }

            self.emit(RewardsClaimed {
                user: caller,
                market_id,
                amount: reward
            });
        }

        fn get_market_pool(self: @ContractState, market_id: u32) -> MarketPool {
            self.market_pools.read(market_id)
        }

        fn get_user_stake(self: @ContractState, user: ContractAddress, market_id: u32) -> UserStake {
            self.user_stakes.read((user, market_id))
        }
    }
} 