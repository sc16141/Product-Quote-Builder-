
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meru_flutter/view/screens/preview_screen.dart';

import '../../core/formatter.dart';
import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_event.dart';
import '../bloc/quotes_state.dart';
import '../widgets/client_form.dart';
import '../widgets/line_items_table.dart';
import '../widgets/text_mode_switch.dart';

class QuoteFormScreen extends StatelessWidget {
  const QuoteFormScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Quote Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<QuoteBloc>(),
                  child: const QuotePreviewScreen(),
                ),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _FormPane()),
                const SizedBox(width: 16),
                Expanded(child: _TotalsPane()), // sticky-like on wide
              ],
            )
                :
            ListView(
              children: const [
                _FormPane(),
                SizedBox(height: 12),
                _TotalsPane(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<QuoteBloc>().add(SaveQuoteLocally()),
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}

class _FormPane extends StatelessWidget {
  const _FormPane({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      children: const [
        ClientForm(),
        SizedBox(height: 12),
        LineItemsTable(),
      ],
    );
  }
}

class _TotalsPane extends StatelessWidget {
  const _TotalsPane({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            final f = currencyFormatter(state.quote.currencyCode);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TaxModeSwitch(value: state.quote.taxInclusive, onChanged: (v) {
                  context.read<QuoteBloc>().add(ToggleTaxMode(v));
                }),
                const Divider(),
                _row('Subtotal', f.format(state.subTotal)),
                _row('Tax', f.format(state.tax)),
                const Divider(),
                _row('Grand Total', f.format(state.grandTotal), isBold: true),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        // ✅ फिक्स: यहाँ भी BlocProvider.value का उपयोग करें
                        // ताकि यह सही BLoC को पास करे
                        value: context.read<QuoteBloc>(),
                        child: const QuotePreviewScreen(),
                      ),
                    ),
                  ),
                  child: const Text('Preview'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
            isBold ? const TextStyle(fontWeight: FontWeight.w600) : null),
        Text(value,
            style:
            isBold ? const TextStyle(fontWeight: FontWeight.w600) : null),
      ],
    ),
  );
}