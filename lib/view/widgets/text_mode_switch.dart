// lib/presentation/widgets/tax_mode_switch.dart
import 'package:flutter/material.dart';

class TaxModeSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TaxModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value ? 'Tax Inclusive' : 'Tax Exclusive',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged, // expects (bool) → OK
        ),
      ],
    );
  }
}
