/// Representa una transacción (suscripción o cancelación) de un fondo.
class Transaction {
  final String id;
  final String type; // 'SUBSCRIPTION' | 'CANCELLATION'
  final int fundId;
  final String fundName;
  final double amount;
  final DateTime date;
  final String notificationMethod; // 'EMAIL' | 'SMS'

  const Transaction({
    required this.id,
    required this.type,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.notificationMethod,
  });
}
