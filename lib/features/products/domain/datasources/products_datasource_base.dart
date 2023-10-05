import 'package:teslo_shop/features/products/domain/domain.dart';

abstract class ProductsDatasourceBase {
  Future<List<Product>> getProducts({ int limit = 10, int offset = 0 });

  Future<Product> getProduct(String id);

  Future<List<Product>> searchProducts(String term);

  Future<Product> createUpdateProduct ( Map<String, dynamic> productLike);
}