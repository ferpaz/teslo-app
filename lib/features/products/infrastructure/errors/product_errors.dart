import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class ProductNotExistsException extends CustomException {
  ProductNotExistsException({ String? message }) : super(message: message ?? 'El producto especificado no existe.');
}

class ProductBadRequestException extends CustomException {
  ProductBadRequestException({ String? message }) : super(message: message ?? 'Los datos del producto son inválidos.');
}