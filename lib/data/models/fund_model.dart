import 'package:btgproject/domain/entities/fund.dart';

class FundModel {
  final int id;
  final String name;
  final double minimumAmount;
  final String category;
  final String description;
  final String riskLevel;

  const FundModel({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    required this.description,
    required this.riskLevel,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'] as int,
      name: json['name'] as String,
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      riskLevel: json['riskLevel'] as String,
    );
  }

  Fund toEntity() {
    return Fund(
      id: id,
      name: name,
      minimumAmount: minimumAmount,
      category: category,
      description: description,
      riskLevel: riskLevel,
    );
  }
}
