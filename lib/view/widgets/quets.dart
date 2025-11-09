import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_models.dart';
import '../models/client_info.dart';
import '../models/qeotes.dart';

class QuoteLocalStore {
  Future<void> save(Quote q) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_quote', jsonEncode(_toMap(q)));
  }

  Future<Quote?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('last_quote');
    if (s == null) return null;
    return _fromMap(jsonDecode(s));
  }

  Map<String, dynamic> _toMap(Quote q) => {
    'client': {'name': q.client.name, 'address': q.client.address, 'reference': q.client.reference},
    'items': q.items.map((i) => {
      'name': i.name, 'qty': i.quantity, 'rate': i.rate, 'discount': i.discount, 'tax': i.taxPercent
    }).toList(),
    'taxInclusive': q.taxInclusive,
    'currency': q.currencyCode,
    'status': q.status,
  };

  Quote _fromMap(Map<String, dynamic> m) => Quote(
    client: ClientInfo(
      name: m['client']['name'] ?? '',
      address: m['client']['address'] ?? '',
      reference: m['client']['reference'] ?? '',
    ),
    items: (m['items'] as List).map((e) => LineItem(
      name: e['name'] ?? '', quantity: (e['qty'] ?? 0).toDouble(),
      rate: (e['rate'] ?? 0).toDouble(), discount: (e['discount'] ?? 0).toDouble(),
      taxPercent: (e['tax'] ?? 0).toDouble(),
    )).toList(),
    taxInclusive: m['taxInclusive'] ?? false,
    currencyCode: m['currency'] ?? 'INR',
    status: m['status'] ?? 'Draft',
  );
}
