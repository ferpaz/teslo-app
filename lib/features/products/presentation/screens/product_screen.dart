import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import 'product_view.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({ super.key, required this.productId });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${productId == '' ? 'Crear' : 'Editar'} Producto'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined)
          )],
      ),
      body: productState.isLoading
        ? const FullScreenLoader()
        : ProductView(product: productState.product!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_as_outlined),
      )
    );
  }
}
