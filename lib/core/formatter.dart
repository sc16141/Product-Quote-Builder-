

import 'package:intl/intl.dart';

NumberFormat currencyFormatter(String code) {
  return NumberFormat.simpleCurrency(name: code);
}
