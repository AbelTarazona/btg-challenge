import 'dart:convert';

import 'package:btgproject/data/models/user_model.dart';
import 'package:flutter/services.dart';

class UserLocalDataSource {
  Future<UserModel> getUser() async {
    final jsonString = await rootBundle.loadString('assets/mocks/user.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;
    return UserModel.fromJson(jsonMap);
  }
}
