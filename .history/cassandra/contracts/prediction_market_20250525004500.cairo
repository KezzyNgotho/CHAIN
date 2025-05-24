%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_sub, uint256_mul, uint256_div
from starkware.starknet.common.syscalls import get_block_timestamp

// Constants
const PREDICTION_DURATION = 7 * 24 * 60 * 60; // 7 days in seconds
const MINIMUM_STAKE = 1000000000000000; // 0.001 ETH in wei
const PLATFORM_FEE = 200; // 2% fee (in basis points)

// Storage variables
@storage_var
func prediction_count() -> (count: felt) {
}

@storage_var
func prediction_creator(prediction_id: felt) -> (creator: felt) {
}

@storage_var
func prediction_title(prediction_id: felt) -> (title: felt) {
}

@storage_var
func prediction_end_time(prediction_id: felt) -> (end_time: felt) {
}

@storage_var
func prediction_yes_pool(prediction_id: felt) -> (amount: Uint256) {
}

@storage_var
func prediction_no_pool(prediction_id: felt) -> (amount: Uint256) {
}

@storage_var
func prediction_resolved(prediction_id: felt) -> (resolved: felt) {
}

@storage_var
func prediction_outcome(prediction_id: felt) -> (outcome: felt) {
}

@storage_var
func user_stake(prediction_id: felt, user: felt, is_yes: felt) -> (amount: Uint256) {
}

// Events
@event
func PredictionCreated(prediction_id: felt, creator: felt, title: felt, end_time: felt) {
}

@event
func StakePlaced(prediction_id: felt, user: felt, is_yes: felt, amount: Uint256) {
}

@event
func PredictionResolved(prediction_id: felt, outcome: felt) {
}

@event
func RewardClaimed(prediction_id: felt, user: felt, amount: Uint256) {
}

// External functions
@external
func create_prediction{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    title: felt, duration: felt
) -> (prediction_id: felt) {
    alloc_locals;
    let (current_time) = get_block_timestamp();
    let end_time = current_time + duration;
    
    // Get new prediction ID
    let (prediction_id) = prediction_count.read();
    prediction_count.write(prediction_id + 1);
    
    // Store prediction details
    prediction_creator.write(prediction_id, caller_address());
    prediction_title.write(prediction_id, title);
    prediction_end_time.write(prediction_id, end_time);
    prediction_resolved.write(prediction_id, 0);
    
    // Initialize pools
    prediction_yes_pool.write(prediction_id, Uint256(0, 0));
    prediction_no_pool.write(prediction_id, Uint256(0, 0));
    
    // Emit event
    PredictionCreated.emit(prediction_id, caller_address(), title, end_time);
    
    return (prediction_id=prediction_id);
}

@external
func stake{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    prediction_id: felt, is_yes: felt, amount: Uint256
) {
    alloc_locals;
    
    // Validate prediction exists and is not resolved
    let (resolved) = prediction_resolved.read(prediction_id);
    assert resolved == 0;
    
    // Validate minimum stake
    assert amount.low >= MINIMUM_STAKE;
    
    // Update user's stake
    let (current_stake) = user_stake.read(prediction_id, caller_address(), is_yes);
    let (new_stake) = uint256_add(current_stake, amount);
    user_stake.write(prediction_id, caller_address(), is_yes, new_stake);
    
    // Update pool
    if (is_yes == 1) {
        let (current_pool) = prediction_yes_pool.read(prediction_id);
        let (new_pool) = uint256_add(current_pool, amount);
        prediction_yes_pool.write(prediction_id, new_pool);
    } else {
        let (current_pool) = prediction_no_pool.read(prediction_id);
        let (new_pool) = uint256_add(current_pool, amount);
        prediction_no_pool.write(prediction_id, new_pool);
    }
    
    // Emit event
    StakePlaced.emit(prediction_id, caller_address(), is_yes, amount);
}

