use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct UserProfile {
    username: felt252,
    reputation: u32,
    is_verified: bool,
    created_at: u64,
    last_active: u64
}

#[starknet::interface]
trait IAuth<TContractState> {
    fn register_user(ref self: TContractState, username: felt252);
    fn verify_user(ref self: TContractState, user: ContractAddress);
    fn get_user_profile(self: @TContractState, user: ContractAddress) -> UserProfile;
    fn update_reputation(ref self: TContractState, user: ContractAddress, amount: u32);
}

#[starknet::contract]
mod Auth {
    use super::{UserProfile, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        user_profiles: StorageMap::<ContractAddress, UserProfile>,
        admins: StorageMap::<ContractAddress, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        UserRegistered: UserRegistered,
        UserVerified: UserVerified,
        ReputationUpdated: ReputationUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct UserRegistered {
        user: ContractAddress,
        username: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct UserVerified {
        user: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct ReputationUpdated {
        user: ContractAddress,
        new_reputation: u32,
    }

    #[abi(embed_v0)]
    impl AuthImpl of super::IAuth<ContractState> {
        fn register_user(ref self: ContractState, username: felt252) {
            let caller = get_caller_address();
            
            let profile = UserProfile {
                username,
                reputation: 0,
                is_verified: false,
                created_at: get_block_timestamp(),
                last_active: get_block_timestamp()
            };

            self.user_profiles.write(caller, profile);

            self.emit(UserRegistered {
                user: caller,
                username
            });
        }

        fn verify_user(ref self: ContractState, user: ContractAddress) {
            let caller = get_caller_address();
            assert(self.admins.read(caller), 'Only admins can verify users');

            let mut profile = self.user_profiles.read(user);
            profile.is_verified = true;
            self.user_profiles.write(user, profile);

            self.emit(UserVerified { user });
        }

        fn get_user_profile(self: @ContractState, user: ContractAddress) -> UserProfile {
            self.user_profiles.read(user)
        }

        fn update_reputation(ref self: ContractState, user: ContractAddress, amount: u32) {
            let mut profile = self.user_profiles.read(user);
            profile.reputation += amount;
            profile.last_active = get_block_timestamp();
            self.user_profiles.write(user, profile);

            self.emit(ReputationUpdated {
                user,
                new_reputation: profile.reputation
            });
        }
    }
} 