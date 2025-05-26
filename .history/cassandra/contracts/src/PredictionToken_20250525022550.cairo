%lang starknet

use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::ContractState;

#[starknet::interface]
trait IPredictionToken<TContractState> {
    fn transfer(ref self: TContractState, recipient: felt252, amount: u256);
    fn approve(ref self: TContractState, spender: felt252, amount: u256);
    fn transferFrom(ref self: TContractState, from: felt252, to: felt252, amount: u256);
    fn balanceOf(self: @TContractState, account: felt252) -> u256;
    fn allowance(self: @TContractState, owner: felt252, spender: felt252) -> u256;
}

#[starknet::contract]
mod PredictionToken {
    use super::ContractAddress;
    use super::get_caller_address;
    use super::ContractState;
    use super::IPredictionToken;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        total_supply: u256,
        #[feature("deprecated_legacy_map")]
        balances: LegacyMap::<felt252, u256>,
        #[feature("deprecated_legacy_map")]
        allowances: LegacyMap::<(felt252, felt252), u256>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: felt252,
        to: felt252,
        amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        owner: felt252,
        spender: felt252,
        amount: u256
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
        decimals: u8,
        initial_supply: u256,
        recipient: ContractAddress
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(decimals);
        self.total_supply.write(initial_supply);
        self.balances.write(recipient.into(), initial_supply);
        self.emit(Transfer { from: 0, to: recipient.into(), amount: initial_supply });
    }

    #[abi(embed_v0)]
    impl PredictionTokenImpl of IPredictionToken<ContractState> {
        fn transfer(ref self: ContractState, recipient: felt252, amount: u256) {
            let caller = get_caller_address();
            let balance = self.balances.read(caller);
            assert(balance >= amount, 'Insufficient balance');

            self.balances.write(caller, balance - amount);
            let recipient_balance = self.balances.read(recipient);
            self.balances.write(recipient, recipient_balance + amount);

            self.emit(Transfer { from: caller, to: recipient, amount: amount });
        }

        fn approve(ref self: ContractState, spender: felt252, amount: u256) {
            let caller = get_caller_address();
            self.allowances.write((caller, spender), amount);
            self.emit(Approval { owner: caller, spender: spender, amount: amount });
        }

        fn transferFrom(ref self: ContractState, from: felt252, to: felt252, amount: u256) {
            let caller = get_caller_address();
            let allowance = self.allowances.read((from, caller));
            assert(allowance >= amount, 'Insufficient allowance');

            let balance = self.balances.read(from);
            assert(balance >= amount, 'Insufficient balance');

            self.balances.write(from, balance - amount);
            let to_balance = self.balances.read(to);
            self.balances.write(to, to_balance + amount);
            self.allowances.write((from, caller), allowance - amount);

            self.emit(Transfer { from: from, to: to, amount: amount });
        }

        fn balanceOf(self: @ContractState, account: felt252) -> u256 {
            self.balances.read(account)
        }

        fn allowance(self: @ContractState, owner: felt252, spender: felt252) -> u256 {
            self.allowances.read((owner, spender))
        }
    }
} 