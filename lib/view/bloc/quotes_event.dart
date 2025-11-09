import '../../data/data_models.dart';
import '../models/client_info.dart';

abstract class QuoteEvent {}

class InitQuote extends QuoteEvent {}

class UpdateClientInfo extends QuoteEvent {
  final ClientInfo client;
  UpdateClientInfo(this.client);
}

class AddEmptyItem extends QuoteEvent {}

class UpdateItemAt extends QuoteEvent {
  final int index;
  final LineItem item;
  UpdateItemAt(this.index, this.item);
}

class RemoveItemAt extends QuoteEvent {
  final int index;
  RemoveItemAt(this.index);
}

class ToggleTaxMode extends QuoteEvent {
  final bool taxInclusive;
  ToggleTaxMode(this.taxInclusive);
}

class ChangeCurrency extends QuoteEvent {
  final String currencyCode;
  ChangeCurrency(this.currencyCode);
}

class ChangeStatus extends QuoteEvent {
  final String status;
  ChangeStatus(this.status);
}

class SaveQuoteLocally extends QuoteEvent {}

class LoadLastQuote extends QuoteEvent {}