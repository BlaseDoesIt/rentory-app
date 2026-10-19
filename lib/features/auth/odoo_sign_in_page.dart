import 'package:flutter/material.dart';

import '../../app/backend_choice.dart';
import '../../app/format.dart';
import '../../app/widgets.dart';
import '../../data/odoo/odoo_client.dart';

/// Odoo address, database and the person's own API key. Odoo is asked who
/// the key belongs to and whether Rentory is there before anything is kept.
class OdooSignInPage extends StatefulWidget {
  const OdooSignInPage({super.key, required this.backend});
  final BackendController backend;

  @override
  State<OdooSignInPage> createState() => _OdooSignInPageState();
}

class _OdooSignInPageState extends State<OdooSignInPage> {
  late final _url = TextEditingController(text: widget.backend.draft?.url);
  late final _db = TextEditingController(text: widget.backend.draft?.database);
  late final _key = TextEditingController(text: widget.backend.draft?.apiKey);
  bool _busy = false;
  String? _message;

  Future<void> _connect() async {
    final l = context.l10n;
    final url = OdooCredentials.cleanUrl(_url.text);
    var db = _db.text.trim();
    final key = _key.text.trim();
    if (url.isEmpty || key.isEmpty) {
      setState(() => _message = l.odooFillAll);
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    OdooClient? client;
    try {
      if (db.isEmpty) {
        // odoo.sh lists its one database; fill it in rather than ask.
        final found = await OdooClient.databases(url);
        if (found.length != 1) {
          if (mounted) setState(() => _message = l.odooFillAll);
          return;
        }
        db = found.single;
        _db.text = db;
      }
      _url.text = url;
      final credentials = OdooCredentials(url: url, database: db, apiKey: key);
      client = OdooClient(credentials, timeout: const Duration(seconds: 30));
      final user = await client.whoAmI();
      try {
        await client.checkRentory();
      } on OdooException {
        if (mounted) setState(() => _message = l.odooNoRentory);
        return;
      }
      await widget.backend.signInToOdoo(credentials, user.name);
    } on OdooException catch (e) {
      if (mounted) {
        setState(
          () => _message = e.status == 401 || e.status == 404
              ? '${l.odooBadKey}\n${e.message}'
              : e.message,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _message = l.serverUnreachable('$e'));
    } finally {
      client?.close();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _url.dispose();
    _db.dispose();
    _key.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l = context.l10n;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: BrandMark(size: 72),
                ),
                const SizedBox(height: 20),
                Text(l.connectToOdoo, style: text.headlineMedium),
                const SizedBox(height: 4),
                Text(l.odooSignInHint, style: text.bodyMedium),
                const SizedBox(height: 24),
                TextField(
                  key: const Key('odoo-url'),
                  controller: _url,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l.odooUrl,
                    hintText: 'https://example.odoo.com',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('odoo-db'),
                  controller: _db,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: l.odooDatabase),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('odoo-key'),
                  controller: _key,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(labelText: l.odooApiKey),
                  onSubmitted: (_) => _busy ? null : _connect(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  key: const Key('odoo-connect'),
                  onPressed: _busy ? null : _connect,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l.connect),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => widget.backend.choose(BackendKind.supabase),
                  child: Text(l.useSupabaseInstead),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 12),
                  SelectableText(_message!, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
