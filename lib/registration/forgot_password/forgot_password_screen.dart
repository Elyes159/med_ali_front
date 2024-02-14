import 'package:e_commerce_front/constants.dart';
import 'package:e_commerce_front/registration/forgot_password/forgot_password_cubit.dart';
import 'package:e_commerce_front/registration/forgot_password/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Étape 1: Déclarer la clé du formulaire et d'autres variables nécessaires
  final formkey = GlobalKey<FormState>();
  late String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Form(
              key: formkey,
              child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 28,
                      ),
                      Image.asset(
                        (state is ForgotPasswordSuccess)
                            ? "assets/inbox.png"
                            : 'assets/forgotpass.png',
                        height: 100,
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Text(
                        state is ForgotPasswordSuccess
                            ? "check your inbox"
                            : "Forgot password",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      Text(
                        state is ForgotPasswordSuccess
                            ? "A verification code has been successfully sent to your phone"
                            : "Don't worry, we just need your email address and all will be alright",
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      _emailField(
                        !(state is ForgotPasswordSubmitting) &&
                            !(state is ForgotPasswordSuccess),
                        state is ForgotPasswordFailed ? state.message : null,
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      if (state is ForgotPasswordSubmitting)
                        CircularProgressIndicator(),
                      if (!(state is ForgotPasswordSuccess))
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            elevation: MaterialStateProperty.all(0),
                            fixedSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 60)),
                          ),
                          onPressed: (state is ForgotPasswordSubmitting)
                              ? null
                              : () {
                                  if (formkey.currentState!.validate()) {
                                    BlocProvider.of<ForgotPasswordCubit>(
                                            context)
                                        .resetPassword(_email);
                                  }
                                },
                          child: Text("Reset Password"),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Étape 2: Extraire le champ d'email dans une méthode séparée
  Widget _emailField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      validator: (value) {
        if (value!.length < 2) {
          return "please enter a valid email number!";
        }
        _email = value;
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
        hintText: "Enter your registered email address",
        labelText: "Email Address",
        suffixIcon: const Icon(Icons.email),
      ),
    );
  }
}
