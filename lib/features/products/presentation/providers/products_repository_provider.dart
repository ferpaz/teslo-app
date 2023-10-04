import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

final productsRepositoryProvider = Provider<ProductsRepositoryBase>((ref) {
  final token = ref.watch(authProvider).user?.token ?? '';
  final datasource = ProductsDatasource(accessToken: token);
  return ProductsRepository(datasource);
});