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
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null || productId.trim() == '') ? 'POST' : 'PATCH';
      final String url = (productId == null || productId.trim() == '') ? '/products' : '/products/$productId';

      productLike.remove('id');

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method)
      );

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    }
    on DioException catch (e) {
      if (e.response?.statusCode == 400)  throw ProductBadRequestException(message: e.response?.data['message']);
      if (e.response?.statusCode == 403)  throw InvalidCredentialsException(message: e.response?.data['message']);
      if (e.response?.statusCode == 404)  throw ProductNotExistsException(message: e.response?.data['message']);

      throw CustomException(message: e.response?.statusMessage ?? e.message ?? 'Error desconocido');

    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    try {
      final response = await dio.get('/products/$id');

      final product = ProductMapper.jsonToEntity(response.data);
      return product;

    } on DioException catch (e) {
      if (e.response?.statusCode == 404)  throw ProductNotExistsException(message: e.response?.data['message']);

      throw CustomException(message: e.response?.statusMessage ?? e.message ?? 'Error desconocido');

    } catch (e) {
      throw CustomException(message: e.toString());
    }
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
      products.sort((a, b) => -1 * a.price.compareTo(b.price));

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
