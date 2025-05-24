%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Constants
const MIN_REPUTATION_FOR_VERIFICATION: u64 = 1000;
const REPUTATION_PER_CORRECT_PREDICTION: u64 = 10;
const REPUTATION_PER_UPVOTE: u64 = 1;
const REPUTATION_PER_COMMENT: u64 = 2;
const MAX_COMMENT_LENGTH: u64 = 500;
const MAX_REPORTS_BEFORE_HIDDEN: u64 = 5;

// Struct to store comment data
struct Comment {
    id: u64,
    market_id: u64,
    user: felt252,
    text: felt252,
    timestamp: u64,
    likes: u64,
    is_hidden: bool,
    report_count: u64,
    parent_comment_id: u64,
    is_edited: bool,
    last_edit_time: u64
}

// Struct to store user reputation
struct UserReputation {
    score: u64,
    level: u8,
    badges: u64,
    total_upvotes: u64,
    total_comments: u64,
    total_predictions: u64,
    correct_predictions: u64,
    last_updated: u64
}

// Struct to store user achievements
struct Achievement {
    id: u64,
    name: felt252,
    description: felt252,
    reward: u256,
    is_claimed: bool
}

// Storage variables
@storage_var
func comments(market_id: u64, comment_id: u64) -> (comment: Comment) {
}

@storage_var
func next_comment_id(market_id: u64) -> (id: u64) {
}

@storage_var
func user_likes(market_id: u64, comment_id: u64, user: felt252) -> (liked: bool) {
}

@storage_var
func user_reputation(user: felt252) -> (reputation: UserReputation) {
}

@storage_var
func user_achievements(user: felt252, achievement_id: u64) -> (achievement: Achievement) {
}

@storage_var
func next_achievement_id() -> (id: u64) {
}

@storage_var
func user_followers(user: felt252, follower_index: u64) -> (follower: felt252) {
}

@storage_var
func follower_count(user: felt252) -> (count: u64) {
}

@storage_var
func user_following(user: felt252, following_index: u64) -> (following: felt252) {
}

@storage_var
func following_count(user: felt252) -> (count: u64) {
}

@event
func CommentAdded(
    market_id: u64,
    comment_id: u64,
    user: felt252,
    text: felt252,
    parent_comment_id: u64
) {
}

@event
func CommentEdited(
    market_id: u64,
    comment_id: u64,
    user: felt252,
    new_text: felt252
) {
}

@event
func CommentDeleted(
    market_id: u64,
    comment_id: u64
) {
}

@event
func CommentLiked(
    market_id: u64,
    comment_id: u64,
    user: felt252
) {
}

@event
func CommentUnliked(
    market_id: u64,
    comment_id: u64,
    user: felt252
) {
}

@event
func CommentReported(
    market_id: u64,
    comment_id: u64,
    reporter: felt252,
    reason: felt252
) {
}

@event
func ReputationUpdated(
    user: felt252,
    new_score: u64,
    new_level: u8
) {
}

@event
func AchievementUnlocked(
    user: felt252,
    achievement_id: u64,
    name: felt252,
    reward: u256
) {
}

@event
func UserFollowed(
    follower: felt252,
    following: felt252
) {
}

@event
func UserUnfollowed(
    follower: felt252,
    following: felt252
) {
}

@external
func addComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    text: felt252,
    parent_comment_id: u64
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get next comment ID
    let (comment_id) = next_comment_id.read(market_id);
    next_comment_id.write(market_id, comment_id + 1);
    
    // Create new comment
    let new_comment = Comment(
        id=comment_id,
        market_id=market_id,
        user=caller,
        text=text,
        timestamp=current_time,
        likes=0,
        is_hidden=false,
        report_count=0,
        parent_comment_id=parent_comment_id,
        is_edited=false,
        last_edit_time=current_time
    );
    
    // Store comment
    comments.write(market_id, comment_id, new_comment);
    
    // Update user reputation
    let (reputation) = user_reputation.read(caller);
    reputation.total_comments += 1;
    reputation.score += REPUTATION_PER_COMMENT;
    reputation.last_updated = current_time;
    user_reputation.write(caller, reputation);
    
    // Emit event
    CommentAdded.emit(market_id, comment_id, caller, text, parent_comment_id);
}

@external
func editComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    comment_id: u64,
    new_text: felt252
) {
    let caller = get_caller_address();
    let current_time = get_block_timestamp();
    
    // Get comment
    let (comment) = comments.read(market_id, comment_id);
    assert(comment.timestamp != 0, 'Comment does not exist');
    assert(caller == comment.user, 'Only comment author can edit');
    assert(!comment.is_hidden, 'Comment is hidden');
    
    // Update comment
    comment.text = new_text;
    comment.is_edited = true;
    comment.last_edit_time = current_time;
    comments.write(market_id, comment_id, comment);
    
    // Emit event
    CommentEdited.emit(market_id, comment_id, caller, new_text);
}

