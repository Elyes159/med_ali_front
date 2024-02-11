import 'package:e_commerce_front/constants.dart';
import 'package:e_commerce_front/home/home_screen.dart';
import 'package:e_commerce_front/registration/authentification/Authenticating_Screen.dart';
import 'package:e_commerce_front/registration/authentification/auth_cubit.dart';
import 'package:e_commerce_front/registration/authentification/auth_repository.dart';
import 'package:e_commerce_front/registration/authentification/auth_state.dart';
import 'package:e_commerce_front/registration/signup/signup_cubit.dart';
import 'package:e_commerce_front/registration/signup/signup_screen.dart';
import 'package:e_commerce_front/registration/login/login_cubit.dart'; // Ajout de l'import pour LoginCubit
import 'package:e_commerce_front/registration/login/login_screen.dart'; // Ajout de l'import pour LoginScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final AuthRepository authRepository = AuthRepository();
final storage = FlutterSecureStorage();
final AuthCubit authCubit =
    AuthCubit(storage: storage, authRepository: authRepository);

void main() async {
  if (authCubit.state is AuthInitial) {
    await authCubit.authenticate();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<SignUpCubit>(create: (_) => SignUpCubit()),
        BlocProvider<LoginCubit>(
            create: (_) =>
                LoginCubit()), // Ajout de la fourniture de LoginCubit
        // Ajoutez d'autres Cubits dont vous avez besoin ici
      ],
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: PRIMARY_SWATCH,
          ),
          home: state is Authenticated
              ? HomeScreen()
              : state is AuthenticationFailed || state is Authenticating
                  ? AuthenticatingScreen()
                  : BlocProvider<SignUpCubit>(
                      create: (_) => SignUpCubit(), child: SignupScreen()),
        );
      }),
    );
  }
}
