// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:e_commerce_front/registration/forgot_password/forgot_password_repository.dart';
import 'package:e_commerce_front/registration/forgot_password/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  ForgotPasswordRepository _repository = ForgotPasswordRepository();

  void resetPassword(email) {
    emit(ForgotPasswordSubmitting());
    _repository.reset_password(email).then((response) {
      emit(ForgotPasswordSuccess());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ForgotPasswordFailed(error.response!.data));
        } catch (e) {
          emit(ForgotPasswordFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.connectionError) {
          emit(ForgotPasswordFailed("please check your connection"));
        } else {
          emit(ForgotPasswordFailed(error.message!));
        }
      }
    });
  }
}
