import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSource extends AuthDatasourceBase {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    )
  );


  @override
  Future<User> checkAuthStatus() {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.jsonToEntity(response.data);
      return user;

    } on DioException catch (e) {
      if (e.response?.statusCode == 401)  throw InvalidCredentialsException(message: e.response?.data['message']);

      throw CustomException(message: e.response?.statusMessage ?? e.message ?? 'Error desconocido');

    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}