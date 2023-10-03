import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


// El proveedor de estado
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).signIn;
  return LoginFormNotifier(loginUserCallback);
});


// El notificador
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String email, String password) loginUserCallback;

  LoginFormNotifier(this.loginUserCallback): super( const LoginFormState());

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

  onFormSubmit() async {
    _toucheEveryField();
    if (!state.isValid) return;

    state = state.copyWith(isSubmitting: true);

    await loginUserCallback(state.email.value, state.password.value);

    state = state.copyWith(isSubmitting: false);
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
  }) => LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValid: isValid ?? this.isValid,
      isFormPosted: isFormPosted ?? this.isFormPosted,
  );
}

