import 'package:e_commerce_front/constants.dart';
import 'package:e_commerce_front/registration/login/login_screen.dart';
import 'package:e_commerce_front/registration/otp/otp_cubit.dart';
import 'package:e_commerce_front/registration/otp/otp_screen.dart';
import 'package:e_commerce_front/registration/signup/signup_cubit.dart';
import 'package:e_commerce_front/registration/signup/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  final formkey = GlobalKey<FormState>();

  late String _email = '';
  late String _phone;
  late String _name;
  late String _password = '';
  late String _confirmpassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
              key: formkey,
              child: BlocConsumer<SignUpCubit, SignUpState>(
                listener: (context, state) {
                  if (state is SignUpsuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider<OtpCubit>(
                            create: (_) => OtpCubit(),
                            child:
                                OtpScreen(_email, _phone, _name, _password))));
                  }
                  if (state is SignUpFailed) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return Column(
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
                      _emailField(
                          !(state is SignUpmitting),
                          state is SignUpFailed
                              ? state.message == 'email already exists'
                              : null),
                      SizedBox(
                        height: 28,
                      ),
                      _phoneField(
                          !(state is SignUpmitting),
                          state is SignUpFailed
                              ? state.message == 'phone already exists'
                              : null),
                      SizedBox(
                        height: 28,
                      ),
                      _nameField(!(state is SignUpmitting)),
                      SizedBox(
                        height: 28,
                      ),
                      _passwordField(!(state is SignUpmitting)),
                      SizedBox(
                        height: 28,
                      ),
                      _confirmpasswordField(!(state is SignUpmitting)),
                      SizedBox(
                        height: 28,
                      ),
                      if (state is SignUpmitting) CircularProgressIndicator(),
                      SizedBox(
                        height: 28,
                      ),
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
                          onPressed: (state is SignUpmitting)
                              ? null
                              : () {
                                  if (formkey.currentState!.validate()) {
                                    BlocProvider.of<SignUpCubit>(context)
                                        .requestOtp(_email, _phone);
                                  }
                                },
                          child: Text("Create Account")),
                      SizedBox(
                        height: 48,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          },
                          child: Text('Already have an account ? Login'))
                    ],
                  );
                },
              )),
        ),
      )),
    );
  }

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
          hintText: "Enter your email adress",
          labelText: "Email Adress",
          suffixIcon: const Icon(Icons.email)),
    );
  }

  Widget _phoneField(enableForm, error) {
    return TextFormField(
      maxLength: 10,
      enabled: enableForm,
      validator: (value) {
        if (value!.length != 8) {
          return "please enter a valid phone number!";
        }
        _phone = value;
      },
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your phone number",
          labelText: "phone",
          suffixIcon: const Icon(Icons.smartphone)),
    );
  }

  Widget _nameField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      validator: (value) {
        if (value!.length <= 1) {
          return "please enter a valid name!";
        }
        _name = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your name",
          labelText: "Fullname",
          suffixIcon: const Icon(Icons.person)),
    );
  }

  Widget _passwordField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      validator: (value) {
        if (value!.length < 8) {
          return "please enter a valid password";
        }
        _password = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your password",
          labelText: "password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }

  Widget _confirmpasswordField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      validator: (value) {
        if (value != _password) {
          return "confirmation incorrect";
        }
        _confirmpassword = value!;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Confirm your password",
          labelText: "confirm password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }
}
