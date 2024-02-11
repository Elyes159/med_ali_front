import 'dart:async';

import 'package:e_commerce_front/constants.dart';
import 'package:e_commerce_front/registration/authentification/auth_cubit.dart';
import 'package:e_commerce_front/registration/otp/otp_cubit.dart';
import 'package:e_commerce_front/registration/otp/otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatefulWidget {
  final formkey = GlobalKey<FormState>();

  final String _email, _phone, _name, _password;
  late String _otp;
  late bool onlyVerify;

  var timer;
  int time = 0;

  OtpScreen(this._email, this._phone, this._name, this._password,
      {this.onlyVerify = false});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otppp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: widget.formkey,
          child: BlocConsumer<OtpCubit, OtpState>(listener: (context, state) {
            if (state is OtpVerificationFailed) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is OtpVerified) {
              if (widget.onlyVerify) {
                //todo only verify
              } else {
                BlocProvider.of<AuthCubit>(context).loggedIn(state.token);
                Navigator.pop(context);
              }
            }
          }, builder: (context, state) {
            return Column(children: [
              Image.asset(
                "assets/otp.png",
                height: 100,
              ),
              SizedBox(
                height: 48,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 48,
              ),
              Text(
                  "A verification code has been successfully sent to your phone"),
              _OtpField(!(state is OtpVerifying),
                  state is OtpVerificationFailed ? state.message : null),
              TextButton(
                  onPressed: widget.time != 0
                      ? null
                      : () {
                          BlocProvider.of<OtpCubit>(context)
                              .resendOtp(phone: widget._phone);
                          startTimer();
                        },
                  child: Text(widget.time != 0
                      ? "wait for ${widget.time} seconds to resend"
                      : "Resend")),
              if (state is OtpVerifying) CircularProgressIndicator(),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    fixedSize:
                        MaterialStateProperty.all(Size(double.maxFinite, 60)),
                  ),
                  onPressed: state is OtpVerifying
                      ? null
                      : () {
                          if (widget.formkey.currentState!.validate()) {
                            if (widget.onlyVerify) {
                              //todo
                            } else {
                              BlocProvider.of<OtpCubit>(context).verifyOtp(
                                  email: widget._email,
                                  phone: widget._phone,
                                  name: widget._name,
                                  password: widget._password,
                                  otp: otppp!);
                              print('Email: ${widget._email}');
                              print('Phone: ${widget._phone}');
                              print('Name: ${widget._name}');
                              print('Password: ${widget._password}');
                              print('OTP: ${otppp}');
                            }
                          }
                        },
                  child: Text("Verify")),
            ]);
          }),
        ),
      ),
    )));
  }

  Widget _OtpField(enableForm, error) {
    return TextFormField(
      maxLength: 6,
      onChanged: (value) {
        otppp = value;
      },
      enabled: enableForm,
      validator: (value) {
        if (value!.length != 6) {
          return "Invalid OTp";
        }
        widget._otp = value;
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
          hintText: "Enter 6 digits verification",
          labelText: "Verification otp",
          suffixIcon: const Icon(Icons.sms)),
    );
  }

  void startTimer() {
    widget.time = 60;
    const oneSec = const Duration(seconds: 1);
    widget.timer = Timer.periodic(oneSec, (timer) {
      if (widget.time == 0) {
        timer.cancel();
      } else {
        setState(() {
          widget.time = widget.time - 1;
        });
      }
    });
  }
}