@external
func reportComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    comment_id: u64,
    reason: felt252
) {
    let caller = get_caller_address();
    
    // Get comment
    let (comment) = comments.read(market_id, comment_id);
    assert(comment.timestamp != 0, 'Comment does not exist');
    assert(!comment.is_hidden, 'Comment is already hidden');
    
    // Update report count
    comment.report_count += 1;
    if comment.report_count >= MAX_REPORTS_BEFORE_HIDDEN {
        comment.is_hidden = true;
    }
    comments.write(market_id, comment_id, comment);
    
    // Emit event
    CommentReported.emit(market_id, comment_id, caller, reason);
}

@external
func followUser{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user_to_follow: felt252) {
    let caller = get_caller_address();
    assert(caller != user_to_follow, 'Cannot follow yourself');
    
    // Get current counts
    let (follower_count) = follower_count.read(user_to_follow);
    let (following_count) = following_count.read(caller);
    
    // Add follower
    user_followers.write(user_to_follow, follower_count, caller);
    follower_count.write(user_to_follow, follower_count + 1);
    
    // Add following
    user_following.write(caller, following_count, user_to_follow);
    following_count.write(caller, following_count + 1);
    
    // Emit event
    UserFollowed.emit(caller, user_to_follow);
}

@external
func unfollowUser{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user_to_unfollow: felt252) {
    let caller = get_caller_address();
    
    // Get current counts
    let (follower_count) = follower_count.read(user_to_unfollow);
    let (following_count) = following_count.read(caller);
    
    // Remove follower
    user_followers.write(user_to_unfollow, follower_count - 1, 0);
    follower_count.write(user_to_unfollow, follower_count - 1);
    
    // Remove following
    user_following.write(caller, following_count - 1, 0);
    following_count.write(caller, following_count - 1);
    
    // Emit event
    UserUnfollowed.emit(caller, user_to_unfollow);
}

@external
func updateReputation{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    user: felt252,
    correct_prediction: bool
) {
    let current_time = get_block_timestamp();
    
    // Get reputation
    let (reputation) = user_reputation.read(user);
    
    // Update stats
    reputation.total_predictions += 1;
    if correct_prediction {
        reputation.correct_predictions += 1;
        reputation.score += REPUTATION_PER_CORRECT_PREDICTION;
    }
    
    // Update level
    let new_level = reputation.score / 1000;
    if new_level > reputation.level {
        reputation.level = new_level;
        // Check for achievements
        checkAchievements(user, new_level);
    }
    
    reputation.last_updated = current_time;
    user_reputation.write(user, reputation);
    
    // Emit event
    ReputationUpdated.emit(user, reputation.score, reputation.level);
}

@internal
func checkAchievements{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252, level: u8) {
    let (achievement_id) = next_achievement_id.read();
    
    // Create new achievement if level milestone reached
    if level == 5 {
        let achievement = Achievement(
            id=achievement_id,
            name='Rising Star',
            description='Reached level 5',
            reward=1000000000000000000, // 1 token
            is_claimed=false
        );
        user_achievements.write(user, achievement_id, achievement);
        next_achievement_id.write(achievement_id + 1);
        AchievementUnlocked.emit(user, achievement_id, 'Rising Star', 1000000000000000000);
    }
}

@view
func getComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(market_id: u64, comment_id: u64) -> (comment: Comment) {
    let (comment) = comments.read(market_id, comment_id);
    return (comment);
}

@view
func getUserReputation{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252) -> (reputation: UserReputation) {
    let (reputation) = user_reputation.read(user);
    return (reputation);
}

@view
func getUserAchievements{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252, start: u64, count: u64) -> (achievements: felt*) {
    let mut achievements: felt* = alloc();
    let mut i: u64 = 0;
    loop:
        if i == count {
            return (achievements);
        }
        let (achievement) = user_achievements.read(user, start + i);
        assert(achievements[i] = achievement.id);
        i += 1;
    end;
}

@view
func getFollowers{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252, start: u64, count: u64) -> (followers: felt*) {
    let (total) = follower_count.read(user);
    assert(start + count <= total, 'Invalid range');
    
    let mut followers: felt* = alloc();
    let mut i: u64 = 0;
    loop:
        if i == count {
            return (followers);
        }
        let (follower) = user_followers.read(user, start + i);
        assert(followers[i] = follower);
        i += 1;
    end;
}

@view
func getFollowing{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user: felt252, start: u64, count: u64) -> (following: felt*) {
    let (total) = following_count.read(user);
    assert(start + count <= total, 'Invalid range');
    
    let mut following: felt* = alloc();
    let mut i: u64 = 0;
    loop:
        if i == count {
            return (following);
        }
        let (followed) = user_following.read(user, start + i);
        assert(following[i] = followed);
        i += 1;
    end;
} 