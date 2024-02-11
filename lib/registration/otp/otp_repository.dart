import 'package:dio/dio.dart';
import 'package:e_commerce_front/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpRepository {
  final Dio dio = Dio();

  Future<http.Response> verifyOtp(String phone, String otp) async {
    final Uri uri = Uri.parse("$BASE_URL/verify_otp/");
    final Map<String, String> data = {'otp': otp, 'phone': phone};

    final http.Response response = await http.post(
      uri,
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  // ignore: unused_element
  Future<http.Response> createAccount({
    required String email,
    required String phone,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$BASE_URL/create_account/');
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'phone': phone,
        'fullname': name,
        'password': password,
      }),
    );
    return response;
  }

  void resendOtp(String phone) async {
    final url = Uri.parse('$BASE_URL/resend_otp/');
    await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
  }
}