@external
func resolve_prediction{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    prediction_id: felt, outcome: felt
) {
    alloc_locals;
    
    // Only creator can resolve
    let (creator) = prediction_creator.read(prediction_id);
    assert caller_address() == creator;
    
    // Check if prediction has ended
    let (end_time) = prediction_end_time.read(prediction_id);
    let (current_time) = get_block_timestamp();
    assert current_time >= end_time;
    
    // Check if not already resolved
    let (resolved) = prediction_resolved.read(prediction_id);
    assert resolved == 0;
    
    // Store outcome
    prediction_resolved.write(prediction_id, 1);
    prediction_outcome.write(prediction_id, outcome);
    
    // Emit event
    PredictionResolved.emit(prediction_id, outcome);
}

@external
func claim_reward{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    prediction_id: felt
) -> (amount: Uint256) {
    alloc_locals;
    
    // Check if prediction is resolved
    let (resolved) = prediction_resolved.read(prediction_id);
    assert resolved == 1;
    
    let (outcome) = prediction_outcome.read(prediction_id);
    let (user_stake_amount) = user_stake.read(prediction_id, caller_address(), outcome);
    
    // Calculate reward
    let (yes_pool) = prediction_yes_pool.read(prediction_id);
    let (no_pool) = prediction_no_pool.read(prediction_id);
    
    let (total_pool) = uint256_add(yes_pool, no_pool);
    let (platform_fee_amount) = uint256_mul(total_pool, Uint256(PLATFORM_FEE, 0));
    let (platform_fee_amount) = uint256_div(platform_fee_amount, Uint256(10000, 0));
    
    let (reward_pool) = uint256_sub(total_pool, platform_fee_amount);
    
    // Calculate user's share
    let (user_share) = uint256_mul(user_stake_amount, reward_pool);
    let (winning_pool) = (outcome == 1) ? yes_pool : no_pool;
    let (user_share) = uint256_div(user_share, winning_pool);
    
    // Clear user's stake
    user_stake.write(prediction_id, caller_address(), outcome, Uint256(0, 0));
    
    // Emit event
    RewardClaimed.emit(prediction_id, caller_address(), user_share);
    
    return (amount=user_share);
}

// View functions
@view
func get_prediction_details(prediction_id: felt) -> (
    creator: felt,
    title: felt,
    end_time: felt,
    yes_pool: Uint256,
    no_pool: Uint256,
    resolved: felt,
    outcome: felt
) {
    let (creator) = prediction_creator.read(prediction_id);
    let (title) = prediction_title.read(prediction_id);
    let (end_time) = prediction_end_time.read(prediction_id);
    let (yes_pool) = prediction_yes_pool.read(prediction_id);
    let (no_pool) = prediction_no_pool.read(prediction_id);
    let (resolved) = prediction_resolved.read(prediction_id);
    let (outcome) = prediction_outcome.read(prediction_id);
    
    return (creator=creator, title=title, end_time=end_time, yes_pool=yes_pool, no_pool=no_pool, resolved=resolved, outcome=outcome);
}

@view
func calculate_return(
    prediction_id: felt,
    is_yes: felt,
    amount: Uint256
) -> (expected_return: Uint256) {
    alloc_locals;
    
    let (yes_pool) = prediction_yes_pool.read(prediction_id);
    let (no_pool) = prediction_no_pool.read(prediction_id);
    
    let (total_pool) = uint256_add(yes_pool, no_pool);
    let (platform_fee_amount) = uint256_mul(total_pool, Uint256(PLATFORM_FEE, 0));
    let (platform_fee_amount) = uint256_div(platform_fee_amount, Uint256(10000, 0));
    
    let (reward_pool) = uint256_sub(total_pool, platform_fee_amount);
    
    let (user_pool) = (is_yes == 1) ? yes_pool : no_pool;
    let (opposing_pool) = (is_yes == 1) ? no_pool : yes_pool;
    
    let (new_user_pool) = uint256_add(user_pool, amount);
    let (new_total_pool) = uint256_add(total_pool, amount);
    
    let (user_share) = uint256_mul(amount, new_total_pool);
    let (user_share) = uint256_div(user_share, new_user_pool);
    
    let (expected_return) = uint256_sub(user_share, amount);
    
    return (expected_return=expected_return);
} 