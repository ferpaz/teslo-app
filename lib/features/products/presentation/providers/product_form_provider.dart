import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  // create on submit callback
  return ProductFormNotifier(
    product: product,
    //onSubmitCallback:
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    Product? product,
  }) : super(ProductFormState(
    id: product?.id,
    title: Title.dirty(product?.title ?? ''),
    slug: Slug.dirty(product?.slug ?? ''),
    price: Price.dirty(product?.price ?? 0),
    sizes: product == null ? [] : product.sizes,
    gender: product?.gender ?? '',
    stock: Stock.dirty(product?.stock ?? 0),
    description: product?.description ?? '',
    tags: product == null ? '': product.tags.join(', '),
    images: product == null ? [] : product.images,
  ));

  void onTitleChanged(String value) {
    final title = Title.dirty(value);
    state = state.copyWith(
      title: title,
      isFormValid: Formz.validate([title, Slug.dirty(state.slug.value), Price.dirty(state.price.value), Stock.dirty(state.stock.value)]),
    );
  }

  void onSlugChanged(String value) {
    final slug = Slug.dirty(value);
    state = state.copyWith(
      slug: slug,
      isFormValid: Formz.validate([Title.dirty(state.title.value), slug, Price.dirty(state.price.value), Stock.dirty(state.stock.value)]),
    );
  }

  void onPriceChanged(double value) {
    final price = Price.dirty(value);
    state = state.copyWith(
      price: price,
      isFormValid: Formz.validate([Title.dirty(state.title.value), Slug.dirty(state.slug.value), price, Stock.dirty(state.stock.value)]),
    );
  }

  void onStockChanged(int value) {
    final stock = Stock.dirty(value);
    state = state.copyWith(
      stock: stock,
      isFormValid: Formz.validate([Title.dirty(state.title.value), Slug.dirty(state.slug.value), Price.dirty(state.price.value), stock]),
    );
  }

  void onSizesChanged( List<String> values ) {
    state = state.copyWith(sizes: values);
  }

  void onGenderChanged(String value) {
    state = state.copyWith(gender: value);
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(description: value);
  }

  void onTagsChanged(String value) {
    state = state.copyWith(tags: value);
  }

  void onImagesChanged(List<String> values) {
    state = state.copyWith(images: values);
  }

  Future<bool> onFormSubmit() async {
    _touchedEverything();

    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.stock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(',').map((e) => e.trim()).toList(),
      'images': state.images.map(
        (i) => i.replaceAll('${ Environment.apiUrl }/files/product/', '')
      ).toList(),
    };

    return true;
  }

  void _touchedEverything() {
    state = state.copyWith(
      title: Title.dirty(state.title.value),
      slug: Slug.dirty(state.slug.value),
      price: Price.dirty(state.price.value),
      stock: Stock.dirty(state.stock.value),
      isFormValid: Formz.validate([Title.dirty(state.title.value), Slug.dirty(state.slug.value), Price.dirty(state.price.value), Stock.dirty(state.stock.value)]),
    );
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.pure(),
    this.slug = const Slug.pure(),
    this.price = const Price.pure(),
    this.sizes = const [],
    this.gender = '',
    this.stock = const Stock.pure(),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    stock: stock ?? this.stock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );
}