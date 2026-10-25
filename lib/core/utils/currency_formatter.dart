class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount) => "\$${amount.toStringAsFixed(2)}";

  /// Bangladeshi Taka — `৳2,500` (decimals only when there are any).
  static String taka(num amount) {
    final hasFraction = amount % 1 != 0;
    final fixed = amount.toStringAsFixed(hasFraction ? 2 : 0);
    final parts = fixed.split('.');
    final whole = parts.first.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
    return '৳$whole${parts.length > 1 ? '.${parts[1]}' : ''}';
  }
}
