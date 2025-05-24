%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Struct to store market data
struct Market {
    id: u64,
    creator: felt252,
    question: felt252,
    category: felt252,
    end_time: u64,
    resolved: bool,
    outcome: bool,
    yes_pool: u256,
    no_pool: u256,
    created_at: u64,
    total_staked: u256
}

// Struct to store user's stake
struct Stake {
    amount: u256,
    is_yes: bool,
    timestamp: u64,
    claimed: bool
}

// Struct to store user stats
struct UserStats {
    total_markets: u64,
    correct_predictions: u64,
    total_staked: u256,
    total_won: u256
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

@storage_var
func user_stats(user: felt252) -> (stats: UserStats) {
}

@storage_var
func category_markets(category: felt252, index: u64) -> (market_id: u64) {
}

@storage_var
func category_count(category: felt252) -> (count: u64) {
}

@event
func MarketCreated(
    market_id: u64,
    creator: felt252,
    question: felt252,
    category: felt252,
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
    outcome: bool,
    total_payout: u256
) {
}

@event
func StakeClaimed(
    market_id: u64,
    user: felt252,
    amount: u256
) {
}

@external
func createMarket{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    question: felt252,
    category: felt252,
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
        category=category,
        end_time=end_time,
        resolved=false,
        outcome=false,
        yes_pool=0,
        no_pool=0,
        created_at=current_time,
        total_staked=0
    );
    
    // Store market
    markets.write(market_id, new_market);
    
    // Add to category
    let (category_index) = category_count.read(category);
    category_markets.write(category, category_index, market_id);
    category_count.write(category, category_index + 1);
    
    // Update user stats
    let (stats) = user_stats.read(caller);
    user_stats.write(
        caller,
        UserStats(
            total_markets=stats.total_markets + 1,
            correct_predictions=stats.correct_predictions,
            total_staked=stats.total_staked,
            total_won=stats.total_won
        )
    );
    
    // Emit event
    MarketCreated.emit(market_id, caller, question, category, end_time);
}

@external
func stake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    is_yes: bool,
    amount: u256
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
    assert(existing_stake.amount == 0, 'Already staked on this market');
    
    // Update pools
    if is_yes {
        market.yes_pool += amount;
    } else {
        market.no_pool += amount;
    }
    market.total_staked += amount;
    
    // Update user's stake
    let new_stake = Stake(
        amount=amount,
        is_yes=is_yes,
        timestamp=current_time,
        claimed=false
    );
    user_stakes.write(market_id, caller, new_stake);
    
    // Update market
    markets.write(market_id, market);
    
    // Update user stats
    let (stats) = user_stats.read(caller);
    user_stats.write(
        caller,
        UserStats(
            total_markets=stats.total_markets,
            correct_predictions=stats.correct_predictions,
            total_staked=stats.total_staked + amount,
            total_won=stats.total_won
        )
    );
    
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
    MarketResolved.emit(market_id, outcome, market.total_staked);
}

@external
func claimStake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(market_id: u64) {
    let caller = get_caller_address();
    
    // Get market and stake
    let (market) = markets.read(market_id);
    let (stake) = user_stakes.read(market_id, caller);
    
    assert(market.resolved, 'Market not resolved');
    assert(stake.amount > 0, 'No stake found');
    assert(!stake.claimed, 'Stake already claimed');
    
    // Calculate payout
    let payout: u256 = 0;
    if stake.is_yes == market.outcome {
        // Calculate proportional payout
        if market.outcome {
            payout = (stake.amount * market.total_staked) / market.yes_pool;
        } else {
            payout = (stake.amount * market.total_staked) / market.no_pool;
        }
        
        // Update user stats
        let (stats) = user_stats.read(caller);
        user_stats.write(
            caller,
            UserStats(
                total_markets=stats.total_markets,
                correct_predictions=stats.correct_predictions + 1,
                total_staked=stats.total_staked,
                total_won=stats.total_won + payout
            )
        );
    }
    
    // Mark stake as claimed
    stake.claimed = true;
    user_stakes.write(market_id, caller, stake);
    
    // Emit event
    StakeClaimed.emit(market_id, caller, payout);
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

@view
func getUserStats{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252) -> (stats: UserStats) {
    let (stats) = user_stats.read(user);
    return (stats);
}

@view
func getCategoryMarkets{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(category: felt252, start: u64, count: u64) -> (market_ids: felt*) {
    let (total) = category_count.read(category);
    assert(start + count <= total, 'Invalid range');
    
    // Return array of market IDs
    let mut market_ids: felt* = alloc();
    let mut i: u64 = 0;
    loop:
        if i == count {
            return (market_ids);
        }
        let (market_id) = category_markets.read(category, start + i);
        assert(market_ids[i] = market_id);
        i += 1;
    end;
} 