import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';

typedef PickedCustomer = ({String id, String name, String? phone});

/// Search the customers, or add a new one. Returns the pick, or null.
Future<PickedCustomer?> pickCustomer(BuildContext context) =>
    showDialog<PickedCustomer>(
      context: context,
      builder: (_) => Services.of(context).wrap(const _CustomerDialog()),
    );

class _CustomerDialog extends StatefulWidget {
  const _CustomerDialog();

  @override
  State<_CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<_CustomerDialog> {
  final _search = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  Future<List<Customer>>? _results;
  bool _creating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _results ??= Services.of(context).repo.customers();
  }

  @override
  void dispose() {
    _search.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final repo = Services.of(context).repo;
    String? id;
    final ok = await attempt(context, () async {
      id = await repo.createCustomer(name: _name.text, phone: _phone.text);
    });
    if (!ok || !mounted) return;
    final phone = _phone.text.trim();
    Navigator.pop<PickedCustomer>(context, (
      id: id!,
      name: _name.text.trim(),
      phone: phone.isEmpty ? null : phone,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(_creating ? l.newCustomer : l.customer),
      content: SizedBox(
        width: 420,
        height: 420,
        child: _creating ? _form(l) : _list(l),
      ),
      actions: [
        TextButton(
          onPressed: () => _creating
              ? setState(() => _creating = false)
              : Navigator.pop(context),
          child: Text(_creating ? l.back : l.cancel),
        ),
        if (_creating)
          FilledButton(onPressed: _create, child: Text(l.save))
        else
          FilledButton.icon(
            icon: const Icon(Icons.person_add_alt),
            onPressed: () => setState(() {
              _creating = true;
              _name.text = _search.text;
            }),
            label: Text(l.newCustomer),
          ),
      ],
    );
  }

  Widget _form(AppLocalizations l) => Column(
    children: [
      TextField(
        key: const Key('customer-name'),
        controller: _name,
        autofocus: true,
        decoration: InputDecoration(labelText: l.name),
      ),
      const SizedBox(height: 8),
      TextField(
        key: const Key('customer-phone'),
        controller: _phone,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(labelText: l.phone),
      ),
    ],
  );

  Widget _list(AppLocalizations l) => Column(
    children: [
      TextField(
        controller: _search,
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: l.searchCustomers,
        ),
        onChanged: (v) {
          final next = Services.of(context).repo.customers(search: v);
          setState(() {
            _results = next;
          });
        },
      ),
      Expanded(
        child: FutureBuilder<List<Customer>>(
          future: _results,
          builder: (context, snap) {
            final list = snap.data;
            if (list == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (list.isEmpty) return Center(child: Text(l.noCustomers));
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final c = list[i];
                return ListTile(
                  title: Text(c.name),
                  subtitle: c.phone == null
                      ? null
                      : Text(c.phone!, textDirection: TextDirection.ltr),
                  onTap: () => Navigator.pop<PickedCustomer>(context, (
                    id: c.id,
                    name: c.name,
                    phone: c.phone,
                  )),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}
