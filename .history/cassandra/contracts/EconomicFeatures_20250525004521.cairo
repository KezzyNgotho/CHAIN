%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants
const REWARD_POOL_PERCENTAGE: u64 = 5; // 5% of platform fees go to reward pool
const LIQUIDITY_POOL_PERCENTAGE: u64 = 3; // 3% of platform fees go to liquidity pool
const MARKET_MAKER_REWARD_PERCENTAGE: u64 = 2; // 2% of platform fees go to market makers
const MIN_LIQUIDITY_STAKE: u256 = 1000000000000000000; // 1 token
const MAX_LIQUIDITY_STAKE: u256 = 1000000000000000000000; // 1000 tokens
const REWARD_DISTRIBUTION_INTERVAL: u64 = 86400; // 24 hours
const MARKET_MAKER_THRESHOLD: u256 = 10000000000000000000; // 10 tokens

// Struct to store liquidity pool data
struct LiquidityPool {
    total_staked: u256,
    total_rewards: u256,
    last_distribution: u64,
    total_providers: u64,
    total_volume: u256
}

// Struct to store liquidity provider data
struct LiquidityProvider {
    amount: u256,
    last_claim: u64,
    total_earned: u256,
    entry_time: u64
}

// Struct to store market maker data
struct MarketMaker {
    total_volume: u256,
    total_markets: u64,
    total_rewards: u256,
    last_claim: u64,
    is_active: bool
}

// Struct to store reward pool data
struct RewardPool {
    total_rewards: u256,
    last_distribution: u64,
    total_claimants: u64,
    total_distributed: u256
}

// Storage variables
@storage_var
func liquidity_pool() -> (pool: LiquidityPool) {
}

@storage_var
func liquidity_providers(provider: felt252) -> (provider_data: LiquidityProvider) {
}

@storage_var
func market_makers(maker: felt252) -> (maker_data: MarketMaker) {
}

@storage_var
func reward_pool() -> (pool: RewardPool) {
}

@storage_var
func next_distribution_time() -> (time: u64) {
}

@event
func LiquidityProvided(
    provider: felt252,
    amount: u256,
    total_staked: u256
) {
}

@event
func LiquidityRemoved(
    provider: felt252,
    amount: u256,
    total_staked: u256
) {
}

@event
func RewardsClaimed(
    user: felt252,
    amount: u256,
    source: felt252
) {
}

@event
func MarketMakerRegistered(
    maker: felt252,
    initial_volume: u256
) {
}

@event
func MarketMakerDeactivated(
    maker: felt252,
    reason: felt252
) {
}

@external
func provideLiquidity{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(amount: u256) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Validate amount
    assert(amount >= MIN_LIQUIDITY_STAKE, 'Amount too low');
    assert(amount <= MAX_LIQUIDITY_STAKE, 'Amount too high');
    
    // Get pool and provider data
    let (pool) = liquidity_pool.read();
    let (provider) = liquidity_providers.read(caller);
    
    // Update provider data
    provider.amount += amount;
    provider.entry_time = current_time;
    liquidity_providers.write(caller, provider);
    
    // Update pool data
    pool.total_staked += amount;
    pool.total_providers += 1;
    liquidity_pool.write(pool);
    
    // Emit event
    LiquidityProvided.emit(caller, amount, pool.total_staked);
}

@external
func removeLiquidity{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(amount: u256) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get pool and provider data
    let (pool) = liquidity_pool.read();
    let (provider) = liquidity_providers.read(caller);
    
    // Validate amount
    assert(amount <= provider.amount, 'Amount too high');
    assert(current_time >= provider.entry_time + REWARD_DISTRIBUTION_INTERVAL, 'Too early to remove');
    
    // Update provider data
    provider.amount -= amount;
    liquidity_providers.write(caller, provider);
    
    // Update pool data
    pool.total_staked -= amount;
    if provider.amount == 0 {
        pool.total_providers -= 1;
    }
    liquidity_pool.write(pool);
    
    // Emit event
    LiquidityRemoved.emit(caller, amount, pool.total_staked);
}

@external
func registerMarketMaker{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    
    // Get maker data
    let (maker) = market_makers.read(caller);
    assert(!maker.is_active, 'Already registered');
    
    // Create new maker
    let new_maker = MarketMaker(
        total_volume=0,
        total_markets=0,
        total_rewards=0,
        last_claim=0,
        is_active=true
    );
    market_makers.write(caller, new_maker);
    
    // Emit event
    MarketMakerRegistered.emit(caller, 0);
}

@external
func updateMarketMakerStats{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(volume: u256) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get maker data
    let (maker) = market_makers.read(caller);
    assert(maker.is_active, 'Not registered as market maker');
    
    // Update stats
    maker.total_volume += volume;
    maker.total_markets += 1;
    market_makers.write(caller, maker);
    
    // Check if should be deactivated
    if maker.total_volume < MARKET_MAKER_THRESHOLD {
        maker.is_active = false;
        market_makers.write(caller, maker);
        MarketMakerDeactivated.emit(caller, 'Insufficient volume');
    }
}

@external
func claimRewards{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get pool data
    let (pool) = reward_pool.read();
    assert(current_time >= pool.last_distribution + REWARD_DISTRIBUTION_INTERVAL, 'Too early to claim');
    
    // Calculate rewards
    let (provider) = liquidity_providers.read(caller);
    let (maker) = market_makers.read(caller);
    
    let total_reward: u256 = 0;
    
    // Calculate liquidity provider rewards
    if provider.amount > 0 {
        let provider_reward = (pool.total_rewards * provider.amount) / pool.total_staked;
        total_reward += provider_reward;
        provider.total_earned += provider_reward;
        provider.last_claim = current_time;
        liquidity_providers.write(caller, provider);
    }
    
    // Calculate market maker rewards
    if maker.is_active {
        let maker_reward = (pool.total_rewards * MARKET_MAKER_REWARD_PERCENTAGE) / 100;
        total_reward += maker_reward;
        maker.total_rewards += maker_reward;
        maker.last_claim = current_time;
        market_makers.write(caller, maker);
    }
    
    // Update pool data
    pool.total_distributed += total_reward;
    pool.last_distribution = current_time;
    reward_pool.write(pool);
    
    // Emit event
    RewardsClaimed.emit(caller, total_reward, 'combined');
}

@view
func getLiquidityPoolStats{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (pool: LiquidityPool) {
    let (pool) = liquidity_pool.read();
    return (pool);
}

@view
func getLiquidityProviderStats{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(provider: felt252) -> (provider_data: LiquidityProvider) {
    let (provider_data) = liquidity_providers.read(provider);
    return (provider_data);
}

@view
func getMarketMakerStats{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(maker: felt252) -> (maker_data: MarketMaker) {
    let (maker_data) = market_makers.read(maker);
    return (maker_data);
}

@view
func getRewardPoolStats{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (pool: RewardPool) {
    let (pool) = reward_pool.read();
    return (pool);
} 