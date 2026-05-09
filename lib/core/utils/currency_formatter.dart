import 'package:intl/intl.dart';

/// Formatea valores monetarios en formato COP colombiano.
///
/// Ejemplo: 500000.0 → "$ 500.000"
class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  static String formatCOP(double amount) {
    return _formatter.format(amount);
  }
}
