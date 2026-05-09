import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/domain/repositories/fund_repository.dart';
import 'package:btgproject/domain/repositories/investment_repository.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';

import 'package:btgproject/presentation/dashboard/bloc/home_bloc.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_event.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_state.dart';

class MockFundRepository extends Mock implements FundRepository {}
class MockUserRepository extends Mock implements UserRepository {}
class MockInvestmentRepository extends Mock implements InvestmentRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockFundRepository fundRepo;
  late MockUserRepository userRepo;
  late MockInvestmentRepository investmentRepo;
  late MockTransactionRepository transactionRepo;

  final testUser = const User(
    id: 1,
    name: 'Test User',
    availableBalance: 1000.0,
    currency: 'USD',
  );
  final testFund = const Fund(
    id: 1,
    name: 'Fund A',
    minimumAmount: 100.0,
    category: 'Acciones',
    description: 'Test Fund',
    riskLevel: 'Alto',
  );
  final testFund2 = const Fund(
    id: 2,
    name: 'Fund B',
    minimumAmount: 200.0,
    category: 'Renta Fija',
    description: 'Another Fund',
    riskLevel: 'Bajo',
  );
  final testInvestment = Investment(
    id: 'INV-1',
    fundId: 1,
    fundName: 'Fund A',
    amount: 200.0,
    subscriptionDate: DateTime(2025, 1, 15),
    notificationMethod: 'EMAIL',
  );

  setUp(() {
    fundRepo = MockFundRepository();
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

  HomeBloc buildBloc() => HomeBloc(
        fundRepository: fundRepo,
        userRepository: userRepo,
        investmentRepository: investmentRepo,
        transactionRepository: transactionRepo,
      );

  group('HomeBloc', () {
    test('initial state is HomeState with initial status', () {
      final bloc = buildBloc();
      expect(bloc.state, const HomeState());
    });

    group('HomeLoadRequested', () {
      blocTest<HomeBloc, HomeState>(
        'emits loading then success with user, funds, and investments',
        build: buildBloc,
        setUp: () {
          when(() => userRepo.getUser()).thenAnswer((_) async => testUser);
          when(() => fundRepo.getFunds()).thenAnswer((_) async => [testFund, testFund2]);
          when(() => investmentRepo.getInvestments()).thenAnswer((_) async => [testInvestment]);
        },
        act: (bloc) => bloc.add(HomeLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, HomeStatus.success);
          expect(bloc.state.user, testUser);
          expect(bloc.state.funds, [testFund, testFund2]);
          expect(bloc.state.investments, [testInvestment]);
          expect(bloc.state.errorMessage, isNull);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits loading then error when fund repo throws',
        build: buildBloc,
        setUp: () {
          when(() => userRepo.getUser()).thenAnswer((_) async => testUser);
          when(() => fundRepo.getFunds()).thenThrow(Exception('DB error'));
          when(() => investmentRepo.getInvestments()).thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(HomeLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, HomeStatus.error);
          expect(bloc.state.errorMessage, 'No se pudieron cargar los datos. Intenta de nuevo.');
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits loading then error when user repo throws',
        build: buildBloc,
        setUp: () {
          when(() => userRepo.getUser()).thenThrow(Exception('Auth error'));
          when(() => fundRepo.getFunds()).thenAnswer((_) async => []);
          when(() => investmentRepo.getInvestments()).thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(HomeLoadRequested()),
        verify: (bloc) {
          expect(bloc.state.status, HomeStatus.error);
        },
      );
    });

    group('HomeCategoryChanged', () {
      blocTest<HomeBloc, HomeState>(
        'updates selectedCategory when category changes',
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeCategoryChanged('Renta Fija')),
        verify: (bloc) {
          expect(bloc.state.selectedCategory, 'Renta Fija');
        },
      );

      blocTest<HomeBloc, HomeState>(
        'updates selectedCategory to default Todos',
        build: buildBloc,
        seed: () => const HomeState(selectedCategory: 'Acciones'),
        act: (bloc) => bloc.add(const HomeCategoryChanged('Todos')),
        verify: (bloc) {
          expect(bloc.state.selectedCategory, 'Todos');
        },
      );
    });

    group('SubscribeToFund', () {
      blocTest<HomeBloc, HomeState>(
        'does nothing when user is null',
        build: buildBloc,
        act: (bloc) => bloc.add(SubscribeToFund(
          fund: testFund,
          amount: 200.0,
          notificationMethod: 'EMAIL',
        )),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.idle);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits subscription error when amount is below minimum',
        build: buildBloc,
        seed: () => HomeState(user: testUser),
        act: (bloc) => bloc.add(SubscribeToFund(
          fund: testFund,
          amount: 50.0,
          notificationMethod: 'EMAIL',
        )),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.error);
          expect(bloc.state.subscriptionError, 'El monto mínimo para este fondo es \$100');
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits subscription error when balance is insufficient',
        build: buildBloc,
        seed: () => HomeState(user: testUser),
        act: (bloc) => bloc.add(SubscribeToFund(
          fund: testFund,
          amount: 1500.0,
          notificationMethod: 'SMS',
        )),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.error);
          expect(bloc.state.subscriptionError,
              'No tiene saldo disponible para vincularse al fondo Fund A');
        },
      );

      blocTest<HomeBloc, HomeState>(
        'subscribes successfully and reloads data',
        build: buildBloc,
        seed: () => HomeState(user: testUser),
        setUp: () {
          final updatedUser = const User(
            id: 1,
            name: 'Test User',
            availableBalance: 800.0,
            currency: 'USD',
          );
          when(() => investmentRepo.subscribe(any())).thenAnswer((_) async {});
          when(() => transactionRepo.addTransaction(any())).thenAnswer((_) async {});
          when(() => userRepo.updateBalance(800.0)).thenAnswer((_) async {});
          when(() => userRepo.getUser()).thenAnswer((_) async => updatedUser);
          when(() => investmentRepo.getInvestments()).thenAnswer((_) async => [testInvestment]);
        },
        act: (bloc) => bloc.add(SubscribeToFund(
          fund: testFund,
          amount: 200.0,
          notificationMethod: 'EMAIL',
        )),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.success);
          expect(bloc.state.user!.availableBalance, 800.0);
          expect(bloc.state.investments, [testInvestment]);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits subscription error when repo throws during processing',
        build: buildBloc,
        seed: () => HomeState(user: testUser),
        setUp: () {
          when(() => investmentRepo.subscribe(any())).thenThrow(Exception('DB write error'));
        },
        act: (bloc) => bloc.add(SubscribeToFund(
          fund: testFund,
          amount: 200.0,
          notificationMethod: 'EMAIL',
        )),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.error);
          expect(bloc.state.subscriptionError,
              'Error al procesar la suscripción. Intenta de nuevo.');
        },
      );
    });

    group('ResetSubscriptionStatus', () {
      blocTest<HomeBloc, HomeState>(
        'resets subscriptionStatus to idle',
        build: buildBloc,
        seed: () => const HomeState(subscriptionStatus: SubscriptionStatus.success),
        act: (bloc) => bloc.add(ResetSubscriptionStatus()),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.idle);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'resets from error to idle',
        build: buildBloc,
        seed: () => const HomeState(
          subscriptionStatus: SubscriptionStatus.error,
          subscriptionError: 'Some error',
        ),
        act: (bloc) => bloc.add(ResetSubscriptionStatus()),
        verify: (bloc) {
          expect(bloc.state.subscriptionStatus, SubscriptionStatus.idle);
        },
      );
    });
  });
}
