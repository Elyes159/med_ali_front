import 'package:dio/dio.dart';
import 'package:e_commerce_front/registration/authentification/auth_repository.dart';
import 'package:e_commerce_front/registration/authentification/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthCubit extends Cubit<AuthState> {
  static String token = '';
  AuthRepository authRepository;
  final FlutterSecureStorage storage;
  AuthCubit({required this.storage, required this.authRepository})
      : super(AuthInitial());

  Future<AuthState> authenticate() async {
    AuthState newState;
    if (token.isEmpty) {
      try {
        var tokenvalue = await _getToken();
        if (tokenvalue == null) {
          newState = LoggedOut();
          emit(newState);
        } else {
          token = tokenvalue;
          newState = await _fetchUserData();
        }
      } catch (e) {
        newState = LoggedOut();
        emit(newState);
      }
    } else {
      newState = await _fetchUserData();
    }
    return newState;
  }

  Future<AuthState> _fetchUserData() async {
    AuthState newState;
    try {
      var response = await authRepository.getUserData(token: token);
      newState = Authenticated();
      emit(newState);
    } catch (value) {
      // ignore: deprecated_member_use
      DioError error = value as DioError;
      if (error.response != null) {
        newState = await removeToken();
      } else {
        // ignore: deprecated_member_use
        if (error.type == DioErrorType.connectionError) {
          newState =
              AuthenticationFailed("please check your internet connection");
          emit(newState);
        } else {
          newState = AuthenticationFailed(error.message!);
          emit(newState);
        }
      }
    }
    return newState;
  }

  void loggedIn(String tokenValue) {
    emit(Authenticating());
    token = tokenValue;
    _setToken(token).then((value) => _fetchUserData());
  }

  Future<AuthState> removeToken() async {
    AuthState newState;
    token = '';
    try {
      await _deleteToken();
    } catch (e) {
      //nothing
    }
    newState = LoggedOut();
    emit(newState);
    return newState;
  }

  Future<void> _setToken(token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> _getToken() async {
    String? value = await storage.read(key: "token");
    return value;
  }

  Future<void> _deleteToken() async {
    await storage.delete(key: "token");
  }
}
