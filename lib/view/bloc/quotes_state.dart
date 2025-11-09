import '../models/qeotes.dart';

class QuoteState  {
  final Quote quote;
  final bool isSaving;
  final bool isLoaded;

  QuoteState({
    required this.quote,
    this.isSaving = false,
    this.isLoaded = false,
  });

  double get subTotal => quote.subTotalBeforeTax;
  double get tax => quote.totalTax;
  double get grandTotal => quote.grandTotal;

  QuoteState copyWith({
    Quote? quote,
    bool? isSaving,
    bool? isLoaded,
  }) {
    return QuoteState(
      quote: quote ?? this.quote,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }


}