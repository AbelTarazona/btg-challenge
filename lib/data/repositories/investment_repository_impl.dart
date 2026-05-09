import 'package:btgproject/core/utils/mock_delay.dart';
import 'package:btgproject/data/datasources/investment_local_datasource.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/repositories/investment_repository.dart';

class InvestmentRepositoryImpl implements InvestmentRepository {
  final InvestmentLocalDataSource _dataSource;

  InvestmentRepositoryImpl({required InvestmentLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Investment>> getInvestments() async {
    return withMockDelay(() async {
      final models = await _dataSource.getInvestments();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<void> subscribe(Investment investment) async {
    return withMockDelay(
      () => _dataSource.subscribe(investment),
      delay: const Duration(milliseconds: 500),
    );
  }

  @override
  Future<void> cancel(String investmentId) async {
    return withMockDelay(
      () => _dataSource.cancel(investmentId),
      delay: const Duration(milliseconds: 500),
    );
  }
}
