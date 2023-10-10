import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';

import 'products_repository_provider.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productRepository: productRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepositoryBase productRepository;

  ProductsNotifier({
    required this.productRepository
  }) : super ( ProductsState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    _setLoading(true);

    try {
      final products = await productRepository.getProducts(
        limit: state.limit,
        offset: state.offset,
      );

      if (products.isEmpty) {
        state = state.copyWith(isLastPage: true);
      }
      else {
        state = state.copyWith(products: [...state.products, ...products], isLastPage: false, offset: state.offset + state.limit);
      }
    }
    on InvalidCredentialsException catch (e) {
      _setLoadNextPageErrorMessage(e.message);
    }
    catch (e) {
      _setLoadNextPageErrorMessage(e.toString());
    }
    finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void _setLoadNextPageErrorMessage(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage, products: const[], isLastPage: true, offset: 0);
  }

  Future<bool> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final updatedProduct = await productRepository.createUpdateProduct(productLike);
      final isProductInList = state.products.any((e) => e.id == updatedProduct.id);

      if (!isProductInList) {
        state = state.copyWith(products: [...state.products, updatedProduct], errorMessage: '');
      }
      else {
        final updatedProducts = state.products.map((e) => e.id == updatedProduct.id ? updatedProduct : e).toList();
        state = state.copyWith(products: updatedProducts, errorMessage: '');
      }

      return true;
    }
    on InvalidCredentialsException catch (e) {
      _setCreateUpdateProductErrorMessage(e.message);
      rethrow;
    }
    on ProductBadRequestException catch (e) {
      _setCreateUpdateProductErrorMessage(e.message);
      rethrow;
    }
    on ProductNotExistsException catch (e) {
      _setCreateUpdateProductErrorMessage(e.message);
      rethrow;
    }
    catch (e) {
      _setCreateUpdateProductErrorMessage(e.toString());
      rethrow;
    }
  }

  void _setCreateUpdateProductErrorMessage(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }
}

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;
  final String errorMessage;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.errorMessage = '',
    this.products = const[]
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    String? errorMessage,
    List<Product>? products,
  }) => ProductsState(
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
    );
}