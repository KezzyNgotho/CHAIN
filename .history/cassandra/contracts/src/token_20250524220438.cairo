use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[derive(Drop, starknet::Store, starknet::Copy)]
struct TokenBalance {
    amount: u256,
    last_updated: u64
}

#[starknet::interface]
trait IToken<TContractState> {
    fn mint(ref self: TContractState, to: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u256);
    fn get_balance(self: @TContractState, user: ContractAddress) -> u256;
    fn stake(ref self: TContractState, market_id: u32, amount: u256);
    fn unstake(ref self: TContractState, market_id: u32);
}

#[starknet::contract]
mod Token {
    use super::{TokenBalance, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        balances: StorageMap::<ContractAddress, TokenBalance>,
        stakes: StorageMap::<(ContractAddress, u32), u256>,
        total_supply: u256,
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TokensMinted: TokensMinted,
        TokensTransferred: TokensTransferred,
        TokensStaked: TokensStaked,
        TokensUnstaked: TokensUnstaked,
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

    #[derive(Drop, starknet::Event)]
    struct TokensStaked {
        user: ContractAddress,
        market_id: u32,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct TokensUnstaked {
        user: ContractAddress,
        market_id: u32,
        amount: u256,
    }

    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }

    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            assert(caller == self.get_owner(), 'Only owner can mint');

            let mut balance = self.balances.read(to);
            balance.amount += amount;
            balance.last_updated = get_block_timestamp();
            self.balances.write(to, balance);

            self.total_supply.write(self.total_supply.read() + amount);

            self.emit(TokensMinted {
                to,
                amount
            });
        }

        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let mut from_balance = self.balances.read(caller);
            assert(from_balance.amount >= amount, 'Insufficient balance');

            from_balance.amount -= amount;
            from_balance.last_updated = get_block_timestamp();
            self.balances.write(caller, from_balance);

            let mut to_balance = self.balances.read(to);
            to_balance.amount += amount;
            to_balance.last_updated = get_block_timestamp();
            self.balances.write(to, to_balance);

            self.emit(TokensTransferred {
                from: caller,
                to,
                amount
            });
        }

        fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
            self.balances.read(user).amount
        }

        fn stake(ref self: ContractState, market_id: u32, amount: u256) {
            let caller = get_caller_address();
            let mut balance = self.balances.read(caller);
            assert(balance.amount >= amount, 'Insufficient balance');

            balance.amount -= amount;
            balance.last_updated = get_block_timestamp();
            self.balances.write(caller, balance);

            self.stakes.write((caller, market_id), amount);

            self.emit(TokensStaked {
                user: caller,
                market_id,
                amount
            });
        }

        fn unstake(ref self: ContractState, market_id: u32) {
            let caller = get_caller_address();
            let staked_amount = self.stakes.read((caller, market_id));
            assert(staked_amount > 0, 'No stake found');

            let mut balance = self.balances.read(caller);
            balance.amount += staked_amount;
            balance.last_updated = get_block_timestamp();
            self.balances.write(caller, balance);

            self.stakes.write((caller, market_id), 0);

            self.emit(TokensUnstaked {
                user: caller,
                market_id,
                amount: staked_amount
            });
        }
    }
} 