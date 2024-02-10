import 'package:dio/dio.dart';
import 'package:e_commerce_front/constants.dart';

class SignupRepository {
  final Dio dio = Dio();

  Future<Response> requestOtp(email, phone) async {
    final response = await dio.post("http://192.168.1.17:8000/request_otp/",
        data: {'email': email, 'phone': phone});
    return response;
  }
}
