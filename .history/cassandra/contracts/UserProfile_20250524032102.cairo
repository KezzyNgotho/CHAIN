%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Struct to store user profile data
struct UserProfile {
    username: felt252,
    bio: felt252,
    profile_picture_hash: felt252,
    wallet_address: felt252,
    created_at: u64,
    updated_at: u64
}

// Storage variables
@storage_var
func user_profiles(account: felt252) -> (profile: UserProfile) {
}

@storage_var
func wallet_to_user(wallet: felt252) -> (account: felt252) {
}

@event
func ProfileUpdated(account: felt252, username: felt252, bio: felt252, profile_picture_hash: felt252) {
}

@external
func createProfile{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    username: felt252,
    bio: felt252,
    profile_picture_hash: felt252
) {
    let caller = get_caller_address();
    
    // Check if user already has a profile
    let (existing_profile) = user_profiles.read(caller);
    assert(existing_profile.created_at == 0, 'Profile already exists');
    
    // Check if wallet is already linked
    let (existing_user) = wallet_to_user.read(caller);
    assert(existing_user == 0, 'Wallet already linked to a profile');
    
    // Create new profile
    let current_time = get_block_timestamp();
    let new_profile = UserProfile(
        username=username,
        bio=bio,
        profile_picture_hash=profile_picture_hash,
        wallet_address=caller,
        created_at=current_time,
        updated_at=current_time
    );
    
    // Store profile and wallet mapping
    user_profiles.write(caller, new_profile);
    wallet_to_user.write(caller, caller);
    
    // Emit event
    ProfileUpdated.emit(caller, username, bio, profile_picture_hash);
}

@external
func updateProfile{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    username: felt252,
    bio: felt252,
    profile_picture_hash: felt252
) {
    let caller = get_caller_address();
    
    // Check if profile exists
    let (existing_profile) = user_profiles.read(caller);
    assert(existing_profile.created_at != 0, 'Profile does not exist');
    
    // Update profile
    let current_time = get_block_timestamp();
    let updated_profile = UserProfile(
        username=username,
        bio=bio,
        profile_picture_hash=profile_picture_hash,
        wallet_address=caller,
        created_at=existing_profile.created_at,
        updated_at=current_time
    );
    
    // Store updated profile
    user_profiles.write(caller, updated_profile);
    
    // Emit event
    ProfileUpdated.emit(caller, username, bio, profile_picture_hash);
}

@view
func getProfile{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(account: felt252) -> (profile: UserProfile) {
    let (profile) = user_profiles.read(account);
    return (profile);
}

@view
func getProfileByWallet{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(wallet: felt252) -> (profile: UserProfile) {
    let (account) = wallet_to_user.read(wallet);
    assert(account != 0, 'No profile found for wallet');
    
    let (profile) = user_profiles.read(account);
    return (profile);
} 