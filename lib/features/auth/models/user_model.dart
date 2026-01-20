import 'dart:convert';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final String? bio;
  final String? aboutMe;
  final String? workExperience;
  final String? coverImageUrl;
  final int followersCount;
  final int followingCount;
  final List<String>? followers;
  final List<String>? following;
  final int postsCount;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.coverImageUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.followers,
    this.following,
    this.postsCount = 0,
    this.aboutMe,
    this.workExperience,
  });

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
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      postsCount: postsCount ?? this.postsCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'image_url': profileImageUrl,
      'bio': bio,
      'cover_image_url': coverImageUrl,
      'followers_count': followersCount,
      'following_count': followingCount,
      'followers': followers,
      'following': following,
      'posts_count': postsCount,
      'about_me': aboutMe,
      'work_experience': workExperience,
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
      followersCount: map['followers_count'] != null
          ? map['followers_count'] as int
          : 0,
      followingCount: map['following_count'] != null
          ? map['following_count'] as int
          : 0,
      postsCount: map['posts_count'] != null ? map['posts_count'] as int : 0,
      followers: map['followers'] != null
          ? List<String>.from(map['followers'] as List<dynamic>)
          : null,
      following: map['following'] != null
          ? List<String>.from(map['following'] as List<dynamic>)
          : null,

      aboutMe: map['about_me'] != null ? map['about_me'] as String : null,
      workExperience: map['work_experience'] != null
          ? map['work_experience'] as String
          : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profileImageUrl: $profileImageUrl, bio: $bio, aboutMe: $aboutMe, workExperience: $workExperience, coverImageUrl: $coverImageUrl, followersCount: $followersCount, followingCount: $followingCount, followers: $followers, following: $following, postsCount: $postsCount)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.bio == bio &&
        other.aboutMe == aboutMe &&
        other.workExperience == workExperience &&
        other.coverImageUrl == coverImageUrl &&
        other.followersCount == followersCount &&
        other.followingCount == followingCount &&
        // List equality check
        (other.followers == followers ||
            (other.followers != null &&
                followers != null &&
                other.followers!.length == followers!.length &&
                other.followers!.every((element) => followers!.contains(element)))) &&
        (other.following == following ||
            (other.following != null &&
                following != null &&
                other.following!.length == following!.length &&
                other.following!.every((element) => following!.contains(element)))) &&
        other.postsCount == postsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profileImageUrl.hashCode ^
        bio.hashCode ^
        aboutMe.hashCode ^
        workExperience.hashCode ^
        coverImageUrl.hashCode ^
        followersCount.hashCode ^
        followingCount.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        postsCount.hashCode;
  }
}
