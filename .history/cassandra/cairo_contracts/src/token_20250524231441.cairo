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
        total_supply: u256,
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
        let deployer = get_caller_address();
        self.owner.write(deployer);
        self.total_supply.write(0);
    }

    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Only owner can mint');

            let mut balance = self.balances.read(to);
            balance += amount;
            self.balances.write(to, balance);

            let mut total_supply = self.total_supply.read();
            total_supply += amount;
            self.total_supply.write(total_supply);

            self.emit(TokensMinted {
                to,
                amount
            });
        }

        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let mut from_balance = self.balances.read(caller);
            assert(from_balance >= amount, 'Insufficient balance');

            from_balance -= amount;
            self.balances.write(caller, from_balance);

            let mut to_balance = self.balances.read(to);
            to_balance += amount;
            self.balances.write(to, to_balance);

            self.emit(TokensTransferred {
                from: caller,
                to,
                amount
            });
        }

        fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
            self.balances.read(user)
        }
    }
}