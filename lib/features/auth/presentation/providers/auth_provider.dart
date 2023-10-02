import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/services.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepository();
  final keyValueStorageService = SharedPreferencesKeyValueStorageServices();

  return AuthNotifier(authRepository: authRepository, keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryBase authRepository;
  final KeyValueStorageServiceBase keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }): super(const AuthState());

  Future<void> signIn(String email, String password) async {
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
      singOut('Error desconocido: $e');
    }
  }

  void singOut([String errorMessage = '']) async {
    await keyValueStorageService.removeKey('token');

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
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);

    } on EmailAlreadyInUseException catch (e) {
      singOut(e.message);
    } on CustomException catch (e) {
      singOut(e.message);
    } catch (e) {
      singOut('Error desconocido: $e');
    }

  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setValue('token', user.token);

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