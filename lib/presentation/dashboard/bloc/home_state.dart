import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/domain/entities/user.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  final HomeStatus status;
  final User? user;
  final List<Fund> funds;
  final String? errorMessage;
  final String selectedCategory;

  const HomeState({
    this.status = HomeStatus.initial,
    this.user,
    this.funds = const [],
    this.errorMessage,
    this.selectedCategory = 'Todos',
  });

  List<Fund> get filteredFunds {
    if (selectedCategory == 'Todos') return funds;
    return funds.where((f) => f.category == selectedCategory).toList();
  }

  HomeState copyWith({
    HomeStatus? status,
    User? user,
    List<Fund>? funds,
    String? errorMessage,
    String? selectedCategory,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
      funds: funds ?? this.funds,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
