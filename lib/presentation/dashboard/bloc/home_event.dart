import 'package:btgproject/domain/entities/fund.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class HomeLoadRequested extends HomeEvent {}

class HomeCategoryChanged extends HomeEvent {
  final String category;

  const HomeCategoryChanged(this.category);
}

class SubscribeToFund extends HomeEvent {
  final Fund fund;
  final double amount;
  final String notificationMethod; // 'EMAIL' | 'SMS'

  const SubscribeToFund({
    required this.fund,
    required this.amount,
    required this.notificationMethod,
  });
}

/// Resetea el estado de suscripción a idle.
class ResetSubscriptionStatus extends HomeEvent {}
