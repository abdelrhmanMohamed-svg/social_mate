// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final String? bio;
  final String? aboutMe;
  final String? workExperience;
  final String? coverImageUrl;
  final String? fcmToken;

  final List<String>? followers;
  final List<String>? following;
  final int postsCount;
  final List<String>? followWating;
  final List<String>? followRequests;
  final bool isFollowWaiting;
  final bool isFollow;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.coverImageUrl,
    this.fcmToken,

    this.followers,
    this.following,
    this.postsCount = 0,
    this.aboutMe,
    this.workExperience,
    this.followWating,
    this.followRequests,
    this.isFollowWaiting = false,
    this.isFollow = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'image_url': profileImageUrl,
      'bio': bio,
      'cover_image_url': coverImageUrl,
      'fcm_token': fcmToken,

      'followers': followers,
      'following': following,
      'posts_count': postsCount,
      'about_me': aboutMe,
      'work_experience': workExperience,
      'follow_waiting': followWating,
      'follow_requests': followRequests,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      profileImageUrl: map['image_url'] != null
          ? map['image_url'] as String
          : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      coverImageUrl: map['cover_image_url'] != null
          ? map['cover_image_url'] as String
          : null,

      postsCount: map['posts_count'] != null ? map['posts_count'] as int : 0,
      followers: map['followers'] != null
          ? (map['followers'] is List
                ? List<String>.from(map['followers'] as List<dynamic>)
                : (map['followers'] is String
                      ? (map['followers'] as String).isEmpty
                            ? null
                            : [map['followers'] as String]
                      : null))
          : null,
      following: map['following'] != null
          ? (map['following'] is List
                ? List<String>.from(map['following'] as List<dynamic>)
                : (map['following'] is String
                      ? (map['following'] as String).isEmpty
                            ? null
                            : [map['following'] as String]
                      : null))
          : null,

      aboutMe: map['about_me'] != null ? map['about_me'] as String : null,
      workExperience: map['work_experience'] != null
          ? map['work_experience'] as String
          : null,
      followWating: map['follow_waiting'] != null
          ? (map['follow_waiting'] is List
                ? List<String>.from(map['follow_waiting'] as List<dynamic>)
                : (map['follow_waiting'] is String
                      ? (map['follow_waiting'] as String).isEmpty
                            ? null
                            : [map['follow_waiting'] as String]
                      : null))
          : null,

      fcmToken: map['fcm_token'] != null ? map['fcm_token'] as String : null,
      followRequests: map['follow_requests'] != null
          ? (map['follow_requests'] is List
                ? List<String>.from(map['follow_requests'] as List<dynamic>)
                : (map['follow_requests'] is String
                      ? (map['follow_requests'] as String).isEmpty
                            ? null
                            : [map['follow_requests'] as String]
                      : null))
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? bio,
    String? aboutMe,
    String? workExperience,
    String? coverImageUrl,
    int? followersCount,
    int? followingCount,
    List<String>? followers,
    List<String>? following,
    int? postsCount,
    List<String>? followWating,
    List<String>? followRequests,
    bool? isFollow,
    bool? isFollowWaiting,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      aboutMe: aboutMe ?? this.aboutMe,
      workExperience: workExperience ?? this.workExperience,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,

      followers: followers ?? this.followers,
      following: following ?? this.following,
      postsCount: postsCount ?? this.postsCount,
      followWating: followWating ?? this.followWating,
      followRequests: followRequests ?? this.followRequests,
      isFollowWaiting: isFollowWaiting ?? this.isFollowWaiting,
      isFollow: isFollow ?? this.isFollow,
    );
  }
}
