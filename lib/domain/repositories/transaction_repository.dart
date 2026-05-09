import 'package:btgproject/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<void> addTransaction(Transaction transaction);
}
