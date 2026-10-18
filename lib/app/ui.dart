import 'package:flutter/material.dart';

import '../data/repository.dart';
import 'format.dart';
import 'widgets.dart';

/// Runs [action] and tells the user if a rule said no. Returns true when it
/// went through.
Future<bool> attempt(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } on RuleException catch (e) {
    if (context.mounted) await showProblems(context, e.problems);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
  return false;
}

Future<void> showProblems(BuildContext context, List<String> problems) {
  final l = context.l10n;
  return showDialog<void>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(l.notYet),
      content: Text(problems.join('\n')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialog), child: Text(l.ok)),
      ],
    ),
  );
}

Future<bool> confirm(BuildContext context, String question) async {
  final l = context.l10n;
  final yes = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      content: Text(question),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialog, true),
          child: Text(l.yes),
        ),
      ],
    ),
  );
  return yes ?? false;
}

/// A calendar date (no time), at local midnight. Returns UTC.
Future<DateTime?> pickDate(BuildContext context, DateTime? initial) async {
  final start = (initial ?? DateTime.now()).toLocal();
  final date = await showDatePicker(
    context: context,
    initialDate: start,
    firstDate: DateTime(1990),
    lastDate: DateTime(2100),
  );
  return date == null
      ? null
      : DateTime(date.year, date.month, date.day).toUtc();
}

/// Date then time, in local time. Returns UTC.
Future<DateTime?> pickDateTime(BuildContext context, DateTime? initial) async {
  final start = (initial ?? DateTime.now()).toLocal();
  final date = await showDatePicker(
    context: context,
    initialDate: start,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(start),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: child!,
    ),
  );
  if (time == null) return null;
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  ).toUtc();
}

/// A small black-and-white tag, e.g. "Overdue".
class Tag extends StatelessWidget {
  const Tag(this.label, {super.key, this.inverted = false});
  final String label;
  final bool inverted;

  @override
  Widget build(BuildContext context) =>
      StatusPill(label, tone: inverted ? PillTone.solid : PillTone.outline);
}

/// Label on the start side, value on the end side (flips in Arabic).
class AmountRow extends StatelessWidget {
  const AmountRow(this.label, this.value, {super.key, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Asks for a line (or with [multiline], a block) of text. Null when
/// cancelled. The dialog owns its controller, so nothing is disposed while
/// the closing animation still draws the field.
Future<String?> promptText(
  BuildContext context, {
  required String title,
  String? label,
  String? initial,
  bool multiline = false,
  Key? fieldKey,
  Key? saveKey,
}) => showDialog<String>(
  context: context,
  builder: (_) => _PromptDialog(
    title: title,
    label: label,
    initial: initial,
    multiline: multiline,
    fieldKey: fieldKey,
    saveKey: saveKey,
  ),
);

class _PromptDialog extends StatefulWidget {
  const _PromptDialog({
    required this.title,
    this.label,
    this.initial,
    this.multiline = false,
    this.fieldKey,
    this.saveKey,
  });
  final String title;
  final String? label;
  final String? initial;
  final bool multiline;
  final Key? fieldKey;
  final Key? saveKey;

  @override
  State<_PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        child: TextField(
          key: widget.fieldKey,
          controller: _c,
          autofocus: true,
          minLines: widget.multiline ? 4 : 1,
          maxLines: widget.multiline ? 10 : 1,
          decoration: InputDecoration(labelText: widget.label),
          onSubmitted: widget.multiline
              ? null
              : (v) => Navigator.pop(context, v),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: widget.saveKey,
          onPressed: () => Navigator.pop(context, _c.text),
          child: Text(l.save),
        ),
      ],
    );
  }
}
