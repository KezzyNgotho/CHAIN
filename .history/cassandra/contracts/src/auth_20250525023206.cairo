%lang starknet

use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starkware.cairo.common.cairo_builtins::HashBuiltin;

#[starknet::contract]
mod Auth {
    use super::ContractAddress;
    use super::get_caller_address;
    use super::get_block_timestamp;

    // Struct to store user session data
    #[derive(Drop, Serde, starknet::Store)]
    struct Session {
        wallet_address: felt252,
        nonce: u64,
        last_active: u64,
        is_active: bool
    }

    // Struct to store user auth data
    #[derive(Drop, Serde, starknet::Store)]
    struct AuthData {
        wallet_address: felt252,
        username: felt252,
        has_profile: bool,
        created_at: u64,
        last_login: u64
    }

    #[storage]
    struct Storage {
        #[feature("deprecated_legacy_map")]
        sessions: LegacyMap::<felt252, Session>,
        #[feature("deprecated_legacy_map")]
        auth_data: LegacyMap::<felt252, AuthData>,
        #[feature("deprecated_legacy_map")]
        wallet_to_session: LegacyMap::<felt252, felt252>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        UserRegistered: UserRegistered,
        UserLoggedIn: UserLoggedIn,
        UserLoggedOut: UserLoggedOut,
    }

    #[derive(Drop, starknet::Event)]
    struct UserRegistered {
        wallet: felt252,
        username: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct UserLoggedIn {
        wallet: felt252,
        session_id: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct UserLoggedOut {
        wallet: felt252,
        session_id: felt252,
    }

    #[external(v0)]
    impl AuthImpl of super::Auth<ContractState> {
        fn register(ref self: ContractState, username: felt252) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            // Check if user already exists
            let existing_data = self.auth_data.read(caller);
            assert(existing_data.created_at == 0, 'User already registered');
            
            // Create new auth data
            let new_auth = AuthData(
                wallet_address: caller,
                username: username,
                has_profile: false,
                created_at: current_time,
                last_login: current_time
            );
            
            // Store auth data
            self.auth_data.write(caller, new_auth);
            
            // Emit event
            self.emit(UserRegistered { wallet: caller, username: username });
        }

        fn login(ref self: ContractState) -> felt252 {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            // Check if user exists
            let user_data = self.auth_data.read(caller);
            assert(user_data.created_at != 0, 'User not registered');
            
            // Check for existing session
            let existing_session_id = self.wallet_to_session.read(caller);
            if existing_session_id != 0 {
                // Invalidate existing session
                let mut existing_session = self.sessions.read(existing_session_id);
                existing_session.is_active = false;
                self.sessions.write(existing_session_id, existing_session);
            }
            
            // Generate new session ID (using current time as part of the ID)
            let session_id = current_time;
            
            // Create new session
            let new_session = Session(
                wallet_address: caller,
                nonce: 1,
                last_active: current_time,
                is_active: true
            );
            
            // Store session and mapping
            self.sessions.write(session_id, new_session);
            self.wallet_to_session.write(caller, session_id);
            
            // Update last login
            let mut user_data = self.auth_data.read(caller);
            user_data.last_login = current_time;
            self.auth_data.write(caller, user_data);
            
            // Emit event
            self.emit(UserLoggedIn { wallet: caller, session_id: session_id });
            
            session_id
        }

        fn logout(ref self: ContractState) {
            let caller = get_caller_address();
            
            // Get session ID
            let session_id = self.wallet_to_session.read(caller);
            assert(session_id != 0, 'No active session');
            
            // Get session
            let mut session = self.sessions.read(session_id);
            assert(session.is_active, 'Session already inactive');
            
            // Invalidate session
            session.is_active = false;
            self.sessions.write(session_id, session);
            
            // Clear session mapping
            self.wallet_to_session.write(caller, 0);
            
            // Emit event
            self.emit(UserLoggedOut { wallet: caller, session_id: session_id });
        }

        fn updateSession(ref self: ContractState, session_id: felt252) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            // Get session
            let mut session = self.sessions.read(session_id);
            assert(session.is_active, 'Session inactive');
            assert(session.wallet_address == caller, 'Invalid session');
            
            // Update session
            session.last_active = current_time;
            session.nonce += 1;
            self.sessions.write(session_id, session);
        }

        fn getSession(self: @ContractState, session_id: felt252) -> Session {
            self.sessions.read(session_id)
        }

        fn getAuthData(self: @ContractState, wallet: felt252) -> AuthData {
            self.auth_data.read(wallet)
        }

        fn isSessionValid(self: @ContractState, session_id: felt252) -> bool {
            let session = self.sessions.read(session_id);
            session.is_active
        }
    }
} 