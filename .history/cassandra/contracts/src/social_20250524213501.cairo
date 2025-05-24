use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_block_timestamp;
use starknet::storage::StorageMap;
use starknet::storage::StorageMapAccess;
use starknet::storage::StorageMapReadAccess;
use starknet::storage::StorageMapWriteAccess;

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct Comment {
    author: ContractAddress,
    content: felt252,
    timestamp: u64,
    likes: u32,
    market_id: u32
}

#[derive(Drop, starknet::Store, starknet::Serde, starknet::Copy)]
struct UserProfile {
    username: felt252,
    bio: felt252,
    reputation: u32,
    joined_at: u64
}

#[starknet::interface]
trait ISocial<TContractState> {
    fn add_comment(ref self: TContractState, market_id: u32, content: felt252);
    fn like_comment(ref self: TContractState, comment_id: u32);
    fn update_profile(ref self: TContractState, username: felt252, bio: felt252);
    fn get_comment(self: @TContractState, comment_id: u32) -> Comment;
    fn get_user_profile(self: @TContractState, user: ContractAddress) -> UserProfile;
}

#[starknet::contract]
mod Social {
    use super::{Comment, UserProfile, ContractAddress};
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::storage::StorageMap;
    use starknet::storage::StorageMapAccess;
    use starknet::storage::StorageMapReadAccess;
    use starknet::storage::StorageMapWriteAccess;

    #[storage]
    struct Storage {
        comments: StorageMap::<u32, Comment>,
        user_profiles: StorageMap::<ContractAddress, UserProfile>,
        comment_count: u32,
        user_likes: StorageMap::<(ContractAddress, u32), bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CommentAdded: CommentAdded,
        CommentLiked: CommentLiked,
        ProfileUpdated: ProfileUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct CommentAdded {
        author: ContractAddress,
        market_id: u32,
        comment_id: u32,
        content: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct CommentLiked {
        user: ContractAddress,
        comment_id: u32,
    }

    #[derive(Drop, starknet::Event)]
    struct ProfileUpdated {
        user: ContractAddress,
        username: felt252,
        bio: felt252,
    }

    #[abi(embed_v0)]
    impl SocialImpl of super::ISocial<ContractState> {
        fn add_comment(ref self: ContractState, market_id: u32, content: felt252) {
            let caller = get_caller_address();
            let comment_id = self.comment_count.read();
            
            let comment = Comment {
                author: caller,
                content,
                timestamp: get_block_timestamp(),
                likes: 0,
                market_id
            };

            self.comments.write(comment_id, comment);
            self.comment_count.write(comment_id + 1);

            self.emit(CommentAdded {
                author: caller,
                market_id,
                comment_id,
                content
            });
        }

        fn like_comment(ref self: ContractState, comment_id: u32) {
            let caller = get_caller_address();
            let mut comment = self.comments.read(comment_id);
            
            // Check if user hasn't already liked this comment
            let has_liked = self.user_likes.read((caller, comment_id));
            assert(!has_liked, 'Already liked this comment');

            comment.likes += 1;
            self.comments.write(comment_id, comment);
            self.user_likes.write((caller, comment_id), true);

            self.emit(CommentLiked {
                user: caller,
                comment_id
            });
        }

        fn update_profile(ref self: ContractState, username: felt252, bio: felt252) {
            let caller = get_caller_address();
            let mut profile = self.user_profiles.read(caller);
            
            profile.username = username;
            profile.bio = bio;
            self.user_profiles.write(caller, profile);

            self.emit(ProfileUpdated {
                user: caller,
                username,
                bio
            });
        }

        fn get_comment(self: @ContractState, comment_id: u32) -> Comment {
            self.comments.read(comment_id)
        }

        fn get_user_profile(self: @ContractState, user: ContractAddress) -> UserProfile {
            self.user_profiles.read(user)
        }
    }
} 