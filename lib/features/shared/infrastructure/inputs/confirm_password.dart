import 'package:teslo_shop/features/shared/infrastructure/inputs/password.dart';

class ConfirmPassword extends Password {
  final String passwordToCompare;

  // Call super.pure to represent an unmodified form input.
  const ConfirmPassword.pure()
    : passwordToCompare = '', super.pure();

  // Call super.dirty to represent a modified form input.
  const ConfirmPassword.dirty(String value, String otherPassword)
    : passwordToCompare = otherPassword, super.dirty(value);

  @override
  String? get errorMessage {
    var error = super.errorMessage;
    if (error != null) return error;

    if ( displayError == PasswordError.notMatch ) return 'Las contraseñas no coinciden';
    return null;
  }

  @override
  PasswordError? validator(String value) {
    final validator = super.validator(value);
    if ( validator != null ) return validator;

    if (value != passwordToCompare) return PasswordError.notMatch;

    return null;
  }
}
