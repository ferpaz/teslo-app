import '../../domain/entities/user.dart';

class UserMapper
{
  static User jsonToEntity(Map<String, dynamic> json) =>
    User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      token: json['token'],
      isActive: json['isActive'],
      roles: List<String>.from(json['roles'].map((role) => role)),
    );
}