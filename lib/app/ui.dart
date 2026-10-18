import 'package:flutter/material.dart';

import '../data/repository.dart';
import 'format.dart';

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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = inverted ? scheme.onPrimary : scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: inverted ? scheme.primary : null,
        border: Border.all(color: scheme.primary),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
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
