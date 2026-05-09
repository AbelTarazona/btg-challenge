import 'package:btgproject/domain/entities/user.dart';

class UserModel {
  final int id;
  final String name;
  final double availableBalance;
  final String currency;

  const UserModel({
    required this.id,
    required this.name,
    required this.availableBalance,
    required this.currency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      availableBalance: (json['availableBalance'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      availableBalance: availableBalance,
      currency: currency,
    );
  }
}
