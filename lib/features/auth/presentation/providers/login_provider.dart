import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';


// El proveedor de estado
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});


// El notificador
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier(): super( const LoginFormState());

  onEmailChanged(String email) {
    var newEmail = Email.dirty(email);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }

  onPasswordChanged(String password) {
    var newPassword = Password.dirty(password);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.email, newPassword])
    );
  }

  onFormSubmit() {
    _toucheEveryField();
    if (!state.isValid) return;

    print (state);
  }

  _toucheEveryField() {
    var email = Email.dirty(state.email.value);
    var password = Password.dirty(state.password.value);
    state = state.copyWith(
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
      isFormPosted: true,
    );
  }
}


// el estado
class LoginFormState extends Equatable {
  final Email email;
  final Password password;
  final bool isSubmitting;
  final bool isValid;
  final bool isFormPosted;

  const LoginFormState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isSubmitting = false,
    this.isValid = false,
    this.isFormPosted = false,
  });

  @override
  List<Object?> get props => [email, password, isSubmitting, isValid, isFormPosted];

  @override
  String toString() => '''
    LoginFormState {
      email: $email,
      password: $password,
      isSubmitting: $isSubmitting,
      isSuccess: $isValid,
      isFormPosted: $isFormPosted,
    }
''';

  // Copiar el estado
  LoginFormState copyWith({
    Email? email,
    Password? password,
    bool? isSubmitting,
    bool? isValid,
    bool? isFormPosted,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValid: isValid ?? this.isValid,
      isFormPosted: isFormPosted ?? this.isFormPosted,
    );
  }
}

