use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::storage::*; // This might cause the "Global use item" error depending on your Cairo version

// Define the contract interface
#[starknet::interface]
pub trait IToken<TContractState> {
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn get_balance(self: @TContractState, account: ContractAddress) -> u256;
    fn get_owner(self: @TContractState) -> ContractAddress;
    // Include ERC20 metadata functions as part of the common interface
    fn name(self: @TContractState) -> ByteArray;
    fn symbol(self: @TContractState) -> ByteArray;
    fn decimals(self: @TContractState) -> u8;
}

// Define the contract module
#[starknet::contract]
pub mod MyToken {
    // Corrected imports: Removed ERC20HooksEmptyImpl from here, corrected Ownable path
    use openzeppelin_token::erc20::ERC20Component;
    use openzeppelin_access::ownable::OwnableComponent;
    use starknet::ContractAddress;
    use starknet::storage::*; // This might cause the "Global use item" error depending on your Cairo version
    use starknet::get_caller_address;
    // Import necessary interfaces for embedding
    use openzeppelin_token::erc20::interface::{IERC20, IERC20Metadata};
    use openzeppelin_access::ownable::interface::IOwnable; // Assuming Ownable has an external interface trait

    // Integrate the ERC20 component
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    // Integrate the Ownable component for permissioning
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    // Implement necessary interfaces for the components
    // Embed standard ERC20 and Metadata implementations as external ABI
    #[abi(embed_v0)]
    impl ERC20Impl of IERC20<ContractState> = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20MetadataImpl of IERC20Metadata<ContractState> = ERC20Component::ERC20MetadataImpl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableImpl of IOwnable<ContractState> = OwnableComponent::OwnableImpl<ContractState>; // Embed Ownable external interface

    // Internal implementations for component logic
    impl ERC20InternalImpl of ERC20Component::InternalTrait<ContractState> = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl of OwnableComponent::InternalTrait<ContractState> = OwnableComponent::InternalImpl<ContractState>;


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
    // Define locally with the correct trait name from documentation <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/api/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">5</a>
    impl ERC20HooksEmptyImpl of ERC20Component::ERC20HooksTrait<ContractState> {
        fn before_update(
            ref self: ContractState,
            from: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {}
        fn after_update(
            ref self: ContractState,
            from: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {}
    }


    // Contract constructor
    #[constructor]
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        // Initialize the Ownable component (sets the owner)
        self.ownable.initializer(initial_owner);

        // Initialize the ERC20 component (sets name and symbol)
        // Decimals are not set here. Default is 18 unless DefaultConfig is used or customized <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">1</a>.
        let name = "PredictionMarketToken";
        let symbol = "PMT";
        self.erc20.initializer(name, symbol);
    }

    // Implement the IToken interface
    // Note: This implementation will delegate calls to the embedded component implementations
    #[abi(embed_v0)]
    impl TokenImpl of super::IToken<ContractState> {
        // Mint function (owner only)
        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            // Ensure only the contract owner can call this function
            self.ownable.assert_only_owner(); // Uses OwnableInternalImpl
            // Call the internal mint function from the ERC20 component
            self.erc20.mint(recipient, amount); // Uses ERC20InternalImpl
            // The ERC20 component will emit a Transfer event (with sender 0) which serves as TokensMinted <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/api/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">5</a>
        }

        // Transfer function (handled by the ERC20 component)
        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            // The ERC20 component's external transfer function uses the caller as sender <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/api/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">5</a>
            self.erc20.transfer(recipient, amount); // Uses ERC20Impl
        }

        // Get balance function (handled by the ERC20 component)
        fn get_balance(self: @ContractState, account: ContractAddress) -> u256 {
            // The ERC20 component handles balance storage and retrieval <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/api/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">5</a>
            self.erc20.balance_of(account) // Uses ERC20Impl
        }

        // Get owner function (handled by the Ownable component)
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.ownable.owner() // Uses OwnableImpl
        }

        // Implement ERC20 Metadata functions by calling the embedded implementation <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/api/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">5</a>
        fn name(self: @ContractState) -> ByteArray {
             self.erc20.name() // Uses ERC20MetadataImpl
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc20.symbol() // Uses ERC20MetadataImpl
        }

        fn decimals(self: @ContractState) -> u8 {
            self.erc20.decimals() // Uses ERC20MetadataImpl, default is 18 <a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">1</a><a href="https://docs.openzeppelin.com/../contracts-cairo/1.0.0/api/erc20#erc20" target="_blank" rel="noopener noreferrer" className="bg-light-secondary dark:bg-dark-secondary px-1 rounded ml-1 no-underline text-xs text-black/70 dark:text-white/70 relative hover:underline">5</a>
        }
    }
}