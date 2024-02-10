// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:e_commerce_front/registration/signup/signup_repository.dart';
import 'package:e_commerce_front/registration/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final SignupRepository _repository = SignupRepository();

  void requestOtp(email, phone) {
    emit(SignUpmitting());
    _repository
        .requestOtp(email, phone)
        .then((response) => emit(SignUpsuccess()))
        .catchError((value) {
      DioError error = value;
      if (error.response != null) {
        emit(SignUpFailed(error.response!.data));
      } else {
        if (error.type == DioErrorType.connectionError) {
          emit(SignUpFailed("please check your connection"));
        } else {
          emit(SignUpFailed(error.message!));
        }
      }
    });
  }
}
