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
    // Optionally add ERC20 metadata functions if needed externally
    fn name(self: @TContractState) -> ByteArray;
    fn symbol(self: @TContractState) -> ByteArray;
    fn decimals(self: @TContractState) -> u8;
}

// Define the contract module
#[starknet::contract]
pub mod MyToken {
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin_access::ownable::ownable::OwnableComponent;
    use starknet::ContractAddress;
    use starknet::storage::*;
    use starknet::get_caller_address;
    use openzeppelin_token::erc20::interface::IERC20Metadata; // Needed to implement decimals if not using DefaultConfig

    // Integrate the ERC20 component
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    // Integrate the Ownable component for permissioning
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    // Implement necessary interfaces for the components
    // Embed standard ERC20 and Metadata implementations
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20MetadataImpl = ERC20Component::ERC20MetadataImpl<ContractState>; // Embed metadata impl
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // Combine storage of integrated components
    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        // If you needed custom decimals storage: decimals: u8,
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

    // Hooks implementation (required by ERC20Component)
    impl ERC20HooksEmptyImpl of ERC20Component::ERC20Hooks {
        fn before_token_transfer(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            amount: u256
        ) {}
        fn after_token_transfer(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            amount: u256
        ) {}
        fn before_token_mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {}
        fn after_token_mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {}
        fn before_token_burn(ref self: ContractState, account: ContractAddress, amount: u256) {}
        fn after_token_burn(ref self: ContractState, account: ContractAddress, amount: u256) {}
        fn before_token_approve(ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u256) {}
        fn after_token_approve(ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u256) {}
    }


    // Contract constructor
    #[constructor]
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        // Initialize the Ownable component (sets the owner)
        self.ownable.initializer(initial_owner);

        // Initialize the ERC20 component (sets name and symbol)
        // Decimals are not set here. Default is 18 unless DefaultConfig is used or customized.
        let name = "PredictionMarketToken";
        let symbol = "PMT";
        self.erc20.initializer(name, symbol);
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
            // It uses the caller's address as the sender
            let sender = get_caller_address();
            self.erc20.transfer(sender, recipient, amount);
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

        // Implement ERC20 Metadata functions if needed in your IToken interface
        fn name(self: @ContractState) -> ByteArray {
             self.erc20.name() // Assuming ERC20MetadataImpl is embedded
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc20.symbol() // Assuming ERC20MetadataImpl is embedded
        }

        fn decimals(self: @ContractState) -> u8 {
            self.erc20.decimals() // Assuming ERC20MetadataImpl is embedded, default is 18
        }
    }
}