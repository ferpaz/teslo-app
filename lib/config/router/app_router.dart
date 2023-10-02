import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

final appRouter = GoRouter(
  initialLocation: '/check-auth-status',
  routes: [
    ///* Primera pantalla que se muestra
    GoRoute(
      path: '/check-auth-status',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductsScreen(),
    ),
  ],
  ///! TODO: Bloquear si no se está autenticado de alguna manera
);