%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants
const MAX_DAILY_TRANSACTIONS: u64 = 100;
const MAX_DAILY_VOLUME: u256 = 1000000000000000000000; // 1000 tokens
const EMERGENCY_COOLDOWN: u64 = 86400; // 24 hours
const MAX_FAILED_ATTEMPTS: u64 = 5;
const LOCKOUT_DURATION: u64 = 3600; // 1 hour
const MIN_OPERATOR_STAKE: u256 = 100000000000000000000; // 100 tokens

// Struct to store rate limit data
struct RateLimit {
    daily_transactions: u64,
    daily_volume: u256,
    last_reset: u64,
    failed_attempts: u64,
    last_failed: u64
}

// Struct to store operator data
struct Operator {
    address: felt252,
    stake: u256,
    is_active: bool,
    last_operation: u64,
    total_operations: u64,
    failed_operations: u64
}

// Struct to store emergency data
struct Emergency {
    is_active: bool,
    activated_by: felt252,
    activation_time: u64,
    reason: felt252,
    affected_contracts: felt252
}

// Storage variables
@storage_var
func rate_limits(user: felt252) -> (limit: RateLimit) {
}

@storage_var
func operators(operator: felt252) -> (operator_data: Operator) {
}

@storage_var
func emergency_state() -> (state: Emergency) {
}

@storage_var
func blacklisted_addresses(address: felt252) -> (is_blacklisted: bool) {
}

@storage_var
func allowed_contracts(contract: felt252) -> (is_allowed: bool) {
}

@event
func RateLimitExceeded(
    user: felt252,
    limit_type: felt252,
    value: u256
) {
}

@event
func OperatorAdded(
    operator: felt252,
    stake: u256
) {
}

@event
func OperatorRemoved(
    operator: felt252,
    reason: felt252
) {
}

@event
func EmergencyActivated(
    activated_by: felt252,
    reason: felt252,
    affected_contracts: felt252
) {
}

@event
func EmergencyDeactivated(
    deactivated_by: felt252
) {
}

@event
func AddressBlacklisted(
    address: felt252,
    reason: felt252
) {
}

@event
func AddressUnblacklisted(
    address: felt252
) {
}

@external
func checkRateLimit{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(amount: u256) -> (allowed: bool) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get rate limit data
    let (limit) = rate_limits.read(caller);
    
    // Check if needs reset
    if current_time >= limit.last_reset + 86400 {
        limit.daily_transactions = 0;
        limit.daily_volume = 0;
        limit.last_reset = current_time;
    }
    
    // Check limits
    if limit.daily_transactions >= MAX_DAILY_TRANSACTIONS {
        RateLimitExceeded.emit(caller, 'transactions', limit.daily_transactions);
        return (false);
    }
    
    if limit.daily_volume + amount > MAX_DAILY_VOLUME {
        RateLimitExceeded.emit(caller, 'volume', limit.daily_volume + amount);
        return (false);
    }
    
    // Update limits
    limit.daily_transactions += 1;
    limit.daily_volume += amount;
    rate_limits.write(caller, limit);
    
    return (true);
}

@external
func addOperator{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(operator: felt252, stake: u256) {
    let caller = get_caller_address();
    
    // Check if caller is contract owner
    assert(caller == get_contract_address(), 'Not authorized');
    
    // Validate stake
    assert(stake >= MIN_OPERATOR_STAKE, 'Stake too low');
    
    // Create operator
    let new_operator = Operator(
        address=operator,
        stake=stake,
        is_active=true,
        last_operation=0,
        total_operations=0,
        failed_operations=0
    );
    
    operators.write(operator, new_operator);
    OperatorAdded.emit(operator, stake);
}

@external
func removeOperator{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(operator: felt252, reason: felt252) {
    let caller = get_caller_address();
    
    // Check if caller is contract owner
    assert(caller == get_contract_address(), 'Not authorized');
    
    // Get operator
    let (operator_data) = operators.read(operator);
    assert(operator_data.is_active, 'Operator not active');
    
    // Update operator
    operator_data.is_active = false;
    operators.write(operator, operator_data);
    
    OperatorRemoved.emit(operator, reason);
}

@external
func activateEmergency{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(reason: felt252, affected_contracts: felt252) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check if caller is operator
    let (operator) = operators.read(caller);
    assert(operator.is_active, 'Not an active operator');
    
    // Get emergency state
    let (emergency) = emergency_state.read();
    assert(!emergency.is_active, 'Emergency already active');
    
    // Activate emergency
    let new_emergency = Emergency(
        is_active=true,
        activated_by=caller,
        activation_time=current_time,
        reason=reason,
        affected_contracts=affected_contracts
    );
    
    emergency_state.write(new_emergency);
    EmergencyActivated.emit(caller, reason, affected_contracts);
}

@external
func deactivateEmergency{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check if caller is operator
    let (operator) = operators.read(caller);
    assert(operator.is_active, 'Not an active operator');
    
    // Get emergency state
    let (emergency) = emergency_state.read();
    assert(emergency.is_active, 'Emergency not active');
    assert(current_time >= emergency.activation_time + EMERGENCY_COOLDOWN, 'Emergency cooldown not over');
    
    // Deactivate emergency
    emergency.is_active = false;
    emergency_state.write(emergency);
    
    EmergencyDeactivated.emit(caller);
}

@external
func blacklistAddress{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(address: felt252, reason: felt252) {
    let caller = get_caller_address();
    
    // Check if caller is operator
    let (operator) = operators.read(caller);
    assert(operator.is_active, 'Not an active operator');
    
    // Blacklist address
    blacklisted_addresses.write(address, true);
    AddressBlacklisted.emit(address, reason);
}

@external
func unblacklistAddress{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(address: felt252) {
    let caller = get_caller_address();
    
    // Check if caller is operator
    let (operator) = operators.read(caller);
    assert(operator.is_active, 'Not an active operator');
    
    // Unblacklist address
    blacklisted_addresses.write(address, false);
    AddressUnblacklisted.emit(address);
}

@view
func isBlacklisted{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(address: felt252) -> (blacklisted: bool) {
    let (blacklisted) = blacklisted_addresses.read(address);
    return (blacklisted);
}

@view
func getEmergencyState{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (state: Emergency) {
    let (state) = emergency_state.read();
    return (state);
}

@view
func getOperator{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(operator: felt252) -> (operator_data: Operator) {
    let (operator_data) = operators.read(operator);
    return (operator_data);
}

@view
func getRateLimit{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252) -> (limit: RateLimit) {
    let (limit) = rate_limits.read(user);
    return (limit);
} 