%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Struct to store comment data
struct Comment {
    id: u64,
    market_id: u64,
    user: felt252,
    text: felt252,
    timestamp: u64,
    likes: u64
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

@event
func CommentAdded(
    market_id: u64,
    comment_id: u64,
    user: felt252,
    text: felt252
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

@external
func addComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    text: felt252
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
        likes=0
    );
    
    // Store comment
    comments.write(market_id, comment_id, new_comment);
    
    // Emit event
    CommentAdded.emit(market_id, comment_id, caller, text);
}

@external
func deleteComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    comment_id: u64
) {
    let caller = get_caller_address();
    
    // Get comment
    let (comment) = comments.read(market_id, comment_id);
    assert(comment.timestamp != 0, 'Comment does not exist');
    assert(caller == comment.user, 'Only comment author can delete');
    
    // Delete comment
    comments.write(market_id, comment_id, Comment(0, 0, 0, 0, 0, 0));
    
    // Emit event
    CommentDeleted.emit(market_id, comment_id);
}

@external
func likeComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    comment_id: u64
) {
    let caller = get_caller_address();
    
    // Get comment
    let (comment) = comments.read(market_id, comment_id);
    assert(comment.timestamp != 0, 'Comment does not exist');
    
    // Check if already liked
    let (already_liked) = user_likes.read(market_id, comment_id, caller);
    assert(!already_liked, 'Comment already liked');
    
    // Update likes
    comment.likes += 1;
    comments.write(market_id, comment_id, comment);
    user_likes.write(market_id, comment_id, caller, true);
    
    // Emit event
    CommentLiked.emit(market_id, comment_id, caller);
}

@external
func unlikeComment{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(
    market_id: u64,
    comment_id: u64
) {
    let caller = get_caller_address();
    
    // Get comment
    let (comment) = comments.read(market_id, comment_id);
    assert(comment.timestamp != 0, 'Comment does not exist');
    
    // Check if liked
    let (already_liked) = user_likes.read(market_id, comment_id, caller);
    assert(already_liked, 'Comment not liked');
    
    // Update likes
    comment.likes -= 1;
    comments.write(market_id, comment_id, comment);
    user_likes.write(market_id, comment_id, caller, false);
    
    // Emit event
    CommentUnliked.emit(market_id, comment_id, caller);
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
func hasLiked{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(market_id: u64, comment_id: u64, user: felt252) -> (liked: bool) {
    let (liked) = user_likes.read(market_id, comment_id, user);
    return (liked);
} 