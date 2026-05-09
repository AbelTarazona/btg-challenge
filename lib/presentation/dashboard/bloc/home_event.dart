sealed class HomeEvent {}

class HomeLoadRequested extends HomeEvent {}

class HomeCategoryChanged extends HomeEvent {
  final String category;

  HomeCategoryChanged(this.category);
}
