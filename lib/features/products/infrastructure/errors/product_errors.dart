import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class ProductNotExistsException extends CustomException {
  ProductNotExistsException({ String? message }) : super(message: message ?? 'El producto especificado no existe.');
}