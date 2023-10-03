import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepository extends ProductsRepositoryBase {
  final ProductsDatasourceBase _datasource;

  ProductsRepository(this._datasource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) => _datasource.createUpdateProduct(productLike);

  @override
  Future<Product> getProduct(String id) => _datasource.getProduct(id);

  @override
  Future<List<Product>> getProducts({int limit = 10, int offset = 0}) => _datasource.getProducts(limit: limit, offset: offset);

  @override
  Future<List<Product>> searchProducts(String term) => _datasource.searchProducts(term);
}