import 'package:btgproject/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser();
}
