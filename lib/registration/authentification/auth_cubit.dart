import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commerce_front/models/user_model.dart';
import 'package:e_commerce_front/registration/authentification/auth_repository.dart';
import 'package:e_commerce_front/registration/authentification/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
        print(e);
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
      var response = authRepository.getUserData(token: token);
      newState = Authenticated(UserModel.fromJson(response));
      print("ahay : $newState");
      emit(newState);
    } catch (error) {
      // Initialiser la variable newState avec une valeur par défaut
      newState = LoggedOut();
      if (error is DioError) {
        if (error.response != null) {
          newState = await removeToken();
          print("DioError: Response not null - $newState");
        } else {
          if (error.type == DioErrorType.connectionError) {
            newState =
                AuthenticationFailed("Please check your internet connection");
            print("DioError: Connection error - $newState");
          } else {
            newState = AuthenticationFailed(error.message!);
            print("DioError: Other error - $newState");
          }
        }
      } else if (error is http.ClientException) {
        // Gérer les erreurs HTTP ici
        newState = AuthenticationFailed("HTTP Error: ${error.message}");
        print("HTTP Error: $newState");
      } else if (error is AuthenticationFailed) {
        // Gérer l'erreur AuthenticationFailed ici
        print("AuthenticationFailed: $error");
      } else {
        // Gérer d'autres types d'erreurs si nécessaire
        newState = AuthenticationFailed("An error occurred: $error");
        print("Other Error: $newState");
      }

      // Émettez l'état après avoir complété l'initialisation dans le bloc catch
      emit(newState);
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
