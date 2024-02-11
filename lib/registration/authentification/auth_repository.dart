import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_commerce_front/constants.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final Dio dio = Dio();
  Future<http.Response> getUserData({required String token}) async {
    final url = Uri.parse('$BASE_URL/userdata/');
    final headers = <String, String>{
      HttpHeaders.authorizationHeader: token,
    };

    return await http.get(url, headers: headers);
  }
}
