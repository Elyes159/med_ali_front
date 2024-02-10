import 'package:dio/dio.dart';
import 'package:e_commerce_front/constants.dart';

class OtpRepository {
  final Dio dio = Dio();

  Future<Response> verifyotp(phone, otp) async {
    final response = await dio
        .post("$BASE_URL/verify_otp/", data: {'otp': otp, 'phone': phone});
    return response;
  }

  // ignore: unused_element
  Future<Response> createAccount(
      {required String email,
      required String phone,
      required String name,
      required String password}) async {
    final response = await dio.post("$BASE_URL/create_account/", data: {
      'email': email,
      'phone': phone,
      'fullname': name,
      'password': password
    });
    return response;
  }

  void resendOtp(phone) {
    dio.post("$BASE_URL/resend_otp/", data: {'phone': phone});
  }
}
