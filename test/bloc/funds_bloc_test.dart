import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/domain/repositories/investment_repository.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';

import 'package:btgproject/presentation/funds/bloc/funds_bloc.dart';
import 'package:btgproject/presentation/funds/bloc/funds_event.dart';
import 'package:btgproject/presentation/funds/bloc/funds_state.dart';

class MockUserRepository extends Mock implements UserRepository {}
class MockInvestmentRepository extends Mock implements InvestmentRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockUserRepository userRepo;
  late MockInvestmentRepository investmentRepo;
  late MockTransactionRepository transactionRepo;

  final testUser = const User(
    id: 1,
    name: 'Test User',
    availableBalance: 1000.0,
    currency: 'USD',
  );
  final testInvestment = Investment(
    id: 'INV-1',
    fundId: 1,
    fundName: 'Fund A',
    amount: 300.0,
    subscriptionDate: DateTime(2025, 1, 15),
    notificationMethod: 'EMAIL',
  );
  final testInvestment2 = Investment(
    id: 'INV-2',
    fundId: 2,
    fundName: 'Fund B',
    amount: 500.0,
    subscriptionDate: DateTime(2025, 2, 20),
    notificationMethod: 'SMS',
  );

  setUp(() {
    userRepo = MockUserRepository();
    investmentRepo = MockInvestmentRepository();
    transactionRepo = MockTransactionRepository();

    registerFallbackValue(Investment(
      id: 'fallback-inv',
      fundId: 0,
      fundName: '',
      amount: 0,
      subscriptionDate: DateTime(2025),
      notificationMethod: 'EMAIL',
    ));
    registerFallbackValue(Transaction(
      id: 'fallback-tx',
      type: '',
      fundId: 0,
      fundName: '',
      amount: 0,
      date: DateTime(2025),
      notificationMethod: 'EMAIL',
    ));
  });

  FundsBloc buildBloc() => FundsBloc(
        userRepository: userRepo,
        investmentRepository: investmentRepo,
        transactionRepository: transactionRepo,
      );

  group('FundsBloc', () {
    test('initial state is correct', () {
      final bloc = buildBloc();
      expect(bloc.state, const FundsState());
    });

    group('FundsLoadRequested', () {
      blocTest<FundsBloc, FundsState>(
        'emits loading then success with user and investments',
        build: buildBloc,
        setUp: () {
          when(() => userRepo.getUser()).thenAnswer((_) async => testUser);
          when(() => investmentRepo.getInvestments()).thenAnswer(
            (_) async => [testInvestment, testInvestment2],
          );
        },
        act: (bloc) => bloc.add(FundsLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, FundsStatus.success);
          expect(bloc.state.user, testUser);
          expect(bloc.state.investments, [testInvestment, testInvestment2]);
        },
      );

      blocTest<FundsBloc, FundsState>(
        'emits loading then error when user repo throws',
        build: buildBloc,
        setUp: () {
          when(() => userRepo.getUser()).thenThrow(Exception('Network error'));
          when(() => investmentRepo.getInvestments()).thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(FundsLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, FundsStatus.error);
          expect(bloc.state.errorMessage, 'No se pudieron cargar las inversiones.');
        },
      );

      blocTest<FundsBloc, FundsState>(
        'emits loading then error when investment repo throws',
        build: buildBloc,
        setUp: () {
          when(() => userRepo.getUser()).thenAnswer((_) async => testUser);
          when(() => investmentRepo.getInvestments()).thenThrow(Exception('DB error'));
        },
        act: (bloc) => bloc.add(FundsLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, FundsStatus.error);
        },
      );
    });

    group('CancelInvestment', () {
      blocTest<FundsBloc, FundsState>(
        'cancels investment and reloads data successfully',
        build: buildBloc,
        seed: () => FundsState(
          status: FundsStatus.success,
          user: testUser,
          investments: [testInvestment],
        ),
        setUp: () {
          final updatedUser = const User(
            id: 1,
            name: 'Test User',
            availableBalance: 1300.0,
            currency: 'USD',
          );
          when(() => investmentRepo.cancel('INV-1')).thenAnswer((_) async {});
          when(() => transactionRepo.addTransaction(any())).thenAnswer((_) async {});
          when(() => userRepo.updateBalance(1300.0)).thenAnswer((_) async {});
          when(() => userRepo.getUser()).thenAnswer((_) async => updatedUser);
          when(() => investmentRepo.getInvestments()).thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(const CancelInvestment(
          investmentId: 'INV-1',
          amount: 300.0,
        )),
        verify: (bloc) {
          expect(bloc.state.cancellationStatus, CancellationStatus.success);
          expect(bloc.state.user!.availableBalance, 1300.0);
          expect(bloc.state.investments, isEmpty);
        },
      );

      blocTest<FundsBloc, FundsState>(
        'emits cancellation error when repo throws',
        build: buildBloc,
        seed: () => FundsState(
          status: FundsStatus.success,
          user: testUser,
          investments: [testInvestment],
        ),
        setUp: () {
          when(() => investmentRepo.cancel('INV-1')).thenThrow(Exception('Cancel failed'));
        },
        act: (bloc) => bloc.add(const CancelInvestment(
          investmentId: 'INV-1',
          amount: 300.0,
        )),
        verify: (bloc) {
          expect(bloc.state.cancellationStatus, CancellationStatus.error);
          expect(bloc.state.cancellationError, 'Error al cancelar la inversión.');
        },
      );
    });

    group('ResetCancellationStatus', () {
      blocTest<FundsBloc, FundsState>(
        'resets cancellation status to idle',
        build: buildBloc,
        seed: () => const FundsState(cancellationStatus: CancellationStatus.success),
        act: (bloc) => bloc.add(ResetCancellationStatus()),
        verify: (bloc) {
          expect(bloc.state.cancellationStatus, CancellationStatus.idle);
        },
      );

      blocTest<FundsBloc, FundsState>(
        'resets from error to idle',
        build: buildBloc,
        seed: () => const FundsState(
          cancellationStatus: CancellationStatus.error,
          cancellationError: 'Some error',
        ),
        act: (bloc) => bloc.add(ResetCancellationStatus()),
        verify: (bloc) {
          expect(bloc.state.cancellationStatus, CancellationStatus.idle);
        },
      );
    });
  });
}
