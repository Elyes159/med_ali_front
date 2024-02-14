import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepository {
  final Dio dio = Dio();

  Future<http.Response> reset_password(String email) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.17:8000/password_reset_email/'),
      body: {
        'email': email,
      },
    );
    return response;
  }
}
