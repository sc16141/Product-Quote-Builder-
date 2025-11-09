import '../../data/data_models.dart';
import 'client_info.dart';

class Quote {
  final ClientInfo client;
  final List<LineItem> items;
  final bool taxInclusive;
  final String currencyCode;
  final String status;

  Quote({
    required this.client,
    required this.items,
    this.taxInclusive = false,
    this.currencyCode = 'INR',
    this.status = 'Draft',
  });


  double get subTotalBeforeTax {
    // Is calculation se farak nahi padta ki mode inclusive hai ya exclusive,
    // yeh hamesha sahi Subtotal dega (GrandTotal - Tax = Subtotal).
    return grandTotal - totalTax;
  }




  /// Kul tax ki rakam.
  double get totalTax =>
      items.fold(0, (s, i) => s + i.taxAmount(taxInclusive: taxInclusive));

  /// Kul keemat (Tax jodne ke baad).
  double get grandTotal {
    if (taxInclusive) {
      // 'total' method in LineItem pehle se hi inclusive mode ko handle karta hai
      return items.fold(0, (s, i) => s + i.total(taxInclusive: true));
    } else {
      // 'total' method exclusive mode ko bhi handle karta hai
      return items.fold(0, (s, i) => s + i.total(taxInclusive: false));
    }
  }

  Quote copyWith({
    ClientInfo? client,
    List<LineItem>? items,
    bool? taxInclusive,
    String? currencyCode,
    String? status,
  }) {
    return Quote(
      client: client ?? this.client,
      items: items ?? this.items,
      taxInclusive: taxInclusive ?? this.taxInclusive,
      currencyCode: currencyCode ?? this.currencyCode,
      status: status ?? this.status,
    );
  }
}