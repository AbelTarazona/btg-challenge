/// Representa una inversión activa del usuario en un fondo.
class Investment {
  final String id;
  final int fundId;
  final String fundName;
  final double amount;
  final DateTime subscriptionDate;
  final String notificationMethod; // 'EMAIL' | 'SMS'

  const Investment({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.subscriptionDate,
    required this.notificationMethod,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Investment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fundId == other.fundId &&
          fundName == other.fundName &&
          amount == other.amount &&
          subscriptionDate == other.subscriptionDate &&
          notificationMethod == other.notificationMethod;

  @override
  int get hashCode =>
      id.hashCode ^
      fundId.hashCode ^
      fundName.hashCode ^
      amount.hashCode ^
      subscriptionDate.hashCode ^
      notificationMethod.hashCode;
}
