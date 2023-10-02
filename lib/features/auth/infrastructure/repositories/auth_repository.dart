import 'package:teslo_shop/features/auth/domain/domain.dart';

import '../datasources/auth_datasource.dart';


class AuthRepository extends AuthRepositoryBase {
  final AuthDatasourceBase _authDatasource;

  AuthRepository({
    AuthDatasourceBase? authDatasource
  }) : _authDatasource = authDatasource ?? AuthDataSource();


  @override
  Future<User> checkAuthStatus(String token) => _authDatasource.checkAuthStatus(token);

  @override
  Future<User> login(String email, String password) => _authDatasource.login(email, password);

  @override
  Future<User> register(String email, String password, String fullName) => _authDatasource.register(email, password, fullName);
}