class LineItem {
  final String name;
  final double quantity;   // allow decimals if needed
  final double rate;
  final double discount;   // flat discount per unit (optional)
  final double taxPercent; // e.g., 18 for 18%

  LineItem({
    required this.name,
    required this.quantity,
    required this.rate,
    this.discount = 0,
    this.taxPercent = 0,
  });

  double get netUnit => (rate - discount).clamp(0, double.infinity);
  double get amountBeforeTax => netUnit * quantity;

  double taxAmount({required bool taxInclusive}) {
    if (taxInclusive) {
      // price includes tax → back out tax: amountBeforeTax - (amountBeforeTax / (1 + t))
      final t = (taxPercent / 100);
      return amountBeforeTax - (amountBeforeTax / (1 + t));
    } else {
      // add-on tax
      return amountBeforeTax * (taxPercent / 100);
    }
  }

  double total({required bool taxInclusive}) {
    if (taxInclusive) {
      // already included in rate, so total is amountBeforeTax (which is gross)
      return amountBeforeTax;
    } else {
      return amountBeforeTax + taxAmount(taxInclusive: false);
    }
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
