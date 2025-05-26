%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Struct to store user session data
struct Session {
    wallet_address: felt252,
    nonce: u64,
    last_active: u64,
    is_active: bool
}

// Struct to store user auth data
struct AuthData {
    wallet_address: felt252,
    username: felt252,
    has_profile: bool,
    created_at: u64,
    last_login: u64
}

// Storage variables
@storage_var
func sessions(session_id: felt252) -> (session: Session) {
}

@storage_var
func auth_data(wallet: felt252) -> (data: AuthData) {
}

@storage_var
func wallet_to_session(wallet: felt252) -> (session_id: felt252) {
}

@event
func UserRegistered(wallet: felt252, username: felt252) {
}

@event
func UserLoggedIn(wallet: felt252, session_id: felt252) {
}

@event
func UserLoggedOut(wallet: felt252, session_id: felt252) {
}

@external
func register{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    username: felt252
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check if user already exists
    let (existing_data) = auth_data.read(caller);
    assert(existing_data.created_at == 0, 'User already registered');
    
    // Create new auth data
    let new_auth = AuthData(
        wallet_address=caller,
        username=username,
        has_profile=false,
        created_at=current_time,
        last_login=current_time
    );
    
    // Store auth data
    auth_data.write(caller, new_auth);
    
    // Emit event
    UserRegistered.emit(caller, username);
}

@external
func login{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (session_id: felt252) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check if user exists
    let (user_data) = auth_data.read(caller);
    assert(user_data.created_at != 0, 'User not registered');
    
    // Check for existing session
    let (existing_session_id) = wallet_to_session.read(caller);
    if existing_session_id != 0 {
        // Invalidate existing session
        let (existing_session) = sessions.read(existing_session_id);
        existing_session.is_active = false;
        sessions.write(existing_session_id, existing_session);
    }
    
    // Generate new session ID (using current time as part of the ID)
    let session_id = current_time;
    
    // Create new session
    let new_session = Session(
        wallet_address=caller,
        nonce=1,
        last_active=current_time,
        is_active=true
    );
    
    // Store session and mapping
    sessions.write(session_id, new_session);
    wallet_to_session.write(caller, session_id);
    
    // Update last login
    user_data.last_login = current_time;
    auth_data.write(caller, user_data);
    
    // Emit event
    UserLoggedIn.emit(caller, session_id);
    
    return (session_id);
}

@external
func logout{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    
    // Get session ID
    let (session_id) = wallet_to_session.read(caller);
    assert(session_id != 0, 'No active session');
    
    // Get session
    let (session) = sessions.read(session_id);
    assert(session.is_active, 'Session already inactive');
    
    // Invalidate session
    session.is_active = false;
    sessions.write(session_id, session);
    
    // Clear session mapping
    wallet_to_session.write(caller, 0);
    
    // Emit event
    UserLoggedOut.emit(caller, session_id);
}

@external
func updateSession{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(session_id: felt252) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get session
    let (session) = sessions.read(session_id);
    assert(session.is_active, 'Session inactive');
    assert(session.wallet_address == caller, 'Invalid session');
    
    // Update session
    session.last_active = current_time;
    session.nonce += 1;
    sessions.write(session_id, session);
}

@view
func getSession{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(session_id: felt252) -> (session: Session) {
    let (session) = sessions.read(session_id);
    return (session);
}

@view
func getAuthData{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(wallet: felt252) -> (data: AuthData) {
    let (data) = auth_data.read(wallet);
    return (data);
}

@view
func isSessionValid{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(session_id: felt252) -> (valid: bool) {
    let (session) = sessions.read(session_id);
    return (session.is_active);
} 