import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';


final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback);
});


class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String email, String password, String fullName) registerUserCallback;

  RegisterFormNotifier(this.registerUserCallback) : super(const RegisterFormState());

  onFullNameChanged(String fullName) {
    var newFullName = FullName.dirty(fullName);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password, state.confirmPassword]),
    );
  }

  onEmailChanged(String email) {
    var newEmail = Email.dirty(email);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([state.fullName, newEmail, state.password, state.confirmPassword]),
    );
  }

  onPasswordChanged(String password) {
    var newPassword = Password.dirty(password);
    var newConfirmPassword = ConfirmPassword.dirty(state.confirmPassword.value, password);

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.fullName, state.email, newPassword, newConfirmPassword]),
    );
  }

  onConfirmPasswordChanged(String confirmPassword) {
    var newPassword = Password.dirty(state.password.value);
    var newConfirmPassword = ConfirmPassword.dirty(confirmPassword, state.password.value);

    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: Formz.validate([state.fullName, state.email, newPassword, newConfirmPassword]),
    );
  }

  onFormSubmit() async {
    _toucheEveryField();
    if (!state.isValid) return;

    await registerUserCallback(state.email.value, state.password.value, state.fullName.value);
  }

  _toucheEveryField() {
    var fullName = FullName.dirty(state.fullName.value);
    var email = Email.dirty(state.email.value);
    var password = Password.dirty(state.password.value);
    var confirmPassword = ConfirmPassword.dirty(state.confirmPassword.value, state.password.value);
    state = state.copyWith(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isValid: Formz.validate([fullName, email, password, confirmPassword]),
      isFormPosted: true,
    );
  }
}


class RegisterFormState extends Equatable {
  final FullName fullName;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final bool isSubmitting;
  final bool isValid;
  final bool isFormPosted;

  const RegisterFormState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.isSubmitting = false,
    this.isValid = false,
    this.isFormPosted = false,
  });

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword, isSubmitting, isValid, isFormPosted];

  @override
  String toString() => '''
    RegisterFormState {
      fullName: $fullName,
      email: $email,
      password: $password,
      confirmPassword: $confirmPassword,
      isSubmitting: $isSubmitting,
      isValid: $isValid,
      isFormPosted: $isFormPosted,
    }
  ''';

  // copiar el estado
  RegisterFormState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isSubmitting,
    bool? isValid,
    bool? isFormPosted,
  }) => RegisterFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValid: isValid ?? this.isValid,
      isFormPosted: isFormPosted ?? this.isFormPosted,
  );
}