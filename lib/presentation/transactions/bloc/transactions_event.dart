sealed class TransactionsEvent {
  const TransactionsEvent();
}

class TransactionsLoadRequested extends TransactionsEvent {}

class TransactionsFilterChanged extends TransactionsEvent {
  final String filter; // 'Todas' | 'Suscripciones' | 'Cancelaciones'

  const TransactionsFilterChanged(this.filter);
}
