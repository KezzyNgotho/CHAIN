// src/token.cairo
use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[starknet::interface]
pub trait IToken<TContractState> {
    fn mint(ref self: TContractState, to: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u256);
    fn get_balance(self: @TContractState, user: ContractAddress) -> u256;
}

#[starknet::contract]
pub mod Token {
    use super::IToken;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        balances: StorageMapAccess::<ContractAddress, u256>,
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TokensMinted: TokensMinted,
        TokensTransferred: TokensTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct TokensMinted {
        to: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct TokensTransferred {
        from: ContractAddress,
        to: ContractAddress,
        amount: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }

    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            assert(get_caller_address() == self.owner.read(), 'Only owner can mint');
            let balance = self.balances.read(to);
            self.balances.write(to, balance + amount);
            self.emit(TokensMinted { to, amount });
        }

        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let from_balance = self.balances.read(caller);
            assert(from_balance >= amount, 'Insufficient balance');
            
            self.balances.write(caller, from_balance - amount);
            let to_balance = self.balances.read(to);
            self.balances.write(to, to_balance + amount);
            
            self.emit(TokensTransferred { from: caller, to, amount });
        }

        fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
            self.balances.read(user)
        }
    }
}