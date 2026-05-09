import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/user.dart';

enum HomeStatus { initial, loading, success, error }

enum SubscriptionStatus { idle, loading, success, error }

class HomeState {
  final HomeStatus status;
  final User? user;
  final List<Fund> funds;
  final List<Investment> investments;
  final String? errorMessage;
  final String selectedCategory;
  final SubscriptionStatus subscriptionStatus;
  final String? subscriptionError;

  const HomeState({
    this.status = HomeStatus.initial,
    this.user,
    this.funds = const [],
    this.investments = const [],
    this.errorMessage,
    this.selectedCategory = 'Todos',
    this.subscriptionStatus = SubscriptionStatus.idle,
    this.subscriptionError,
  });

  List<Fund> get filteredFunds {
    if (selectedCategory == 'Todos') return funds;
    return funds.where((f) => f.category == selectedCategory).toList();
  }

  /// Retorna true si el usuario está suscrito activamente al fondo indicado.
  bool isSubscribed(int fundId) {
    return investments.any((inv) => inv.fundId == fundId);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          user == other.user &&
          funds == other.funds &&
          investments == other.investments &&
          errorMessage == other.errorMessage &&
          selectedCategory == other.selectedCategory &&
          subscriptionStatus == other.subscriptionStatus &&
          subscriptionError == other.subscriptionError;

  @override
  int get hashCode =>
      status.hashCode ^
      user.hashCode ^
      funds.hashCode ^
      investments.hashCode ^
      errorMessage.hashCode ^
      selectedCategory.hashCode ^
      subscriptionStatus.hashCode ^
      subscriptionError.hashCode;

  HomeState copyWith({
    HomeStatus? status,
    User? user,
    List<Fund>? funds,
    List<Investment>? investments,
    String? errorMessage,
    String? selectedCategory,
    SubscriptionStatus? subscriptionStatus,
    String? subscriptionError,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
      funds: funds ?? this.funds,
      investments: investments ?? this.investments,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionError: subscriptionError,
    );
  }
}
