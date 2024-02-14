import 'package:e_commerce_front/constants.dart';
import 'package:http/http.dart' as http;

class HomeFragmentRepository {
  Future<http.Response> categories() async {
    final response = await http.get(
      Uri.parse(BASE_URL + '/categories/'),
    );
    return response;
  }

  Future<http.Response> slides() async {
    final response = await http.get(
      Uri.parse(BASE_URL + '/slides/'),
    );
    return response;
  }
}
