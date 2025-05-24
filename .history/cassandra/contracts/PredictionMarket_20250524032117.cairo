%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Struct to store market data
struct Market {
    id: u64,
    creator: felt252,
    question: felt252,
    end_time: u64,
    resolved: bool,
    outcome: bool,
    yes_pool: u256,
    no_pool: u256,
    created_at: u64
}

// Struct to store user's stake
struct Stake {
    amount: u256,
    is_yes: bool,
    timestamp: u64
}

// Storage variables
@storage_var
func markets(market_id: u64) -> (market: Market) {
}

@storage_var
func user_stakes(market_id: u64, user: felt252) -> (stake: Stake) {
}

@storage_var
func next_market_id() -> (id: u64) {
}

@event
func MarketCreated(
    market_id: u64,
    creator: felt252,
    question: felt252,
    end_time: u64
) {
}

@event
func Staked(
    market_id: u64,
    user: felt252,
    amount: u256,
    is_yes: bool
) {
}

@event
func MarketResolved(
    market_id: u64,
    outcome: bool
) {
}

@external
func createMarket{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    question: felt252,
    end_time: u64
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Validate end time
    assert(end_time > current_time, 'End time must be in the future');
    
    // Get next market ID
    let (market_id) = next_market_id.read();
    next_market_id.write(market_id + 1);
    
    // Create new market
    let new_market = Market(
        id=market_id,
        creator=caller,
        question=question,
        end_time=end_time,
        resolved=false,
        outcome=false,
        yes_pool=0,
        no_pool=0,
        created_at=current_time
    );
    
    // Store market
    markets.write(market_id, new_market);
    
    // Emit event
    MarketCreated.emit(market_id, caller, question, end_time);
}

@external
func stake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    is_yes: bool
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get market
    let (market) = markets.read(market_id);
    assert(market.created_at != 0, 'Market does not exist');
    assert(!market.resolved, 'Market is already resolved');
    assert(current_time < market.end_time, 'Market has ended');
    
    // Get user's existing stake
    let (existing_stake) = user_stakes.read(market_id, caller);
    
    // Update pools
    if is_yes {
        market.yes_pool += amount;
    } else {
        market.no_pool += amount;
    }
    
    // Update user's stake
    let new_stake = Stake(
        amount=amount,
        is_yes=is_yes,
        timestamp=current_time
    );
    user_stakes.write(market_id, caller, new_stake);
    
    // Update market
    markets.write(market_id, market);
    
    // Emit event
    Staked.emit(market_id, caller, amount, is_yes);
}

@external
func resolveMarket{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    outcome: bool
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get market
    let (market) = markets.read(market_id);
    assert(market.created_at != 0, 'Market does not exist');
    assert(!market.resolved, 'Market is already resolved');
    assert(current_time >= market.end_time, 'Market has not ended');
    assert(caller == market.creator, 'Only creator can resolve market');
    
    // Update market
    market.resolved = true;
    market.outcome = outcome;
    markets.write(market_id, market);
    
    // Emit event
    MarketResolved.emit(market_id, outcome);
}

@view
func getMarket{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(market_id: u64) -> (market: Market) {
    let (market) = markets.read(market_id);
    return (market);
}

@view
func getUserStake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(market_id: u64, user: felt252) -> (stake: Stake) {
    let (stake) = user_stakes.read(market_id, user);
    return (stake);
} 