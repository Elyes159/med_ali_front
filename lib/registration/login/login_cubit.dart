// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:e_commerce_front/registration/login/login_repository.dart';
import 'package:e_commerce_front/registration/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  LoginRepository _repository = LoginRepository();

  void login(emailPhone, password) {
    String? email, phone;

    emit(LoginSubmitting());

    if (emailPhone!.contains('@')) {
      email = emailPhone;
    } else {
      phone = emailPhone;
    }
    _repository.login(email ?? '', phone ?? '', password).then((response) {
      emit(LoginSuccess(response.body));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(LoginFailed(error.response!.data));
        } catch (e) {
          emit(LoginFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.connectionError) {
          emit(LoginFailed("please check your connection"));
        } else {
          emit(LoginFailed(error.message!));
        }
      }
    });
  }
}
