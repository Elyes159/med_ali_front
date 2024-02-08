import 'package:e_commerce_front/constants.dart';
import 'package:e_commerce_front/registration/authentification/auth_cubit.dart';
import 'package:e_commerce_front/registration/authentification/auth_repository.dart';
import 'package:e_commerce_front/registration/authentification/auth_state.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: PRIMARY_SWATCH,
            ),
            home: state is Authenticated
                ? Text("fsfs")
                : state is AuthenticationFailed || state is Authenticating
                    ? Text("Authenticating")
                    : Text("signup"));
      }),
    );
  }
}
