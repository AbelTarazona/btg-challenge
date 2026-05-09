import 'package:btgproject/domain/entities/transaction.dart';

enum TransactionsStatus { initial, loading, success, error }

class TransactionsState {
  final TransactionsStatus status;
  final List<Transaction> transactions;
  final String? errorMessage;
  final String selectedFilter;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.selectedFilter = 'Todas',
  });

  List<Transaction> get filteredTransactions {
    if (selectedFilter == 'Todas') return transactions;
    if (selectedFilter == 'Suscripciones') {
      return transactions.where((t) => t.type == 'SUBSCRIPTION').toList();
    }
    return transactions.where((t) => t.type == 'CANCELLATION').toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          transactions == other.transactions &&
          errorMessage == other.errorMessage &&
          selectedFilter == other.selectedFilter;

  @override
  int get hashCode =>
      status.hashCode ^
      transactions.hashCode ^
      errorMessage.hashCode ^
      selectedFilter.hashCode;

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactions,
    String? errorMessage,
    String? selectedFilter,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
