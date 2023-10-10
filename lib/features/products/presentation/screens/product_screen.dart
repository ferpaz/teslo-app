import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import 'product_view.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({ super.key, required this.productId });

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto guardado correctamente'),
        backgroundColor: Colors.green,
      )
    );
  }

  void showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productState = ref.watch(productProvider(productId));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${productId == '' ? 'Crear' : 'Editar'} Producto'),
          actions: [
            IconButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final photoPath = await ImagePickerCameraGalleryService().selectPhoto();
                if (photoPath == null) return;

                ref.read(productFormProvider(productState.product!).notifier).addProductImage(photoPath);
              },
              icon: const Icon(Icons.photo_library_outlined)
            ),
            IconButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final photoPath = await ImagePickerCameraGalleryService().takePhoto();
                if (photoPath == null) return;

                ref.read(productFormProvider(productState.product!).notifier).addProductImage(photoPath);
              },
              icon: const Icon(Icons.camera_alt_outlined)
            ),
          ],
        ),
        body: productState.isLoading
          ? const FullScreenLoader()
          : ProductView(product: productState.product!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();

            if (productState.product == null) return;

            ref.read(productFormProvider(productState.product!).notifier)
              .onFormSubmit()
              .then((value) {
                if (value) {
                  showSnackbar(context);
                }
                else {
                  showErrorSnackbar(context, ref.read(productFormProvider(productState.product!)).errorMessage);
                }
              });
          },
          child: const Icon(Icons.save_as_outlined),
        )
      ),
    );
  }
}
