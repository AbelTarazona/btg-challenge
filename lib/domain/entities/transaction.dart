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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          fundId == other.fundId &&
          fundName == other.fundName &&
          amount == other.amount &&
          date == other.date &&
          notificationMethod == other.notificationMethod;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      fundId.hashCode ^
      fundName.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      notificationMethod.hashCode;
}
