%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Storage variables
@storage_var
func name() -> (name: felt252) {
}

@storage_var
func symbol() -> (symbol: felt252) {
}

@storage_var
func decimals() -> (decimals: u8) {
}

@storage_var
func total_supply() -> (supply: u256) {
}

@storage_var
func balances(account: felt252) -> (balance: u256) {
}

@storage_var
func allowances(owner: felt252, spender: felt252) -> (amount: u256) {
}

@event
func Transfer(from: felt252, to: felt252, amount: u256) {
}

@event
func Approval(owner: felt252, spender: felt252, amount: u256) {
}

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    name: felt252,
    symbol: felt252,
    decimals: u8,
    initial_supply: u256,
    recipient: felt252
) {
    name.write(name);
    symbol.write(symbol);
    decimals.write(decimals);
    total_supply.write(initial_supply);
    balances.write(recipient, initial_supply);
    Transfer.emit(0, recipient, initial_supply);
}

@external
func transfer{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(recipient: felt252, amount: u256) {
    let caller = get_caller_address();
    
    // Check balance
    let (balance) = balances.read(caller);
    assert(balance >= amount, 'Insufficient balance');
    
    // Update balances
    balances.write(caller, balance - amount);
    let (recipient_balance) = balances.read(recipient);
    balances.write(recipient, recipient_balance + amount);
    
    // Emit event
    Transfer.emit(caller, recipient, amount);
}

@external
func approve{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(spender: felt252, amount: u256) {
    let caller = get_caller_address();
    
    // Update allowance
    allowances.write(caller, spender, amount);
    
    // Emit event
    Approval.emit(caller, spender, amount);
}

@external
func transferFrom{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(from: felt252, to: felt252, amount: u256) {
    let caller = get_caller_address();
    
    // Check allowance
    let (allowance) = allowances.read(from, caller);
    assert(allowance >= amount, 'Insufficient allowance');
    
    // Check balance
    let (balance) = balances.read(from);
    assert(balance >= amount, 'Insufficient balance');
    
    // Update balances and allowance
    balances.write(from, balance - amount);
    let (to_balance) = balances.read(to);
    balances.write(to, to_balance + amount);
    allowances.write(from, caller, allowance - amount);
    
    // Emit event
    Transfer.emit(from, to, amount);
}

@view
func balanceOf{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(account: felt252) -> (balance: u256) {
    let (balance) = balances.read(account);
    return (balance);
}

@view
func allowance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(owner: felt252, spender: felt252) -> (amount: u256) {
    let (amount) = allowances.read(owner, spender);
    return (amount);
} 