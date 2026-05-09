import 'package:flutter_test/flutter_test.dart';

import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_state.dart';

void main() {
  final subscriptionTx = Transaction(
    id: 'TX-1',
    type: 'SUBSCRIPTION',
    fundId: 1,
    fundName: 'Fund A',
    amount: 200.0,
    date: DateTime(2025, 1, 15),
    notificationMethod: 'EMAIL',
  );
  final cancellationTx = Transaction(
    id: 'TX-2',
    type: 'CANCELLATION',
    fundId: 1,
    fundName: 'Fund A',
    amount: 150.0,
    date: DateTime(2025, 3, 10),
    notificationMethod: 'SMS',
  );
  final anotherSubscription = Transaction(
    id: 'TX-3',
    type: 'SUBSCRIPTION',
    fundId: 2,
    fundName: 'Fund B',
    amount: 500.0,
    date: DateTime(2025, 2, 1),
    notificationMethod: 'EMAIL',
  );

  group('TransactionsState', () {
    test('initial state has correct defaults', () {
      const state = TransactionsState();
      expect(state.status, TransactionsStatus.initial);
      expect(state.transactions, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.selectedFilter, 'Todas');
    });

    group('copyWith', () {
      test('returns same state when called with no arguments', () {
        const state = TransactionsState();
        expect(state.copyWith(), state);
      });

      test('returns new state with updated status', () {
        const state = TransactionsState();
        final updated = state.copyWith(status: TransactionsStatus.loading);
        expect(updated.status, TransactionsStatus.loading);
      });

      test('returns new state with updated transactions', () {
        const state = TransactionsState();
        final updated = state.copyWith(transactions: [subscriptionTx, cancellationTx]);
        expect(updated.transactions, [subscriptionTx, cancellationTx]);
      });

      test('returns new state with updated filter', () {
        const state = TransactionsState();
        final updated = state.copyWith(selectedFilter: 'Suscripciones');
        expect(updated.selectedFilter, 'Suscripciones');
      });
    });

    group('filteredTransactions', () {
      test('returns all transactions when filter is Todas', () {
        final state = TransactionsState(
          transactions: [subscriptionTx, cancellationTx, anotherSubscription],
          selectedFilter: 'Todas',
        );
        expect(state.filteredTransactions, [subscriptionTx, cancellationTx, anotherSubscription]);
      });

      test('filters only SUBSCRIPTION transactions', () {
        final state = TransactionsState(
          transactions: [subscriptionTx, cancellationTx, anotherSubscription],
          selectedFilter: 'Suscripciones',
        );
        expect(state.filteredTransactions, [subscriptionTx, anotherSubscription]);
      });

      test('filters only CANCELLATION transactions', () {
        final state = TransactionsState(
          transactions: [subscriptionTx, cancellationTx, anotherSubscription],
          selectedFilter: 'Cancelaciones',
        );
        expect(state.filteredTransactions, [cancellationTx]);
      });

      test('returns empty when no transactions match filter', () {
        final state = TransactionsState(
          transactions: [subscriptionTx],
          selectedFilter: 'Cancelaciones',
        );
        expect(state.filteredTransactions, isEmpty);
      });
    });

    group('equality', () {
      test('two equal states compare as equal', () {
        const state1 = TransactionsState(status: TransactionsStatus.loading);
        const state2 = TransactionsState(status: TransactionsStatus.loading);
        expect(state1, state2);
      });

      test('two different states compare as not equal', () {
        const state1 = TransactionsState(status: TransactionsStatus.loading);
        const state2 = TransactionsState(status: TransactionsStatus.success);
        expect(state1, isNot(state2));
      });

      test('states with same transactions are equal', () {
        final transactions = [subscriptionTx];
        final state1 = TransactionsState(transactions: transactions);
        final state2 = TransactionsState(transactions: transactions);
        expect(state1, state2);
      });
    });
  });
}
