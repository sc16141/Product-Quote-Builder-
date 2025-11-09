import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meru_flutter/view/bloc/quotes_event.dart';
import 'package:meru_flutter/view/bloc/quotes_state.dart';

import '../../data/data_models.dart';
import '../models/client_info.dart';
import '../models/qeotes.dart';
import '../widgets/quets.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteLocalStore localStore;

  QuoteBloc(this.localStore)
      : super(QuoteState(quote: Quote(client: ClientInfo(), items: [LineItem(name: '', quantity: 1, rate: 0)]))) {


    on<InitQuote>((e, emit) async {

      emit(state.copyWith(isLoaded: true));
    });

    on<UpdateClientInfo>((e, emit) {
      emit(state.copyWith(quote: state.quote.copyWith(client: e.client)));
    });

    on<AddEmptyItem>((e, emit) {
      final items = [...state.quote.items, LineItem(name: '', quantity: 1, rate: 0)];
      emit(state.copyWith(quote: state.quote.copyWith(items: items)));
    });

    on<UpdateItemAt>((e, emit) {
      final items = [...state.quote.items];
      if (e.index >= 0 && e.index < items.length) {
        items[e.index] = e.item;
      }
      emit(state.copyWith(quote: state.quote.copyWith(items: items)));
    });

    on<RemoveItemAt>((e, emit) {
      final items = [...state.quote.items]..removeAt(e.index);
      emit(state.copyWith(quote: state.quote.copyWith(items: items)));
    });

    on<ToggleTaxMode>((e, emit) {
      emit(state.copyWith(quote: state.quote.copyWith(taxInclusive: e.taxInclusive)));
    });

    on<ChangeCurrency>((e, emit) {
      emit(state.copyWith(quote: state.quote.copyWith(currencyCode: e.currencyCode)));
    });

    on<ChangeStatus>((e, emit) {
      emit(state.copyWith(quote: state.quote.copyWith(status: e.status)));
    });

    on<SaveQuoteLocally>((e, emit) async {
      emit(state.copyWith(isSaving: true));
      await localStore.save(state.quote);
      emit(state.copyWith(isSaving: false));
    });

    // Puraana save kiya hua quote load karna
    on<LoadLastQuote>((e, emit) async {
      final q = await localStore.load();
      if (q != null) {
        emit(state.copyWith(quote: q, isLoaded: true));
      }
    });
  }
}