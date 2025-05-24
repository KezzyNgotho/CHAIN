%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants
const PLATFORM_FEE_PERCENTAGE: u64 = 2; // 2% platform fee
const MIN_MARKET_DURATION: u64 = 3600; // 1 hour
const MAX_MARKET_DURATION: u64 = 2592000; // 30 days
const COOLDOWN_PERIOD: u64 = 86400; // 24 hours
const MAX_STAKE_AMOUNT: u256 = 1000000000000000000000; // 1000 tokens
const WITHDRAWAL_DELAY: u64 = 86400; // 24 hours

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
    total_staked: u256,
    is_verified: bool,
    is_cancelled: bool,
    last_creator_market: u64,
    platform_fee: u256,
    dispute_count: u64
}

// Struct to store user's stake
struct Stake {
    amount: u256,
    is_yes: bool,
    timestamp: u64,
    claimed: bool,
    withdrawal_time: u64
}

// Struct to store user stats
struct UserStats {
    total_markets: u64,
    correct_predictions: u64,
    total_staked: u256,
    total_won: u256,
    last_market_created: u64,
    total_fees_paid: u256
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

@storage_var
func platform_fees() -> (fees: u256) {
}

@storage_var
func is_paused() -> (paused: bool) {
}

@storage_var
func verified_creators(creator: felt252) -> (is_verified: bool) {
}

@storage_var
func market_reports(market_id: u64, reporter: felt252) -> (reported: bool) {
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
    total_payout: u256,
    platform_fee: u256
) {
}

@event
func StakeClaimed(
    market_id: u64,
    user: felt252,
    amount: u256
) {
}

@event
func MarketCancelled(
    market_id: u64,
    reason: felt252
) {
}

@event
func MarketReported(
    market_id: u64,
    reporter: felt252,
    reason: felt252
) {
}

@event
func CreatorVerified(
    creator: felt252
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
    
    // Check if contract is paused
    let (paused) = is_paused.read();
    assert(!paused, 'Contract is paused');
    
    // Check cooldown period
    let (stats) = user_stats.read(caller);
    assert(current_time >= stats.last_market_created + COOLDOWN_PERIOD, 'Cooldown period not over');
    
    // Validate end time
    assert(end_time > current_time + MIN_MARKET_DURATION, 'End time too soon');
    assert(end_time <= current_time + MAX_MARKET_DURATION, 'End time too far');
    
    // Get next market ID
    let (market_id) = next_market_id.read();
    next_market_id.write(market_id + 1);
    
    // Check if creator is verified
    let (is_verified) = verified_creators.read(caller);
    
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
        total_staked=0,
        is_verified=is_verified,
        is_cancelled=false,
        last_creator_market=stats.last_market_created,
        platform_fee=0,
        dispute_count=0
    );
    
    // Store market
    markets.write(market_id, new_market);
    
    // Add to category
    let (category_index) = category_count.read(category);
    category_markets.write(category, category_index, market_id);
    category_count.write(category, category_index + 1);
    
    // Update user stats
    user_stats.write(
        caller,
        UserStats(
            total_markets=stats.total_markets + 1,
            correct_predictions=stats.correct_predictions,
            total_staked=stats.total_staked,
            total_won=stats.total_won,
            last_market_created=current_time,
            total_fees_paid=stats.total_fees_paid
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
    
    // Check if contract is paused
    let (paused) = is_paused.read();
    assert(!paused, 'Contract is paused');
    
    // Validate stake amount
    assert(amount <= MAX_STAKE_AMOUNT, 'Stake amount too high');
    
    // Get market
    let (market) = markets.read(market_id);
    assert(market.created_at != 0, 'Market does not exist');
    assert(!market.resolved, 'Market is already resolved');
    assert(!market.is_cancelled, 'Market is cancelled');
    assert(current_time < market.end_time, 'Market has ended');
    
    // Get user's existing stake
    let (existing_stake) = user_stakes.read(market_id, caller);
    assert(existing_stake.amount == 0, 'Already staked on this market');
    
    // Calculate platform fee
    let platform_fee = (amount * PLATFORM_FEE_PERCENTAGE) / 100;
    let stake_amount = amount - platform_fee;
    
    // Update pools
    if is_yes {
        market.yes_pool += stake_amount;
    } else {
        market.no_pool += stake_amount;
    }
    market.total_staked += stake_amount;
    market.platform_fee += platform_fee;
    
    // Update platform fees
    let (total_fees) = platform_fees.read();
    platform_fees.write(total_fees + platform_fee);
    
    // Update user's stake
    let new_stake = Stake(
        amount=stake_amount,
        is_yes=is_yes,
        timestamp=current_time,
        claimed=false,
        withdrawal_time=current_time + WITHDRAWAL_DELAY
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
            total_staked=stats.total_staked + stake_amount,
            total_won=stats.total_won,
            last_market_created=stats.last_market_created,
            total_fees_paid=stats.total_fees_paid + platform_fee
        )
    );
    
    // Emit event
    Staked.emit(market_id, caller, stake_amount, is_yes);
}

@external
func reportMarket{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    reason: felt252
) {
    let caller = get_caller_address();
    
    // Get market
    let (market) = markets.read(market_id);
    assert(market.created_at != 0, 'Market does not exist');
    assert(!market.resolved, 'Market is already resolved');
    
    // Check if already reported
    let (reported) = market_reports.read(market_id, caller);
    assert(!reported, 'Already reported this market');
    
    // Mark as reported
    market_reports.write(market_id, caller, true);
    market.dispute_count += 1;
    markets.write(market_id, market);
    
    // Emit event
    MarketReported.emit(market_id, caller, reason);
}

@external
func cancelMarket{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    reason: felt252
) {
    let caller = get_caller_address();
    
    // Get market
    let (market) = markets.read(market_id);
    assert(market.created_at != 0, 'Market does not exist');
    assert(!market.resolved, 'Market is already resolved');
    assert(!market.is_cancelled, 'Market is already cancelled');
    assert(caller == market.creator || market.dispute_count >= 3, 'Not authorized to cancel');
    
    // Cancel market
    market.is_cancelled = true;
    markets.write(market_id, market);
    
    // Emit event
    MarketCancelled.emit(market_id, reason);
}

@external
func verifyCreator{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(creator: felt252) {
    let caller = get_caller_address();
    // Only contract owner can verify creators
    assert(caller == get_contract_address(), 'Not authorized');
    
    verified_creators.write(creator, true);
    CreatorVerified.emit(creator);
}

@external
func togglePause{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    // Only contract owner can pause
    assert(caller == get_contract_address(), 'Not authorized');
    
    let (paused) = is_paused.read();
    is_paused.write(!paused);
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
    MarketResolved.emit(market_id, outcome, market.total_staked, market.platform_fee);
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