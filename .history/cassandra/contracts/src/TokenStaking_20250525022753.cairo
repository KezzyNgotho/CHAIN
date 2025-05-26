%lang starknet

use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::ContractState;

// Struct to store stake data
#[derive(Drop, Serde, starknet::Store)]
struct Stake {
    amount: u256,
    start_time: u64,
    end_time: u64,
    last_claim_time: u64,
    is_active: bool
}

// Struct to store staking pool data
#[derive(Drop, Serde, starknet::Store)]
struct StakingPool {
    total_staked: u256,
    total_rewards: u256,
    last_update_time: u64
}

// Struct to store staking proposal data
#[derive(Drop, Serde, starknet::Store)]
struct StakingProposal {
    creator: felt252,
    title: felt252,
    description: felt252,
    required_stake: u256,
    start_time: u64,
    end_time: u64,
    yes_votes: u256,
    no_votes: u256,
    status: u8, // 0: active, 1: passed, 2: failed
    executed: bool
}

#[starknet::interface]
trait ITokenStaking<TContractState> {
    fn stake(ref self: TContractState, amount: u256, duration: u64);
    fn unstake(ref self: TContractState);
    fn claim_rewards(ref self: TContractState);
    fn create_staking_proposal(ref self: TContractState, title: felt252, description: felt252, required_stake: u256);
    fn vote_on_staking_proposal(ref self: TContractState, proposal_id: u64, vote: bool);
    fn execute_staking_proposal(ref self: TContractState, proposal_id: u64);
    fn calculate_rewards(self: @TContractState, stake: Stake) -> u256;
    fn get_stake(self: @TContractState, user: felt252) -> Stake;
    fn get_staking_pool(self: @TContractState) -> StakingPool;
    fn get_staking_proposal(self: @TContractState, proposal_id: u64) -> StakingProposal;
}

#[starknet::contract]
mod TokenStaking {
    use super::ContractAddress;
    use super::get_caller_address;
    use super::get_block_timestamp;
    use super::ContractState;
    use super::ITokenStaking;
    use super::Stake;
    use super::StakingPool;
    use super::StakingProposal;

    // Constants
    const MIN_STAKE_AMOUNT: u256 = 100;
    const MAX_STAKE_AMOUNT: u256 = 1000000;
    const MIN_STAKE_DURATION: u64 = 86400; // 1 day
    const MAX_STAKE_DURATION: u64 = 31536000; // 1 year
    const GOVERNANCE_THRESHOLD: u256 = 1000;
    const VOTING_PERIOD: u64 = 604800; // 7 days

    #[storage]
    struct Storage {
        #[feature("deprecated_legacy_map")]
        stakes: LegacyMap::<felt252, Stake>,
        #[feature("deprecated_legacy_map")]
        staking_pool: LegacyMap::<felt252, StakingPool>,
        #[feature("deprecated_legacy_map")]
        staking_proposals: LegacyMap::<u64, StakingProposal>,
        #[feature("deprecated_legacy_map")]
        next_proposal_id: LegacyMap::<felt252, u64>,
        #[feature("deprecated_legacy_map")]
        staking_votes: LegacyMap::<(u64, felt252), (bool, bool)>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Staked: Staked,
        Unstaked: Unstaked,
        RewardsClaimed: RewardsClaimed,
        StakingProposalCreated: StakingProposalCreated,
        StakingVoteCast: StakingVoteCast,
        StakingProposalExecuted: StakingProposalExecuted
    }

    #[derive(Drop, starknet::Event)]
    struct Staked {
        user: felt252,
        amount: u256,
        duration: u64
    }

    #[derive(Drop, starknet::Event)]
    struct Unstaked {
        user: felt252,
        amount: u256,
        rewards: u256
    }

    #[derive(Drop, starknet::Event)]
    struct RewardsClaimed {
        user: felt252,
        amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct StakingProposalCreated {
        proposal_id: u64,
        creator: felt252,
        title: felt252,
        required_stake: u256
    }

    #[derive(Drop, starknet::Event)]
    struct StakingVoteCast {
        proposal_id: u64,
        voter: felt252,
        vote: bool,
        stake_amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct StakingProposalExecuted {
        proposal_id: u64,
        status: u8
    }

    #[abi(embed_v0)]
    impl TokenStakingImpl of ITokenStaking<ContractState> {
        fn stake(ref self: ContractState, amount: u256, duration: u64) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            assert(amount >= MIN_STAKE_AMOUNT, 'Stake too low');
            assert(amount <= MAX_STAKE_AMOUNT, 'Stake too high');
            assert(duration >= MIN_STAKE_DURATION, 'Duration too short');
            assert(duration <= MAX_STAKE_DURATION, 'Duration too long');
            
            let existing_stake = self.stakes.read(caller);
            assert(!existing_stake.is_active, 'Already staked');
            
            let new_stake = Stake {
                amount: amount,
                start_time: current_time,
                end_time: current_time + duration,
                last_claim_time: current_time,
                is_active: true
            };
            
            let mut pool = self.staking_pool.read(0);
            pool.total_staked += amount;
            pool.last_update_time = current_time;
            self.staking_pool.write(0, pool);
            
