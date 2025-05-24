use starknet::ContractAddress;
use starknet::get_caller_address;
use openzeppelin::token::erc20::interface::IERC20;
use openzeppelin::access::ownable::interface::IOwnable;
use openzeppelin::access::ownable::OwnableComponent;

// Define the contract interface
#[starknet::interface]
pub trait IToken<TContractState> {
    fn mint(ref self: TContractState, to: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, to: ContractAddress, amount: u256);
    fn get_balance(self: @TContractState, user: ContractAddress) -> u256;
}

// Define the contract module
#[starknet::contract]
pub mod Token {
    use super::{IToken, ContractAddress};
    use starknet::get_caller_address;
    use openzeppelin::token::erc20::interface::IERC20;
    use openzeppelin::access::ownable::interface::IOwnable;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::ERC20Component;

    // Integrate the ERC20 component
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // Implement necessary interfaces for the components
    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // Combine storage of integrated components
    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        // You could add other storage variables here if needed
    }

    // Define events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        // You could add custom events here
    }

    // Contract constructor
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.ownable.initializer(get_caller_address());
        self.erc20.initializer('Prediction Token', 'PRED', 18);
    }

    // Implement the IToken interface
    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        // Mint function (owner only)
        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            // Ensure only the contract owner can call this function
            self.ownable.assert_only_owner();
            // Call the internal mint function from the ERC20 component
            self.erc20.mint(to, amount);
            // The ERC20 component will emit a Transfer event (with sender 0) which serves as TokensMinted
        }

        // Transfer function (handled by the ERC20 component)
        fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
            // The ERC20 component handles the transfer logic and emits events
            self.erc20.transfer(to, amount);
        }

        // Get balance function (handled by the ERC20 component)
        fn get_balance(self: @ContractState, user: ContractAddress) -> u256 {
            // The ERC20 component handles balance storage and retrieval
            self.erc20.balance_of(user)
        }
    }
}