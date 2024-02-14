import 'package:e_commerce_front/constants.dart';
import 'package:e_commerce_front/registration/authentification/auth_cubit.dart';
import 'package:e_commerce_front/registration/forgot_password/forgot_password_cubit.dart';
import 'package:e_commerce_front/registration/forgot_password/forgot_password_screen.dart';
import 'package:e_commerce_front/registration/login/login_cubit.dart';
import 'package:e_commerce_front/registration/login/login_state.dart';
import 'package:e_commerce_front/registration/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  late String emailPhone, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    BlocProvider.of<AuthCubit>(context).loggedIn(state.token);
                    Navigator.pop(context);
                  }

                  if (state is LoginFailed) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) => Column(
                  children: [
                    SizedBox(
                      height: 28,
                    ),
                    Image.asset(
                      'assets/logo.png',
                      height: 100,
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    _emailPhoneField(
                        (!(state is LoginSubmitting)),
                        state is LoginFailed
                            ? state.message == "Incorrect email"
                                ? null
                                : state.message
                            : null),
                    SizedBox(
                      height: 48,
                    ),
                    _passwordField(
                        (!(state is LoginSubmitting)),
                        state is LoginFailed
                            ? state.message != "Incorrect password"
                                ? null
                                : state.message
                            : null),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: state is LoginSubmitting
                              ? null
                              : () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          BlocProvider<ForgotPasswordCubit>(
                                              create: (_) =>
                                                  ForgotPasswordCubit(),
                                              child: ForgotPasswordScreen())));
                                },
                          child: Text("Forgot Password?")),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    if (state is LoginSubmitting) CircularProgressIndicator(),
                    SizedBox(
                      height: 28,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(0),
                        fixedSize: MaterialStateProperty.all(
                          Size(double.maxFinite, 60),
                        ),
                      ),
                      onPressed: (state is LoginSubmitting)
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<LoginCubit>(context)
                                    .login(emailPhone, password);
                              }
                            },
                      child: Text("Login"),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text('Don\'t have an account? Create an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailPhoneField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length < 4) {
          return "Invalid credentials";
        }
        emailPhone = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Email or Phone",
          labelText: "Email or Phone",
          suffixIcon: const Icon(Icons.account_circle)),
    );
  }

  Widget _passwordField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required!';
        }
        if (value!.length < 8) {
          return "Incorrect password";
        }
        password = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your password",
          labelText: "password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }
}
