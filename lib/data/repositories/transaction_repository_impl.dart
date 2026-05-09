import 'package:btgproject/core/utils/mock_delay.dart';
import 'package:btgproject/data/datasources/transaction_local_datasource.dart';
import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _dataSource;

  TransactionRepositoryImpl({required TransactionLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Transaction>> getTransactions() async {
    return withMockDelay(() async {
      final models = await _dataSource.getTransactions();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    return withMockDelay(
      () => _dataSource.addTransaction(transaction),
      delay: const Duration(milliseconds: 300),
    );
  }
}
