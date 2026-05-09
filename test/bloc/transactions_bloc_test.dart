import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';

import 'package:btgproject/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_event.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_state.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository transactionRepo;

  final recentTx = Transaction(
    id: 'TX-2',
    type: 'CANCELLATION',
    fundId: 1,
    fundName: 'Fund A',
    amount: 150.0,
    date: DateTime(2025, 3, 10),
    notificationMethod: 'SMS',
  );
  final olderTx = Transaction(
    id: 'TX-1',
    type: 'SUBSCRIPTION',
    fundId: 1,
    fundName: 'Fund A',
    amount: 200.0,
    date: DateTime(2025, 1, 15),
    notificationMethod: 'EMAIL',
  );
  final anotherTx = Transaction(
    id: 'TX-3',
    type: 'SUBSCRIPTION',
    fundId: 2,
    fundName: 'Fund B',
    amount: 500.0,
    date: DateTime(2025, 2, 1),
    notificationMethod: 'EMAIL',
  );

  setUp(() {
    transactionRepo = MockTransactionRepository();
  });

  TransactionsBloc buildBloc() => TransactionsBloc(
        transactionRepository: transactionRepo,
      );

  group('TransactionsBloc', () {
    test('initial state is correct', () {
      final bloc = buildBloc();
      expect(bloc.state, const TransactionsState());
    });

    group('TransactionsLoadRequested', () {
      blocTest<TransactionsBloc, TransactionsState>(
        'emits loading then success with transactions sorted by date desc',
        build: buildBloc,
        setUp: () {
          when(() => transactionRepo.getTransactions()).thenAnswer(
            (_) async => [olderTx, recentTx, anotherTx],
          );
        },
        act: (bloc) => bloc.add(TransactionsLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, TransactionsStatus.success);
          expect(bloc.state.transactions.length, 3);
          expect(bloc.state.transactions[0].id, 'TX-2');
          expect(bloc.state.transactions[1].id, 'TX-3');
          expect(bloc.state.transactions[2].id, 'TX-1');
        },
      );

      blocTest<TransactionsBloc, TransactionsState>(
        'emits loading then success with empty list',
        build: buildBloc,
        setUp: () {
          when(() => transactionRepo.getTransactions()).thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(TransactionsLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, TransactionsStatus.success);
          expect(bloc.state.transactions, isEmpty);
        },
      );

      blocTest<TransactionsBloc, TransactionsState>(
        'emits loading then error when repo throws',
        build: buildBloc,
        setUp: () {
          when(() => transactionRepo.getTransactions()).thenThrow(Exception('DB error'));
        },
        act: (bloc) => bloc.add(TransactionsLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, TransactionsStatus.error);
          expect(bloc.state.errorMessage,
              'No se pudo cargar el historial de transacciones.');
        },
      );
    });

    group('TransactionsFilterChanged', () {
      blocTest<TransactionsBloc, TransactionsState>(
        'updates filter to Suscripciones',
        build: buildBloc,
        act: (bloc) => bloc.add(const TransactionsFilterChanged('Suscripciones')),
        verify: (bloc) {
          expect(bloc.state.selectedFilter, 'Suscripciones');
        },
      );

      blocTest<TransactionsBloc, TransactionsState>(
        'updates filter to Cancelaciones',
        build: buildBloc,
        act: (bloc) => bloc.add(const TransactionsFilterChanged('Cancelaciones')),
        verify: (bloc) {
          expect(bloc.state.selectedFilter, 'Cancelaciones');
        },
      );

      blocTest<TransactionsBloc, TransactionsState>(
        'updates filter back to Todas',
        build: buildBloc,
        seed: () => const TransactionsState(selectedFilter: 'Suscripciones'),
        act: (bloc) => bloc.add(const TransactionsFilterChanged('Todas')),
        verify: (bloc) {
          expect(bloc.state.selectedFilter, 'Todas');
        },
      );
    });
  });
}
