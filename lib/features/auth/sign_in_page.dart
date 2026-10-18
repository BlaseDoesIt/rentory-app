import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/format.dart';

/// Email and password against Supabase Auth. Each team member has their own
/// account; the first one ever created becomes the admin.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.client});
  final SupabaseClient client;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _message;

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
    } on AuthException catch (e) {
      setState(() => _message = e.message);
    } catch (e) {
      if (mounted) {
        setState(() => _message = context.l10n.serverUnreachable('$e'));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signIn() => _run(() async {
    await widget.client.auth.signInWithPassword(
      email: _email.text.trim(),
      password: _password.text,
    );
  });

  Future<void> _signUp() => _run(() async {
    final res = await widget.client.auth.signUp(
      email: _email.text.trim(),
      password: _password.text,
    );
    if (res.session == null && mounted) {
      setState(() => _message = context.l10n.accountCreated);
    }
  });

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Rentory', style: text.headlineMedium),
                  const SizedBox(height: 4),
                  Text(l.signInToTeam, style: text.bodyMedium),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: l.email),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(labelText: l.password),
                    onSubmitted: (_) => _busy ? null : _signIn(),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _signIn,
                    child: Text(l.signIn),
                  ),
                  TextButton(
                    onPressed: _busy ? null : _signUp,
                    child: Text(l.createAccount),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 12),
                    Text(_message!, textAlign: TextAlign.center),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
