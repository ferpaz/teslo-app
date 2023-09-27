
import '../entities/user.dart';

abstract class AuthDatasourceBase {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<User> checkAuthStatus();
}