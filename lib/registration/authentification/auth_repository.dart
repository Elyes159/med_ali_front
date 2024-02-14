import 'package:e_commerce_front/registration/authentification/auth_cubit.dart';

class AuthRepository {
  String getUserData({required String token}) {
    //final url = Uri.parse('$BASE_URL/userdata/');
    print("toooooooooooken : " + token);

    // final headers = <String, String>{
    //   HttpHeaders.authorizationHeader: token,
    // };
    return token;
  }
}
