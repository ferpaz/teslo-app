class InvalidCredentialsException extends CustomException {
  InvalidCredentialsException({ String? message })
    : super(message: message ?? 'Credenciales inválidas');
}

class InvalidTokenException extends CustomException {
  InvalidTokenException({ String? message }) : super(message: message ?? 'Token inválido');
}

class CustomException implements Exception {
  final String message;

  CustomException({ String? message }) : message = message ?? 'Error desconocido';
}