sealed class TransactionsEvent {}

class TransactionsLoadRequested extends TransactionsEvent {}

class TransactionsFilterChanged extends TransactionsEvent {
  final String filter; // 'Todas' | 'Suscripciones' | 'Cancelaciones'

  TransactionsFilterChanged(this.filter);
}
