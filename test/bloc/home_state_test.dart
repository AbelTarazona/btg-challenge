import 'package:flutter_test/flutter_test.dart';

import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_state.dart';

void main() {
  final testUser = const User(
    id: 1,
    name: 'Test User',
    availableBalance: 1000.0,
    currency: 'USD',
  );
  final testFund = const Fund(
    id: 1,
    name: 'Fund Acciones',
    minimumAmount: 100.0,
    category: 'Acciones',
    description: 'Fund A',
    riskLevel: 'Alto',
  );
  final testFund2 = const Fund(
    id: 2,
    name: 'Fund Renta Fija',
    minimumAmount: 200.0,
    category: 'Renta Fija',
    description: 'Fund B',
    riskLevel: 'Bajo',
  );
  final testInvestment = Investment(
    id: 'INV-1',
    fundId: 1,
    fundName: 'Fund Acciones',
    amount: 300.0,
    subscriptionDate: DateTime(2025, 1, 15),
    notificationMethod: 'EMAIL',
  );
  final testInvestment2 = Investment(
    id: 'INV-2',
    fundId: 2,
    fundName: 'Fund Renta Fija',
    amount: 500.0,
    subscriptionDate: DateTime(2025, 2, 20),
    notificationMethod: 'SMS',
  );

  group('HomeState', () {
    test('initial state has correct defaults', () {
      const state = HomeState();
      expect(state.status, HomeStatus.initial);
      expect(state.user, isNull);
      expect(state.funds, isEmpty);
      expect(state.investments, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.selectedCategory, 'Todos');
      expect(state.subscriptionStatus, SubscriptionStatus.idle);
      expect(state.subscriptionError, isNull);
    });

    group('copyWith', () {
      test('returns same state when called with no arguments', () {
        const state = HomeState();
        expect(state.copyWith(), state);
      });

      test('returns new state with updated status', () {
        const state = HomeState();
        final updated = state.copyWith(status: HomeStatus.loading);
        expect(updated.status, HomeStatus.loading);
        expect(updated.user, state.user);
        expect(updated.funds, state.funds);
      });

      test('returns new state with updated selectedCategory', () {
        const state = HomeState();
        final updated = state.copyWith(selectedCategory: 'Acciones');
        expect(updated.selectedCategory, 'Acciones');
      });

      test('returns new state with updated user', () {
        const state = HomeState();
        final updated = state.copyWith(user: testUser);
        expect(updated.user, testUser);
      });

      test('returns new state with updated subscription fields', () {
        const state = HomeState();
        final updated = state.copyWith(
          subscriptionStatus: SubscriptionStatus.error,
          subscriptionError: 'Not enough balance',
        );
        expect(updated.subscriptionStatus, SubscriptionStatus.error);
        expect(updated.subscriptionError, 'Not enough balance');
      });

      test('passes null through for subscriptionError', () {
        const state = HomeState(subscriptionError: 'Error');
        final updated = state.copyWith(subscriptionError: null);
        expect(updated.subscriptionError, isNull);
      });
    });

    group('filteredFunds', () {
      test('returns all funds when selectedCategory is Todos', () {
        final state = HomeState(
          funds: [testFund, testFund2],
          selectedCategory: 'Todos',
        );
        expect(state.filteredFunds, [testFund, testFund2]);
      });

      test('filters funds by selected category', () {
        final state = HomeState(
          funds: [testFund, testFund2],
          selectedCategory: 'Acciones',
        );
        expect(state.filteredFunds, [testFund]);
      });

      test('returns empty when no funds match category', () {
        final state = HomeState(
          funds: [testFund],
          selectedCategory: 'Renta Fija',
        );
        expect(state.filteredFunds, isEmpty);
      });
    });

    group('isSubscribed', () {
      test('returns true when investment with given fundId exists', () {
        final state = HomeState(investments: [testInvestment]);
        expect(state.isSubscribed(1), isTrue);
      });

      test('returns false when no investment matches fundId', () {
        final state = HomeState(investments: [testInvestment]);
        expect(state.isSubscribed(999), isFalse);
      });

      test('returns false when investments list is empty', () {
        const state = HomeState();
        expect(state.isSubscribed(1), isFalse);
      });

      test('handles multiple investments', () {
        final state = HomeState(investments: [testInvestment, testInvestment2]);
        expect(state.isSubscribed(1), isTrue);
        expect(state.isSubscribed(2), isTrue);
        expect(state.isSubscribed(3), isFalse);
      });
    });

    group('equality', () {
      test('two equal states compare as equal', () {
        const state1 = HomeState(status: HomeStatus.loading);
        const state2 = HomeState(status: HomeStatus.loading);
        expect(state1, state2);
      });

      test('two different states compare as not equal', () {
        const state1 = HomeState(status: HomeStatus.loading);
        const state2 = HomeState(status: HomeStatus.success);
        expect(state1, isNot(state2));
      });
    });
  });
}
