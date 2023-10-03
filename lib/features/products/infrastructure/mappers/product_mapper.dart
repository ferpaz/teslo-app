import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductMapper {
  static Product jsonToEntity(Map<String, dynamic> json)
    => Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      slug: json['slug'],
      stock: int.parse(json['stock'].toString()),
      sizes: List<String>.from(json['sizes'].map((s) => s)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((t) => t)),
      images: List<String>.from(
        json['images'].map((image) => image.startsWith('http') ? image : '${Environment.apiUrl}/files/product/$image')
      ),
      user: json['user'] != null ? UserMapper.jsonToEntity(json['user']) : null,
    )  ;
}