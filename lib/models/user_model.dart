import 'dart:convert';

class UserModel {
  String? email;
  String? phone;
  String? fullname;

  UserModel(this.email, this.phone, this.fullname);

  UserModel.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    email = data['email'];
    fullname = data['fullname'];
    phone = data['phone'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['email'] = email;
    map['phone'] = phone;
    map['fullname'] = fullname;
    return map;
  }
}
