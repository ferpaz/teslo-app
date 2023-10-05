import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';


final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductNotifier(productId: productId, productsRepository: productsRepository);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final String productId;
  final ProductsRepositoryBase productsRepository;

  ProductNotifier({
    required this.productId,
    required this.productsRepository
  }): super(ProductState(id: productId)) {
    loadProduct();
  }

  Future<void> loadProduct() async {
    if (state.id == '')
    {
      state = state.copyWith(
        product: Product(
          id: state.id,
          title: '',
          description: '',
          price: 0,
          images: const <String>[],
          gender: '',
          sizes: const <String>[],
          slug: '',
          stock: 0,
          tags: const <String>[]
        ),
        errorMessage: ''
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final product = await productsRepository.getProduct(productId);
      state = state.copyWith(product: product, errorMessage: '');
    }
    on ProductNotExistsException catch (e) {
      state = state.copyWith(errorMessage: e.toString(), product: null);
    }
    on InvalidCredentialsException catch (e) {
      state = state.copyWith(errorMessage: e.toString(), product: null);
    }
    catch (e) {
      state = state.copyWith(errorMessage: e.toString(), product: null);
    }
    finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;
  final String errorMessage;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage = ''
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    errorMessage: errorMessage ?? this.errorMessage
  );
}