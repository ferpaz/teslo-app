import 'package:formz/formz.dart';

enum FullNameError { empty, format, maxLenghtOverflow }

class FullName extends FormzInput<String, FullNameError> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if (displayError == FullNameError.empty) return 'El campo es requerido';
    if (displayError == FullNameError.format) return 'El nombre debe tener al menos 2 palabras';
    if (displayError == FullNameError.maxLenghtOverflow) return 'El nombre no soporta más de 100 caracteres de largo';

    return null;
  }
  @override
  FullNameError? validator(String value) {

    if (value.isEmpty || value.trim().isEmpty) return FullNameError.empty;
    if (value.split(' ').length < 2) return FullNameError.format;
    if (value.length > 100) return FullNameError.maxLenghtOverflow;

    return null;
  }
}