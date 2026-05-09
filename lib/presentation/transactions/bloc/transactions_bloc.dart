import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btgproject/domain/repositories/transaction_repository.dart';

import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionRepository _transactionRepository;

  TransactionsBloc({
    required TransactionRepository transactionRepository,
  })  : _transactionRepository = transactionRepository,
        super(const TransactionsState()) {
    on<TransactionsLoadRequested>(_onLoadRequested);
    on<TransactionsFilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadRequested(
    TransactionsLoadRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    try {
      final transactions = await _transactionRepository.getTransactions();
      // Ordenar por fecha descendente (más reciente primero)
      final sorted = List.of(transactions)
        ..sort((a, b) => b.date.compareTo(a.date));

      emit(state.copyWith(
        status: TransactionsStatus.success,
        transactions: sorted,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionsStatus.error,
        errorMessage: 'No se pudo cargar el historial de transacciones.',
      ));
    }
  }

  void _onFilterChanged(
    TransactionsFilterChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }
}
