import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/shared/widgets/widgets.dart';


class ProductView extends ConsumerWidget {

  final Product product;

  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productForm = ref.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [

          SizedBox(
            height: 300,
            width: 600,
            child: _ImageGallery(images: productForm.images ),
          ),

          const SizedBox( height: 10 ),
          Center(child: Text( productForm.title.value, style: textStyles.titleSmall, textAlign: TextAlign.center, )),
          const SizedBox( height: 10 ),
          _ProductInformation( product: product ),

        ],
    );
  }
}


class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    final productForm = ref.watch(productFormProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15 ),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged: ref.read(productFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged: ref.read(productFormProvider(product).notifier).onSlugChanged,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product).notifier).onPriceChanged(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),

          const SizedBox(height: 15 ),
          const Text('Extras'),

          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSelectionChanged: ref.read(productFormProvider(product).notifier).onSizesChanged,
          ),
          const SizedBox(height: 5 ),
          _GenderSelector(
            selectedGender: productForm.gender,
            onSelectionChanged: ref.read(productFormProvider(product).notifier).onGenderChanged,
          ),


          const SizedBox(height: 15 ),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.stock.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product).notifier).onStockChanged(int.tryParse(value) ?? -1),
            errorMessage: productForm.stock.errorMessage,
          ),

          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: ref.read(productFormProvider(product).notifier).onDescriptionChanged,
          ),

          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.tags,
            onChanged: ref.read(productFormProvider(product).notifier).onTagsChanged,
          ),


          const SizedBox(height: 100 ),
        ],
      ),
    );
  }
}


class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const['XS','S','M','L','XL','XXL','XXXL'];
  final Function(List<String> selectedsizes) onSelectionChanged;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      multiSelectionEnabled: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
          value: size,
          label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(),
      selected: selectedSizes.isNotEmpty ? Set<String>.from( selectedSizes ) : <String>{},
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSelectionChanged(List.of(newSelection));
      },
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const['men','women','kid'];
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  final Function(String selectedGender) onSelectionChanged;

  const _GenderSelector({
    required this.selectedGender,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact ),
        segments: genders.map((gender) {
          return ButtonSegment(
            icon: Icon( genderIcons[ genders.indexOf(gender) ] ),
            value: gender,
            label: Text(gender, style: const TextStyle(fontSize: 12))
          );
        }).toList(),
        selected: { selectedGender },
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          if (newSelection.isEmpty) return;
          onSelectionChanged(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    if (images.isEmpty) {
      return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover ));
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(
        viewportFraction: 0.7
      ),
      children: images.map((imagePath) {
          late ImageProvider imageProvider;

          if (imagePath.toLowerCase().startsWith('http')) {
            imageProvider = NetworkImage(imagePath);
          } else {
            imageProvider = FileImage( File(imagePath) );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage(
                placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
      }).toList(),
    );
  }
}