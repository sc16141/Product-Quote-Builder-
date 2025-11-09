import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_models.dart';
import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_event.dart';

class LineItemRow extends StatelessWidget {
  final int index;
  final LineItem item;
  const LineItemRow({super.key, required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    LineItem temp = item; // local mutable copy

    InputDecoration deco(String label) => InputDecoration(
        labelText: label, border: const OutlineInputBorder());

    void pushUpdate() => context.read<QuoteBloc>().add(UpdateItemAt(index, temp));

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: temp.name,
            decoration: deco('Product/Service'),
            onChanged: (v) { temp = temp.copyWith(name: v); pushUpdate(); },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: '${temp.quantity}',
            keyboardType: TextInputType.number,
            decoration: deco('Qty'),
            onChanged: (v) { temp = temp.copyWith(quantity: double.tryParse(v) ?? 0); pushUpdate(); },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: '${temp.rate}',
            keyboardType: TextInputType.number,
            decoration: deco('Rate'),
            onChanged: (v) { temp = temp.copyWith(rate: double.tryParse(v) ?? 0); pushUpdate(); },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: '${temp.discount}',
            keyboardType: TextInputType.number,
            decoration: deco('Discount'),
            onChanged: (v) { temp = temp.copyWith(discount: double.tryParse(v) ?? 0); pushUpdate(); },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: '${temp.taxPercent}',
            keyboardType: TextInputType.number,
            decoration: deco('Tax %'),
            onChanged: (v) { temp = temp.copyWith(taxPercent: double.tryParse(v) ?? 0); pushUpdate(); },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => context.read<QuoteBloc>().add(RemoveItemAt(index)),
        ),
      ],
    );
  }
}
