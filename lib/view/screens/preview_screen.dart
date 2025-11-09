import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/formatter.dart';
import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_state.dart';

class QuotePreviewScreen extends StatelessWidget {
  const QuotePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quote Preview')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, state) {
                  final q = state.quote;
                  final f = currencyFormatter(q.currencyCode);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Quotation', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(q.status, style: const TextStyle(fontStyle: FontStyle.italic)),
                      const Divider(height: 32),
                      Text('Client: ${q.client.name}'),
                      Text(q.client.address),
                      Text('Ref: ${q.client.reference}'),
                      const SizedBox(height: 16),
                      const Divider(),
                      // Table-like list:
                      ...q.items.asMap().entries.map((e) {
                        final i = e.key; final it = e.value;
                        final total = it.total(taxInclusive: q.taxInclusive);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text('${i+1}. ${it.name}')),
                              Expanded(child: Text('${it.quantity}')),
                              Expanded(child: Text(f.format(it.rate))),
                              Expanded(child: Text(f.format(it.discount))),
                              Expanded(child: Text('${it.taxPercent}%')),
                              Expanded(child: Text(f.format(total), textAlign: TextAlign.end)),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _sumRow('Subtotal', f.format(state.subTotal)),
                            _sumRow('Tax',      f.format(state.tax)),
                            const SizedBox(height: 8),
                            _sumRow('Grand Total', f.format(state.grandTotal), bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // simulate send
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Quote sent (simulated).')),
                              );
                            },
                            child: const Text('Send'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: () {
                              // You can integrate printing / pdf later
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ready to print.')),
                              );
                            },
                            child: const Text('Print'),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sumRow(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null),
        const SizedBox(width: 12),
        Text(value, style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null),
      ],
    ),
  );
}

