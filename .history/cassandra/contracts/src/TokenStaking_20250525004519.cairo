%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants
const MIN_STAKE_AMOUNT: u256 = 1000000000000000000; // 1 token
const MAX_STAKE_AMOUNT: u256 = 1000000000000000000000; // 1000 tokens
const REWARD_RATE: u256 = 100; // 1% per day
const MIN_STAKE_DURATION: u64 = 86400; // 24 hours
const MAX_STAKE_DURATION: u64 = 31536000; // 1 year
const GOVERNANCE_THRESHOLD: u256 = 10000000000000000000; // 10 tokens

// Struct to store stake data
struct Stake {
    amount: u256,
    start_time: u64,
    end_time: u64,
    last_claim_time: u64,
    total_rewards: u256,
    is_active: bool
}

// Struct to store staking pool data
struct StakingPool {
    total_staked: u256,
    total_rewards: u256,
    reward_rate: u256,
    last_update_time: u64,
    min_stake_duration: u64,
    max_stake_duration: u64
}

// Struct to store governance proposal
struct StakingProposal {
    id: u64,
    proposer: felt252,
    title: felt252,
    description: felt252,
    start_time: u64,
    end_time: u64,
    yes_votes: u256,
    no_votes: u256,
    required_stake: u256,
    status: u8, // 0: Active, 1: Passed, 2: Failed, 3: Executed
    executed: bool
}

// Storage variables
@storage_var
func stakes(user: felt252) -> (stake: Stake) {
}

@storage_var
func staking_pool() -> (pool: StakingPool) {
}

@storage_var
func staking_proposals(proposal_id: u64) -> (proposal: StakingProposal) {
}

@storage_var
func next_proposal_id() -> (id: u64) {
}

@storage_var
func staking_votes(proposal_id: u64, voter: felt252) -> (has_voted: bool, vote: bool) {
}

@event
func Staked(
    user: felt252,
    amount: u256,
    duration: u64
) {
}

@event
func Unstaked(
    user: felt252,
    amount: u256,
    rewards: u256
) {
}

@event
func RewardsClaimed(
    user: felt252,
    amount: u256
) {
}

@event
func StakingProposalCreated(
    proposal_id: u64,
    proposer: felt252,
    title: felt252,
    required_stake: u256
) {
}

@event
func StakingVoteCast(
    proposal_id: u64,
    voter: felt252,
    vote: bool,
    stake: u256
) {
}

@event
func StakingProposalExecuted(
    proposal_id: u64,
    status: u8
) {
}

@external
func stake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(amount: u256, duration: u64) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Validate stake amount
    assert(amount >= MIN_STAKE_AMOUNT, 'Stake too low');
    assert(amount <= MAX_STAKE_AMOUNT, 'Stake too high');
    
    // Validate duration
    assert(duration >= MIN_STAKE_DURATION, 'Duration too short');
    assert(duration <= MAX_STAKE_DURATION, 'Duration too long');
    
    // Get existing stake
    let (existing_stake) = stakes.read(caller);
    assert(!existing_stake.is_active, 'Already staked');
    
    // Create new stake
    let new_stake = Stake(
        amount=amount,
        start_time=current_time,
        end_time=current_time + duration,
        last_claim_time=current_time,
        total_rewards=0,
        is_active=true
    );
    
    // Update staking pool
    let (pool) = staking_pool.read();
    pool.total_staked += amount;
    pool.last_update_time = current_time;
    staking_pool.write(pool);
    
    // Store stake
    stakes.write(caller, new_stake);
    
    // Emit event
    Staked.emit(caller, amount, duration);
}

@external
func unstake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get stake
    let (stake) = stakes.read(caller);
    assert(stake.is_active, 'No active stake');
    assert(current_time >= stake.end_time, 'Stake not matured');
    
    // Calculate rewards
    let rewards = calculateRewards(stake);
    
    // Update staking pool
    let (pool) = staking_pool.read();
    pool.total_staked -= stake.amount;
    pool.total_rewards -= rewards;
    staking_pool.write(pool);
    
    // Update stake
    stake.is_active = false;
    stake.total_rewards += rewards;
    stakes.write(caller, stake);
    
    // Emit event
    Unstaked.emit(caller, stake.amount, rewards);
}

