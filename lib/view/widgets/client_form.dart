import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_event.dart';
import '../models/client_info.dart';

class ClientForm extends StatefulWidget {
  const ClientForm({super.key});
  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final nameCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final refCtrl  = TextEditingController();

  @override
  void dispose() { nameCtrl.dispose(); addrCtrl.dispose(); refCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Client Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          SizedBox(height: 20,),
          TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'Address')),
          SizedBox(height: 20,),

          TextField(controller: refCtrl,  decoration: const InputDecoration(labelText: 'Reference')),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () {
                context.read<QuoteBloc>().add(UpdateClientInfo(
                  ClientInfo(name: nameCtrl.text, address: addrCtrl.text, reference: refCtrl.text),
                ));
              },
              child: const Text('Update'),
            ),
          )
        ]),
      ),
    );
  }
}
