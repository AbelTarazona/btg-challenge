import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/domain/repositories/investment_repository.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';

import 'funds_event.dart';
import 'funds_state.dart';

class FundsBloc extends Bloc<FundsEvent, FundsState> {
  final UserRepository _userRepository;
  final InvestmentRepository _investmentRepository;
  final TransactionRepository _transactionRepository;

  FundsBloc({
    required UserRepository userRepository,
    required InvestmentRepository investmentRepository,
    required TransactionRepository transactionRepository,
  })  : _userRepository = userRepository,
        _investmentRepository = investmentRepository,
        _transactionRepository = transactionRepository,
        super(const FundsState()) {
    on<FundsLoadRequested>(_onLoadRequested);
    on<CancelInvestment>(_onCancel);
    on<ResetCancellationStatus>(_onResetCancellation);
  }

  Future<void> _onLoadRequested(
    FundsLoadRequested event,
    Emitter<FundsState> emit,
  ) async {
    emit(state.copyWith(status: FundsStatus.loading));

    try {
      final results = await Future.wait([
        _userRepository.getUser(),
        _investmentRepository.getInvestments(),
      ]);

      final user = results[0] as User;
      final investments = results[1] as List;

      emit(state.copyWith(
        status: FundsStatus.success,
        user: user,
        investments: List.from(investments),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FundsStatus.error,
        errorMessage: 'No se pudieron cargar las inversiones.',
      ));
    }
  }

  Future<void> _onCancel(
    CancelInvestment event,
    Emitter<FundsState> emit,
  ) async {
    emit(state.copyWith(
      cancellationStatus: CancellationStatus.loading,
      cancellingInvestmentId: event.investmentId,
    ));

    try {
      final user = state.user!;
      final newBalance = user.availableBalance + event.amount;

      // Buscar la inversión para obtener datos de la transacción
      final investment =
          state.investments.firstWhere((inv) => inv.id == event.investmentId);

      // Crear transacción de cancelación
      final transaction = Transaction(
        id: 'TX-${DateTime.now().millisecondsSinceEpoch}',
        type: 'CANCELLATION',
        fundId: investment.fundId,
        fundName: investment.fundName,
        amount: investment.amount,
        date: DateTime.now(),
        notificationMethod: investment.notificationMethod,
      );

      // Ejecutar operaciones
      await _investmentRepository.cancel(event.investmentId);
      await _transactionRepository.addTransaction(transaction);
      await _userRepository.updateBalance(newBalance);

      // Recargar datos actualizados
      final updatedUser = await _userRepository.getUser();
      final updatedInvestments = await _investmentRepository.getInvestments();

      emit(state.copyWith(
        cancellationStatus: CancellationStatus.success,
        user: updatedUser,
        investments: updatedInvestments,
      ));
    } catch (e) {
      emit(state.copyWith(
        cancellationStatus: CancellationStatus.error,
        cancellationError: 'Error al cancelar la inversión.',
      ));
    }
  }

  void _onResetCancellation(
    ResetCancellationStatus event,
    Emitter<FundsState> emit,
  ) {
    emit(state.copyWith(cancellationStatus: CancellationStatus.idle));
  }
}
