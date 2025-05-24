%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants
const MIN_STAKE_FOR_GOVERNANCE: u256 = 10000000000000000000; // 10 tokens
const VOTING_PERIOD: u64 = 604800; // 7 days
const MIN_PROPOSAL_STAKE: u256 = 1000000000000000000; // 1 token
const MAX_PROPOSAL_DURATION: u64 = 2592000; // 30 days
const CURATOR_THRESHOLD: u64 = 1000; // Reputation score needed to be curator

// Struct to store user profile data
struct UserProfile {
    username: felt252,
    bio: felt252,
    avatar: felt252,
    social_links: felt252,
    created_at: u64,
    last_updated: u64,
    is_verified: bool,
    verification_level: u8,
    total_curated: u64,
    curation_score: u64,
    governance_power: u256
}

// Struct to store content curation data
struct Curation {
    id: u64,
    curator: felt252,
    content_type: felt252,
    content_id: u64,
    rating: u8,
    comment: felt252,
    timestamp: u64,
    upvotes: u64,
    downvotes: u64,
    is_featured: bool
}

// Struct to store governance proposal
struct Proposal {
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

// Struct to store user vote
struct Vote {
    proposal_id: u64,
    voter: felt252,
    vote: bool, // true: yes, false: no
    stake: u256,
    timestamp: u64
}

// Storage variables
@storage_var
func user_profiles(user: felt252) -> (profile: UserProfile) {
}

@storage_var
func curations(curation_id: u64) -> (curation: Curation) {
}

@storage_var
func next_curation_id() -> (id: u64) {
}

@storage_var
func proposals(proposal_id: u64) -> (proposal: Proposal) {
}

@storage_var
func next_proposal_id() -> (id: u64) {
}

@storage_var
func votes(proposal_id: u64, voter: felt252) -> (vote: Vote) {
}

@storage_var
func user_stakes(user: felt252) -> (stake: u256) {
}

@storage_var
func featured_content(content_type: felt252, index: u64) -> (content_id: u64) {
}

@storage_var
func featured_count(content_type: felt252) -> (count: u64) {
}

@event
func ProfileUpdated(
    user: felt252,
    username: felt252,
    verification_level: u8
) {
}

@event
func ContentCurated(
    curation_id: u64,
    curator: felt252,
    content_type: felt252,
    content_id: u64,
    rating: u8
) {
}

@event
func ProposalCreated(
    proposal_id: u64,
    proposer: felt252,
    title: felt252,
    required_stake: u256
) {
}

@event
func VoteCast(
    proposal_id: u64,
    voter: felt252,
    vote: bool,
    stake: u256
) {
}

@event
func ProposalExecuted(
    proposal_id: u64,
    status: u8
) {
}

@external
func updateProfile{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    username: felt252,
    bio: felt252,
    avatar: felt252,
    social_links: felt252
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get profile
    let (profile) = user_profiles.read(caller);
    
    // Update profile
    profile.username = username;
    profile.bio = bio;
    profile.avatar = avatar;
    profile.social_links = social_links;
    profile.last_updated = current_time;
    
    user_profiles.write(caller, profile);
    
    // Emit event
    ProfileUpdated.emit(caller, username, profile.verification_level);
}

@external
func curateContent{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    content_type: felt252,
    content_id: u64,
    rating: u8,
    comment: felt252
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Check curator status
    let (profile) = user_profiles.read(caller);
    assert(profile.curation_score >= CURATOR_THRESHOLD, 'Not enough curation score');
    
    // Get next curation ID
    let (curation_id) = next_curation_id.read();
    next_curation_id.write(curation_id + 1);
    
    // Create curation
    let curation = Curation(
        id=curation_id,
        curator=caller,
        content_type=content_type,
        content_id=content_id,
        rating=rating,
        comment=comment,
        timestamp=current_time,
        upvotes=0,
        downvotes=0,
        is_featured=false
    );
    
    // Store curation
    curations.write(curation_id, curation);
    
    // Update curator stats
    profile.total_curated += 1;
    user_profiles.write(caller, profile);
    
    // Emit event
    ContentCurated.emit(curation_id, caller, content_type, content_id, rating);
}

@external
func createProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    title: felt252,
    description: felt252,
    required_stake: u256
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Validate stake
    assert(required_stake >= MIN_PROPOSAL_STAKE, 'Stake too low');
    
    // Get user stake
    let (stake) = user_stakes.read(caller);
    assert(stake >= required_stake, 'Insufficient stake');
    
    // Get next proposal ID
    let (proposal_id) = next_proposal_id.read();
    next_proposal_id.write(proposal_id + 1);
    
    // Create proposal
    let proposal = Proposal(
        id=proposal_id,
        proposer=caller,
        title=title,
        description=description,
        start_time=current_time,
        end_time=current_time + VOTING_PERIOD,
        yes_votes=0,
        no_votes=0,
        required_stake=required_stake,
        status=0,
        executed=false
    );
    
    // Store proposal
    proposals.write(proposal_id, proposal);
    
    // Emit event
    ProposalCreated.emit(proposal_id, caller, title, required_stake);
}

@external
func castVote{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    proposal_id: u64,
    vote: bool,
    stake: u256
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get proposal
    let (proposal) = proposals.read(proposal_id);
    assert(proposal.start_time != 0, 'Proposal does not exist');
    assert(current_time < proposal.end_time, 'Voting period ended');
    assert(proposal.status == 0, 'Proposal not active');
    
    // Get user stake
    let (user_stake) = user_stakes.read(caller);
    assert(stake <= user_stake, 'Insufficient stake');
    
    // Check if already voted
    let (existing_vote) = votes.read(proposal_id, caller);
    assert(existing_vote.timestamp == 0, 'Already voted');
    
    // Create vote
    let new_vote = Vote(
        proposal_id=proposal_id,
        voter=caller,
        vote=vote,
        stake=stake,
        timestamp=current_time
    );
    
    // Update proposal votes
    if vote {
        proposal.yes_votes += stake;
    } else {
        proposal.no_votes += stake;
    }
    
    // Store vote and update proposal
    votes.write(proposal_id, caller, new_vote);
    proposals.write(proposal_id, proposal);
    
    // Emit event
    VoteCast.emit(proposal_id, caller, vote, stake);
}

@external
func executeProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(proposal_id: u64) {
    let current_time = get_block_timestamp();
    
    // Get proposal
    let (proposal) = proposals.read(proposal_id);
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
    proposals.write(proposal_id, proposal);
    
    // Emit event
    ProposalExecuted.emit(proposal_id, status);
}

@view
func getUserProfile{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252) -> (profile: UserProfile) {
    let (profile) = user_profiles.read(user);
    return (profile);
}

@view
func getProposal{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(proposal_id: u64) -> (proposal: Proposal) {
    let (proposal) = proposals.read(proposal_id);
    return (proposal);
}

@view
func getVote{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(proposal_id: u64, voter: felt252) -> (vote: Vote) {
    let (vote) = votes.read(proposal_id, voter);
    return (vote);
}

@view
func getFeaturedContent{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(content_type: felt252, start: u64, count: u64) -> (content_ids: felt*) {
    let (total) = featured_count.read(content_type);
    assert(start + count <= total, 'Invalid range');
    
    let mut content_ids: felt* = alloc();
    let mut i: u64 = 0;
    loop:
        if i == count {
            return (content_ids);
        }
        let (content_id) = featured_content.read(content_type, start + i);
        assert(content_ids[i] = content_id);
        i += 1;
    end;
} 