@external
func claimRewards{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get stake
    let (stake) = stakes.read(caller);
    assert(stake.is_active, 'No active stake');
    
    // Calculate rewards
    let rewards = calculateRewards(stake);
    assert(rewards > 0, 'No rewards to claim');
    
    // Update stake
    stake.last_claim_time = current_time;
    stake.total_rewards += rewards;
    stakes.write(caller, stake);
    
    // Update staking pool
    let (pool) = staking_pool.read();
    pool.total_rewards -= rewards;
    staking_pool.write(pool);
    
    // Emit event
    RewardsClaimed.emit(caller, rewards);
}

@external
func createStakingProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(title: felt252, description: felt252, required_stake: u256) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check if user has enough stake
    let (stake) = stakes.read(caller);
    assert(stake.is_active, 'No active stake');
    assert(stake.amount >= GOVERNANCE_THRESHOLD, 'Insufficient stake for governance');
    
    // Get next proposal ID
    let (proposal_id) = next_proposal_id.read();
    next_proposal_id.write(proposal_id + 1);
    
    // Create proposal
    let proposal = StakingProposal(
        id=proposal_id,
        proposer=caller,
        title=title,
        description=description,
        start_time=current_time,
        end_time=current_time + 604800, // 7 days
        yes_votes=0,
        no_votes=0,
        required_stake=required_stake,
        status=0,
        executed=false
    );
    
    // Store proposal
    staking_proposals.write(proposal_id, proposal);
    
    // Emit event
    StakingProposalCreated.emit(proposal_id, caller, title, required_stake);
}

@external
func voteOnStakingProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(proposal_id: u64, vote: bool) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check if user has enough stake
    let (stake) = stakes.read(caller);
    assert(stake.is_active, 'No active stake');
    assert(stake.amount >= GOVERNANCE_THRESHOLD, 'Insufficient stake for governance');
    
    // Get proposal
    let (proposal) = staking_proposals.read(proposal_id);
    assert(proposal.start_time != 0, 'Proposal does not exist');
    assert(current_time < proposal.end_time, 'Voting period ended');
    assert(proposal.status == 0, 'Proposal not active');
    
    // Check if already voted
    let (has_voted, _) = staking_votes.read(proposal_id, caller);
    assert(!has_voted, 'Already voted');
    
    // Update proposal votes
    if vote {
        proposal.yes_votes += stake.amount;
    } else {
        proposal.no_votes += stake.amount;
    }
    
    // Store vote and update proposal
    staking_votes.write(proposal_id, caller, (true, vote));
    staking_proposals.write(proposal_id, proposal);
    
    // Emit event
    StakingVoteCast.emit(proposal_id, caller, vote, stake.amount);
}

@external
func executeStakingProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(proposal_id: u64) {
    let current_time = get_block_timestamp();
    
    // Get proposal
    let (proposal) = staking_proposals.read(proposal_id);
    assert(proposal.start_time != 0, 'Proposal does not exist');
    assert(current_time >= proposal.end_time, 'Voting period not ended');
    assert(!proposal.executed, 'Already executed');
    
    // Calculate result
    let total_votes = proposal.yes_votes + proposal.no_votes;
    let status: u8 = 0;
    
    if total_votes >= proposal.required_stake {
        if proposal.yes_votes > proposal.no_votes {
            status = 1; // Passed
        } else {
            status = 2; // Failed
        }
    } else {
        status = 2; // Failed due to insufficient votes
    }
    
    // Update proposal
    proposal.status = status;
    proposal.executed = true;
    staking_proposals.write(proposal_id, proposal);
    
    // Emit event
    StakingProposalExecuted.emit(proposal_id, status);
}

@view
func calculateRewards{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(stake: Stake) -> (rewards: u256) {
    let current_time = get_block_timestamp();
    let duration = current_time - stake.last_claim_time;
    let daily_reward = (stake.amount * REWARD_RATE) / 10000;
    let rewards = (daily_reward * duration) / 86400;
    return (rewards);
}

@view
func getStake{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252) -> (stake: Stake) {
    let (stake) = stakes.read(user);
    return (stake);
}

@view
func getStakingPool{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (pool: StakingPool) {
    let (pool) = staking_pool.read();
    return (pool);
}

@view
func getStakingProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(proposal_id: u64) -> (proposal: StakingProposal) {
    let (proposal) = staking_proposals.read(proposal_id);
    return (proposal);
} 