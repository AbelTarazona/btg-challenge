import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/domain/entities/transaction.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/domain/repositories/fund_repository.dart';
import 'package:btgproject/domain/repositories/investment_repository.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FundRepository _fundRepository;
  final UserRepository _userRepository;
  final InvestmentRepository _investmentRepository;
  final TransactionRepository _transactionRepository;

  HomeBloc({
    required FundRepository fundRepository,
    required UserRepository userRepository,
    required InvestmentRepository investmentRepository,
    required TransactionRepository transactionRepository,
  })  : _fundRepository = fundRepository,
        _userRepository = userRepository,
        _investmentRepository = investmentRepository,
        _transactionRepository = transactionRepository,
        super(const HomeState()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeCategoryChanged>(_onCategoryChanged);
    on<SubscribeToFund>(_onSubscribe);
    on<ResetSubscriptionStatus>(_onResetSubscription);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Carga en paralelo para mejor rendimiento
      final results = await Future.wait([
        _userRepository.getUser(),
        _fundRepository.getFunds(),
        _investmentRepository.getInvestments(),
      ]);

      final user = results[0] as User;
      final funds = results[1] as List;
      final investments = results[2] as List;

      emit(state.copyWith(
        status: HomeStatus.success,
        user: user,
        funds: List.from(funds),
        investments: List.from(investments),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'No se pudieron cargar los datos. Intenta de nuevo.',
      ));
    }
  }

  void _onCategoryChanged(
    HomeCategoryChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  Future<void> _onSubscribe(
    SubscribeToFund event,
    Emitter<HomeState> emit,
  ) async {
    final user = state.user;
    if (user == null) return;

    // Validar monto mínimo
    if (event.amount < event.fund.minimumAmount) {
      emit(state.copyWith(
        subscriptionStatus: SubscriptionStatus.error,
        subscriptionError:
            'El monto mínimo para este fondo es \$${event.fund.minimumAmount.toInt()}',
      ));
      return;
    }

    // Validar saldo suficiente
    if (event.amount > user.availableBalance) {
      emit(state.copyWith(
        subscriptionStatus: SubscriptionStatus.error,
        subscriptionError:
            'No tiene saldo disponible para vincularse al fondo ${event.fund.name}',
      ));
      return;
    }

    emit(state.copyWith(subscriptionStatus: SubscriptionStatus.loading));

    try {
      final newBalance = user.availableBalance - event.amount;
      final investmentId =
          'INV-${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      // Crear inversión
      final investment = Investment(
        id: investmentId,
        fundId: event.fund.id,
        fundName: event.fund.name,
        amount: event.amount,
        subscriptionDate: now,
        notificationMethod: event.notificationMethod,
      );

      // Crear transacción
      final transaction = Transaction(
        id: 'TX-${now.millisecondsSinceEpoch}',
        type: 'SUBSCRIPTION',
        fundId: event.fund.id,
        fundName: event.fund.name,
        amount: event.amount,
        date: now,
        notificationMethod: event.notificationMethod,
      );

      // Ejecutar operaciones
      await _investmentRepository.subscribe(investment);
      await _transactionRepository.addTransaction(transaction);
      await _userRepository.updateBalance(newBalance);

      // Recargar datos actualizados
      final updatedUser = await _userRepository.getUser();
      final updatedInvestments = await _investmentRepository.getInvestments();

      emit(state.copyWith(
        subscriptionStatus: SubscriptionStatus.success,
        user: updatedUser,
        investments: updatedInvestments,
      ));
    } catch (e) {
      emit(state.copyWith(
        subscriptionStatus: SubscriptionStatus.error,
        subscriptionError: 'Error al procesar la suscripción. Intenta de nuevo.',
      ));
    }
  }

  void _onResetSubscription(
    ResetSubscriptionStatus event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(subscriptionStatus: SubscriptionStatus.idle));
  }
}
