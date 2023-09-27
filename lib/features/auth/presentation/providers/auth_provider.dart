import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepository();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryBase authRepository;

  AuthNotifier({
    required this.authRepository
  }): super(const AuthState());

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    }
    on InvalidCredentialsException catch (e) {
      singOut(e.message);
    }
    on CustomException catch (e) {
      singOut(e.message);
    }
    catch (e) {
      singOut('Error desconocido');
    }
  }

  void singOut([String errorMessage = '']) async {
    // TODO: Limpiar el token guardado físicamente
    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  void checkAuthStatus() async {
    final user = await authRepository.checkAuthStatus();

    state = state.copyWith(
      status: AuthStatus.checking,
      user: user,
    );
  }

  void registerUser(String email, String password, String fullName) async {
    final user = await authRepository.register(email, password, fullName);

    _setLoggedUser(user);
  }

  void _setLoggedUser(User user) async {
    // TODO: guadar token fisicamente

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String errorMessage;

  const AuthState({
    this.status = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) => AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );

  @override
  List<Object?> get props => [status, user, errorMessage];
}