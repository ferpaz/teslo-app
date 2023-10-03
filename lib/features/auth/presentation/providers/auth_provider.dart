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
  }): super(const AuthState()) {
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    var token = await keyValueStorageService.getValue<String>('token');
    if (token == null || token == '') {
      await singOut();
      return;
    }

    try {
      final user = await authRepository.checkAuthStatus(token);
      await _setLoggedUser(user);
    } catch (e) {
      await singOut();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      await _setLoggedUser(user);
    }
    on InvalidCredentialsException catch (e) {
      await singOut(e.message);
    }
    on CustomException catch (e) {
      await singOut(e.message);
    }
    catch (e) {
      await singOut('Error desconocido: $e');
    }
  }

  Future<void> singOut([String errorMessage = '']) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  Future<void> registerUser(String email, String password, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.register(email, password, fullName);
      await _setLoggedUser(user);

    } on EmailAlreadyInUseException catch (e) {
      await singOut(e.message);
    } on CustomException catch (e) {
      await singOut(e.message);
    } catch (e) {
      await singOut('Error desconocido: $e');
    }

  }

  Future<void> _setLoggedUser(User user) async {
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