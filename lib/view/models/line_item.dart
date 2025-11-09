class LineItem {
  final String name;
  final double quantity;
  final double rate;
  final double discount;
  final double taxPercent;

  const LineItem({
    required this.name,
    required this.quantity,
    required this.rate,
    this.discount = 0,
    this.taxPercent = 0,
  });

  double get netUnit => (rate - discount).clamp(0, double.infinity);
  double get amountBeforeTax => netUnit * quantity;

  double taxAmount({required bool taxInclusive}) {
    final t = taxPercent / 100.0;
    if (taxInclusive) {
      return amountBeforeTax - (amountBeforeTax / (1 + t));
    } else {
      return amountBeforeTax * t;
    }
  }

  double total({required bool taxInclusive}) {
    return taxInclusive
        ? amountBeforeTax
        : amountBeforeTax + taxAmount(taxInclusive: false);
  }

  LineItem copyWith({
    String? name,
    double? quantity,
    double? rate,
    double? discount,
    double? taxPercent,
  }) => LineItem(
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    rate: rate ?? this.rate,
    discount: discount ?? this.discount,
    taxPercent: taxPercent ?? this.taxPercent,
  );
}