            self.stakes.write(caller, new_stake);
            self.emit(Staked { user: caller, amount: amount, duration: duration });
        }

        fn unstake(ref self: ContractState) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            let mut stake = self.stakes.read(caller);
            assert(stake.is_active, 'No active stake');
            assert(current_time >= stake.end_time, 'Stake not matured');
            
            let rewards = self.calculate_rewards(stake);
            
            let mut pool = self.staking_pool.read(0);
            pool.total_staked -= stake.amount;
            pool.total_rewards -= rewards;
            pool.last_update_time = current_time;
            self.staking_pool.write(0, pool);
            
            stake.is_active = false;
            self.stakes.write(caller, stake);
            
            self.emit(Unstaked { user: caller, amount: stake.amount, rewards: rewards });
        }

        fn claim_rewards(ref self: ContractState) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            let mut stake = self.stakes.read(caller);
            assert(stake.is_active, 'No active stake');
            
            let rewards = self.calculate_rewards(stake);
            assert(rewards > 0, 'No rewards to claim');
            
            stake.last_claim_time = current_time;
            self.stakes.write(caller, stake);
            
            let mut pool = self.staking_pool.read(0);
            pool.total_rewards -= rewards;
            self.staking_pool.write(0, pool);
            
            self.emit(RewardsClaimed { user: caller, amount: rewards });
        }

        fn create_staking_proposal(ref self: ContractState, title: felt252, description: felt252, required_stake: u256) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            let stake = self.stakes.read(caller);
            assert(stake.is_active, 'No active stake');
            assert(stake.amount >= GOVERNANCE_THRESHOLD, 'Insufficient stake for governance');
            
            let proposal_id = self.next_proposal_id.read(0);
            self.next_proposal_id.write(0, proposal_id + 1);
            
            let proposal = StakingProposal {
                creator: caller,
                title: title,
                description: description,
                required_stake: required_stake,
                start_time: current_time,
                end_time: current_time + VOTING_PERIOD,
                yes_votes: 0,
                no_votes: 0,
                status: 0,
                executed: false
            };
            
            self.staking_proposals.write(proposal_id, proposal);
            self.emit(StakingProposalCreated { proposal_id: proposal_id, creator: caller, title: title, required_stake: required_stake });
        }

        fn vote_on_staking_proposal(ref self: ContractState, proposal_id: u64, vote: bool) {
            let caller = get_caller_address();
            let current_time = get_block_timestamp();
            
            let stake = self.stakes.read(caller);
            assert(stake.is_active, 'No active stake');
            assert(stake.amount >= GOVERNANCE_THRESHOLD, 'Insufficient stake for governance');
            
            let mut proposal = self.staking_proposals.read(proposal_id);
            assert(proposal.start_time != 0, 'Proposal does not exist');
            assert(current_time < proposal.end_time, 'Voting period ended');
            assert(proposal.status == 0, 'Proposal not active');
            
            let (has_voted, _) = self.staking_votes.read((proposal_id, caller));
            assert(!has_voted, 'Already voted');
            
            if vote {
                proposal.yes_votes += stake.amount;
            } else {
                proposal.no_votes += stake.amount;
            }
            
            self.staking_votes.write((proposal_id, caller), (true, vote));
            self.staking_proposals.write(proposal_id, proposal);
            
            self.emit(StakingVoteCast { proposal_id: proposal_id, voter: caller, vote: vote, stake_amount: stake.amount });
        }

        fn execute_staking_proposal(ref self: ContractState, proposal_id: u64) {
            let current_time = get_block_timestamp();
            
            let mut proposal = self.staking_proposals.read(proposal_id);
            assert(proposal.start_time != 0, 'Proposal does not exist');
            assert(current_time >= proposal.end_time, 'Voting period not ended');
            assert(!proposal.executed, 'Already executed');
            
            let total_votes = proposal.yes_votes + proposal.no_votes;
            let mut status: u8 = 2; // Failed by default
            
            if total_votes >= proposal.required_stake {
                if proposal.yes_votes > proposal.no_votes {
                    status = 1; // Passed
                }
            }
            
            proposal.status = status;
            proposal.executed = true;
            self.staking_proposals.write(proposal_id, proposal);
            
            self.emit(StakingProposalExecuted { proposal_id: proposal_id, status: status });
        }

        fn calculate_rewards(self: @ContractState, stake: Stake) -> u256 {
            let current_time = get_block_timestamp();
            let duration = current_time - stake.last_claim_time;
            
            // Simple linear reward calculation
            // In a real implementation, this would be more sophisticated
            let reward_rate = 100; // 1% per day
            let rewards = (stake.amount * duration.into() * reward_rate) / (86400 * 10000);
            
            rewards
        }

        fn get_stake(self: @ContractState, user: felt252) -> Stake {
            self.stakes.read(user)
        }

        fn get_staking_pool(self: @ContractState) -> StakingPool {
            self.staking_pool.read(0)
        }

        fn get_staking_proposal(self: @ContractState, proposal_id: u64) -> StakingProposal {
            self.staking_proposals.read(proposal_id)
        }
    }
} 