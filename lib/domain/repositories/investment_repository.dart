import 'package:btgproject/domain/entities/investment.dart';

abstract class InvestmentRepository {
  Future<List<Investment>> getInvestments();
  Future<void> subscribe(Investment investment);
  Future<void> cancel(String investmentId);
}
