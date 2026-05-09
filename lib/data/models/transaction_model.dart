import 'package:btgproject/domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String type;
  final int fundId;
  final String fundName;
  final double amount;
  final DateTime date;
  final String notificationMethod;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.notificationMethod,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      fundId: json['fundId'] as int,
      fundName: json['fundName'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notificationMethod: json['notificationMethod'] as String,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      type: type,
      fundId: fundId,
      fundName: fundName,
      amount: amount,
      date: date,
      notificationMethod: notificationMethod,
    );
  }
}
