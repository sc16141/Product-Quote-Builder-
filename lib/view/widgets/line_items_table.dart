import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_event.dart';
import '../bloc/quotes_state.dart';
import 'client_item_row.dart';

class LineItemsTable extends StatelessWidget {
  const LineItemsTable();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Line Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  FilledButton.icon(
                    onPressed: () => context.read<QuoteBloc>().add(AddEmptyItem()),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Row'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(
                state.quote.items.length,
                    (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: LineItemRow(index: i, item: state.quote.items[i]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
