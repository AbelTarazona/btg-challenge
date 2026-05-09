sealed class FundsEvent {}

class FundsLoadRequested extends FundsEvent {}

class CancelInvestment extends FundsEvent {
  final String investmentId;
  final double amount;

  CancelInvestment({required this.investmentId, required this.amount});
}

/// Resetea el estado de cancelación a idle.
class ResetCancellationStatus extends FundsEvent {}
