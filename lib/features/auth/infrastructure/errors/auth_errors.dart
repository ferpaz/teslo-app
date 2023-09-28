class InvalidCredentialsException extends CustomException {
  InvalidCredentialsException({ String? message }) : super(message: message ?? 'Credenciales inválidas');
}

class InvalidTokenException extends CustomException {
  InvalidTokenException({ String? message }) : super(message: message ?? 'Token inválido');
}

class EmailAlreadyInUseException extends CustomException {
  EmailAlreadyInUseException({ String? message }) : super(message: message ?? 'El email especificado ya está en uso para otra cuenta.');
}
class CustomException implements Exception {
  final String message;

  CustomException({ String? message }) : message = message ?? 'Error desconocido';
}