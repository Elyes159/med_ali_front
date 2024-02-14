import 'package:http/http.dart' as http;

class LoginRepository {
  Future<http.Response> login(
      String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.17:8000/login/'),
      body: {
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return response;
  }
}
