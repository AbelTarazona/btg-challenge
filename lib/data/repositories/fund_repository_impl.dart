import 'package:btgproject/core/utils/mock_delay.dart';
import 'package:btgproject/data/datasources/fund_local_datasource.dart';
import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/domain/repositories/fund_repository.dart';

class FundRepositoryImpl implements FundRepository {
  final FundLocalDataSource _dataSource;

  FundRepositoryImpl({required FundLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Fund>> getFunds() async {
    return withMockDelay(() async {
      final models = await _dataSource.getFunds();
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
