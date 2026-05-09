import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/user.dart';

enum FundsStatus { initial, loading, success, error }

enum CancellationStatus { idle, loading, success, error }

class FundsState {
  final FundsStatus status;
  final User? user;
  final List<Investment> investments;
  final String? errorMessage;
  final CancellationStatus cancellationStatus;
  final String? cancellationError;
  final String? cancellingInvestmentId;

  const FundsState({
    this.status = FundsStatus.initial,
    this.user,
    this.investments = const [],
    this.errorMessage,
    this.cancellationStatus = CancellationStatus.idle,
    this.cancellationError,
    this.cancellingInvestmentId,
  });

  FundsState copyWith({
    FundsStatus? status,
    User? user,
    List<Investment>? investments,
    String? errorMessage,
    CancellationStatus? cancellationStatus,
    String? cancellationError,
    String? cancellingInvestmentId,
  }) {
    return FundsState(
      status: status ?? this.status,
      user: user ?? this.user,
      investments: investments ?? this.investments,
      errorMessage: errorMessage ?? this.errorMessage,
      cancellationStatus: cancellationStatus ?? this.cancellationStatus,
      cancellationError: cancellationError,
      cancellingInvestmentId: cancellingInvestmentId,
    );
  }
}
