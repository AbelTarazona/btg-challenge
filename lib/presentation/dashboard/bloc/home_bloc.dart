import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btgproject/domain/repositories/fund_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FundRepository _fundRepository;
  final UserRepository _userRepository;

  HomeBloc({
    required FundRepository fundRepository,
    required UserRepository userRepository,
  })  : _fundRepository = fundRepository,
        _userRepository = userRepository,
        super(const HomeState()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeCategoryChanged>(_onCategoryChanged);
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
      ]);

      final user = results[0] as dynamic;
      final funds = results[1] as List;

      emit(state.copyWith(
        status: HomeStatus.success,
        user: user,
        funds: List.from(funds),
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
}
