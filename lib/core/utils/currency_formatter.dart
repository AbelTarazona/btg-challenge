/// Formatea valores monetarios en formato COP colombiano.
///
/// Ejemplo: 75000.0 → "\$75.000"
class CurrencyFormatter {
  static String formatCOP(double amount) {
    final intValue = amount.toInt();
    final formatted = _addThousandsSeparator(intValue);
    return '\$$formatted';
  }

  static String _addThousandsSeparator(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
