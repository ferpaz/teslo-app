import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

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
        setLastPage(true);
      }
      else {
        _setProducts([...state.products, ...products]);
      }
    }
    on InvalidCredentialsException catch (e) {
      _setErrorMessage(e.message);
    }
    catch (e) {
      _setErrorMessage(e.toString());
    }
    finally {
      _setLoading(false);
    }
  }

  void setOffset(int offset) {
    state = state.copyWith(offset: offset);
  }

  void setLimit(int limit) {
    state = state.copyWith(limit: limit);
  }

  void setLastPage(bool isLastPage) {
    state = state.copyWith(isLastPage: isLastPage);
  }

  void _setProducts(List<Product> products) {
    state = state.copyWith(products: products, isLastPage: false, offset: state.offset + state.limit);
  }

  void _setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void _setErrorMessage(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage, products: const[], isLastPage: true, offset: 0);
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