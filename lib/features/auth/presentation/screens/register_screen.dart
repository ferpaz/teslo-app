import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        if ( !context.canPop() ) return;
                        context.pop();
                      },
                      icon: const Icon( Icons.arrow_back_rounded, size: 40, color: Colors.white )
                    ),
                    const Spacer(flex: 1),
                    Text('Crear cuenta', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox( height: 50 ),

                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red.shade900,
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
     });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const Spacer(),
          Text('Nueva cuenta', style: textStyles.titleMedium ),
          const Spacer(),

          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.name,
            errorMessage: registerForm.isFormPosted ? registerForm.fullName.errorMessage : null,
            onChanged: ref.read(registerFormProvider.notifier).onFullNameChanged,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox( height: 30 ),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            errorMessage: registerForm.isFormPosted ? registerForm.email.errorMessage : null,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChanged,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox( height: 30 ),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            errorMessage: registerForm.isFormPosted ? registerForm.password.errorMessage : null,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChanged,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox( height: 30 ),

          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            errorMessage: registerForm.isFormPosted ? registerForm.confirmPassword.errorMessage : null,
            onChanged: ref.read(registerFormProvider.notifier).onConfirmPasswordChanged,
            onFieldSubmitted: (_) => ref.read(registerFormProvider.notifier).onFormSubmit(),
            textInputAction: TextInputAction.done,
          ),

          const SizedBox( height: 30 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Crear',
              buttonColor: Colors.black,
              onPressed: registerForm.isSubmitting
                ? null
                : ref.read(registerFormProvider.notifier).onFormSubmit,
            )
          ),

          const Spacer(flex: 2,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: () => context.canPop() ? context.pop() : context.go('/login'),
                child: const Text('Ingresa aquí')
              )
            ],
          ),

          const Spacer( flex: 1, ),
        ],
      ),
    );
  }
}