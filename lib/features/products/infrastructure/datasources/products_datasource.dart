import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

class ProductsDatasource extends ProductsDatasourceBase {
  final String accessToken;

  late final Dio dio;

  ProductsDatasource({required this.accessToken})
      : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            }
          )
        );

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProduct(String id) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProducts({int limit = 10, int offset = 0}) async {
    try {
      final response = await dio.get<List>('/products',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        }
      );

      if (response.data == null) return [];

      final products = response.data!.map((p) => ProductMapper.jsonToEntity(p)).toList();
      return products;

    } on DioException catch (e) {
      if (e.response?.statusCode == 401)  throw InvalidCredentialsException(message: e.response?.data['message']);

      throw CustomException(message: e.response?.statusMessage ?? e.message ?? 'Error desconocido');

    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<List<Product>> searchProducts(String term) {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }
}
