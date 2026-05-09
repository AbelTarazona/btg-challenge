import 'package:flutter_test/flutter_test.dart';

import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/presentation/funds/bloc/funds_state.dart';

void main() {
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

  group('FundsState', () {
    test('initial state has correct defaults', () {
      const state = FundsState();
      expect(state.status, FundsStatus.initial);
      expect(state.user, isNull);
      expect(state.investments, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.cancellationStatus, CancellationStatus.idle);
      expect(state.cancellationError, isNull);
      expect(state.cancellingInvestmentId, isNull);
    });

    group('copyWith', () {
      test('returns same state when called with no arguments', () {
        const state = FundsState();
        expect(state.copyWith(), state);
      });

      test('returns new state with updated status', () {
        const state = FundsState();
        final updated = state.copyWith(status: FundsStatus.loading);
        expect(updated.status, FundsStatus.loading);
      });

      test('returns new state with updated user and investments', () {
        const state = FundsState();
        final updated = state.copyWith(
          user: testUser,
          investments: [testInvestment],
        );
        expect(updated.user, testUser);
        expect(updated.investments, [testInvestment]);
      });

      test('returns new state with cancellation fields', () {
        const state = FundsState();
        final updated = state.copyWith(
          cancellationStatus: CancellationStatus.loading,
          cancellingInvestmentId: 'INV-5',
        );
        expect(updated.cancellationStatus, CancellationStatus.loading);
        expect(updated.cancellingInvestmentId, 'INV-5');
      });

      test('passes null through for cancellationError', () {
        const state = FundsState(cancellationError: 'Error');
        final updated = state.copyWith(cancellationError: null);
        expect(updated.cancellationError, isNull);
      });
    });

    group('equality', () {
      test('two equal states compare as equal', () {
        const state1 = FundsState(status: FundsStatus.loading);
        const state2 = FundsState(status: FundsStatus.loading);
        expect(state1, state2);
      });

      test('two different states compare as not equal', () {
        const state1 = FundsState(status: FundsStatus.loading);
        const state2 = FundsState(status: FundsStatus.error);
        expect(state1, isNot(state2));
      });

      test('states with same investments are equal', () {
        final investments = [testInvestment];
        final state1 = FundsState(investments: investments);
        final state2 = FundsState(investments: investments);
        expect(state1, state2);
      });
    });
  });
}
