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
}
