class UserModel {
  final String? id;
  final String? name;
  final String? email;

  const UserModel({required this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'email': email};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }
}
