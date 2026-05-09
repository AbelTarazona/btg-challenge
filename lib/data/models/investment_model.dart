import 'package:btgproject/domain/entities/investment.dart';

class InvestmentModel {
  final String id;
  final int fundId;
  final String fundName;
  final double amount;
  final DateTime subscriptionDate;
  final String notificationMethod;

  const InvestmentModel({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.subscriptionDate,
    required this.notificationMethod,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String,
      fundId: json['fundId'] as int,
      fundName: json['fundName'] as String,
      amount: (json['amount'] as num).toDouble(),
      subscriptionDate: DateTime.parse(json['subscriptionDate'] as String),
      notificationMethod: json['notificationMethod'] as String,
    );
  }

  Investment toEntity() {
    return Investment(
      id: id,
      fundId: fundId,
      fundName: fundName,
      amount: amount,
      subscriptionDate: subscriptionDate,
      notificationMethod: notificationMethod,
    );
  }
}
