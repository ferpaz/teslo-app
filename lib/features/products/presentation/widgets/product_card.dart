import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key,  required this.product });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: Colors.white,
      child: Column(
        children: [
          if (product.images.isEmpty)
            Image.asset('assets/images/no-image.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),

          if (product.images.isNotEmpty)
            FadeInImage(
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              image: NetworkImage(product.images.first)),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$${product.price}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}