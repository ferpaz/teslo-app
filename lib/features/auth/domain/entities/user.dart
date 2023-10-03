import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String id;
  final String email;
  final String fullName;
  final String token;
  final bool isActive;
  final List<String> roles;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.token,
    required this.isActive,
    required this.roles
  });

  bool get isAdmin => roles.contains('admin');

  @override
  List<Object?> get props => [id, email, fullName, token, isActive, roles];
}