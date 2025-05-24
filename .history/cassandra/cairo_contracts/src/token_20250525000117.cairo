use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::*;

// Define the contract interface
#[starknet::interface]
pub trait IToken<TContractState> {
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn get_balance(self: @TContractState, account: ContractAddress) -> u256;
    fn get_owner(self: @TContractState) -> ContractAddress;
}

// Define the contract module
#[starknet::contract]
pub mod MyToken {
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin_access::ownable::ownable::OwnableComponent;
    use starknet::ContractAddress;
    use starknet::storage::*;
    use starknet::get_caller_address;

    // Integrate the ERC20 component
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    // Integrate the Ownable component for permissioning
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

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
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        // Initialize the ERC20 component (sets name and symbol)
        let name = "PredictionMarketToken";
        let symbol = "PMT";
        self.erc20.initializer(name, symbol);

        // Initialize the Ownable component (sets the owner)
        self.ownable.initializer(initial_owner);
    }

    // Implement the IToken interface
    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        // Mint function (owner only)
        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            // Ensure only the contract owner can call this function
            self.ownable.assert_only_owner();
            // Call the internal mint function from the ERC20 component
            self.erc20.mint(recipient, amount);
            // The ERC20 component will emit a Transfer event (with sender 0) which serves as TokensMinted
        }

        // Transfer function (handled by the ERC20 component)
        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            // The ERC20 component handles the transfer logic and emits events
            self.erc20.transfer(recipient, amount);
        }

        // Get balance function (handled by the ERC20 component)
        fn get_balance(self: @ContractState, account: ContractAddress) -> u256 {
            // The ERC20 component handles balance storage and retrieval
            self.erc20.balance_of(account)
        }

        // Get owner function (handled by the Ownable component)
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.ownable.owner()
        }
    }
}