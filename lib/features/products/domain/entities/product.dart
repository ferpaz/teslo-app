import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final double price;
  final String description;
  final String slug;
  final int stock;
  final String gender;
  final List<String> sizes;
  final List<String> tags;
  final List<String> images;
  final User? user;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
    this.user,
  });

  @override
  List<Object?> get props => [id, title, price, description, slug, stock, sizes, gender, tags, images, user];
}
