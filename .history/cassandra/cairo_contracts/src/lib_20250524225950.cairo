use starknet::ContractAddress;

mod token;
mod market;
//mod oracle;
//mod staking;
//mod governance;

// Re-export contracts
pub use token::Token;
pub use market::Market;
//pub use oracle::Oracle;
//pub use staking::Staking;
//pub use governance::Governance;

// Re-export interfaces
pub use market::IMarket;
pub use token::IToken;
//pub use oracle::IOracle;
//pub use staking::IStaking;
//pub use governance::IGovernance;