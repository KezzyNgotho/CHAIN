use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct SecurityConfig {
    min_stake_amount: u256,
    max_stake_amount: u256,
    market_creation_fee: u256,
    resolution_delay: u64,
    max_markets_per_user: u32
}

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct UserSecurity {
    markets_created: u32,
    last_market_creation: u64,
    is_blacklisted: bool,
    warning_count: u32
}

#[starknet::interface]
trait ISecurity<TContractState> {
    fn update_security_config(ref self: TContractState, config: SecurityConfig);
    fn blacklist_user(ref self: TContractState, user: ContractAddress);
    fn remove_from_blacklist(ref self: TContractState, user: ContractAddress);
    fn add_warning(ref self: TContractState, user: ContractAddress);
    fn get_security_config(self: @TContractState) -> SecurityConfig;
    fn get_user_security(self: @TContractState, user: ContractAddress) -> UserSecurity;
}

#[starknet::contract]
mod Security {
    use super::{SecurityConfig, UserSecurity, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        security_config: SecurityConfig,
        user_security: StorageMap::<ContractAddress, UserSecurity>,
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SecurityConfigUpdated: SecurityConfigUpdated,
        UserBlacklisted: UserBlacklisted,
        UserRemovedFromBlacklist: UserRemovedFromBlacklist,
        WarningAdded: WarningAdded,
    }

    #[derive(Drop, starknet::Event)]
    struct SecurityConfigUpdated {
        min_stake_amount: u256,
        max_stake_amount: u256,
        market_creation_fee: u256,
        resolution_delay: u64,
        max_markets_per_user: u32,
    }

    #[derive(Drop, starknet::Event)]
    struct UserBlacklisted {
        user: ContractAddress,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct UserRemovedFromBlacklist {
        user: ContractAddress,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct WarningAdded {
        user: ContractAddress,
        warning_count: u32,
        timestamp: u64,
    }

    #[abi(embed_v0)]
    impl SecurityImpl of super::ISecurity<ContractState> {
        fn update_security_config(ref self: ContractState, config: SecurityConfig) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can update config');

            self.security_config.write(config);

            self.emit(SecurityConfigUpdated {
                min_stake_amount: config.min_stake_amount,
                max_stake_amount: config.max_stake_amount,
                market_creation_fee: config.market_creation_fee,
                resolution_delay: config.resolution_delay,
                max_markets_per_user: config.max_markets_per_user,
            });
        }

        fn blacklist_user(ref self: ContractState, user: ContractAddress) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can blacklist users');

            let mut user_sec = self.user_security.read(user);
            user_sec.is_blacklisted = true;
            self.user_security.write(user, user_sec);

            self.emit(UserBlacklisted {
                user,
                timestamp: get_block_timestamp()
            });
        }

        fn remove_from_blacklist(ref self: ContractState, user: ContractAddress) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can remove from blacklist');

            let mut user_sec = self.user_security.read(user);
            user_sec.is_blacklisted = false;
            self.user_security.write(user, user_sec);

            self.emit(UserRemovedFromBlacklist {
                user,
                timestamp: get_block_timestamp()
            });
        }

        fn add_warning(ref self: ContractState, user: ContractAddress) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can add warnings');

            let mut user_sec = self.user_security.read(user);
            user_sec.warning_count += 1;
            
            // Auto-blacklist after 3 warnings
            if user_sec.warning_count >= 3 {
                user_sec.is_blacklisted = true;
            }
            
            self.user_security.write(user, user_sec);

            self.emit(WarningAdded {
                user,
                warning_count: user_sec.warning_count,
                timestamp: get_block_timestamp()
            });
        }

        fn get_security_config(self: @ContractState) -> SecurityConfig {
            self.security_config.read()
        }

        fn get_user_security(self: @ContractState, user: ContractAddress) -> UserSecurity {
            self.user_security.read(user)
        }
    }
} 