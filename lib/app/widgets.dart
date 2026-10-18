import 'package:flutter/material.dart';

import 'theme.dart';

/// Keeps content at a readable width on a big PC screen.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.max = 960});
  final Widget child;
  final double max;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    // As tall as the content, so it also works inside a bottom bar.
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: max),
      child: child,
    ),
  );
}

/// The big title at the top of a tab.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  AnimatedSwitcher(
                    duration: Mono.fast,
                    child: Text(
                      subtitle!,
                      key: ValueKey(subtitle),
                      style: text.bodyMedium?.copyWith(color: muted),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A titled white card, the building block of detail pages.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!.toUpperCase(),
                        style: text.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}

enum PillTone {
  /// Black fill: needs attention or is out.
  solid,

  /// Outline: committed, waiting.
  outline,

  /// Grey: settled or not started.
  muted,
}

class StatusPill extends StatelessWidget {
  const StatusPill(
    this.label, {
    super.key,
    this.tone = PillTone.outline,
    this.icon,
  });
  final String label;
  final PillTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg, border) = switch (tone) {
      PillTone.solid => (scheme.primary, scheme.onPrimary, scheme.primary),
      PillTone.outline => (Colors.transparent, scheme.primary, scheme.primary),
      PillTone.muted => (
        scheme.surfaceContainer,
        scheme.onSurfaceVariant,
        scheme.surfaceContainer,
      ),
    };
    return AnimatedContainer(
      duration: Mono.fast,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// A number with a label, tappable as a filter.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.selected = false,
    this.compact = false,
    this.onTap,
  });
  final String label;
  final String value;
  final IconData icon;
  final bool selected;

  /// One row (number and label beside the icon), for phones.
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurface;
    final sub = selected ? scheme.onPrimary : scheme.onSurfaceVariant;
    // Counts up to its value when it changes.
    final number = TweenAnimationBuilder<double>(
      tween: Tween(end: double.tryParse(value) ?? 0),
      duration: Mono.medium,
      curve: Mono.ease,
      builder: (context, v, _) => Text(
        double.tryParse(value) == null ? value : '${v.round()}',
        style: (compact ? text.titleLarge : text.headlineSmall)?.copyWith(
          color: fg,
        ),
      ),
    );
    final caption = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: text.bodySmall?.copyWith(color: sub),
    );
    return AnimatedContainer(
      duration: Mono.medium,
      curve: Mono.ease,
      decoration: BoxDecoration(
        color: selected ? null : scheme.surface,
        gradient: selected ? Mono.ink(context) : null,
        borderRadius: BorderRadius.circular(Mono.radius),
        border: Border.all(
          color: selected ? Colors.transparent : scheme.outline,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(Mono.radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: compact
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [number, caption],
                        ),
                      ),
                      Icon(icon, size: 20, color: sub),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 20, color: sub),
                      const SizedBox(height: 10),
                      number,
                      caption,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 4),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// Fades and lifts a list item in, a little later for each [index], so a
/// list arrives as a quick cascade instead of all at once.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.index, required this.child});
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final delay = (index.clamp(0, 8)) * 0.06;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 360 + (delay * 1000).round()),
      curve: Interval(delay / (0.36 + delay), 1, curve: Mono.ease),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 14),
          child: child,
        ),
      ),
    );
  }
}

/// A round monogram for a person or company.
class Monogram extends StatelessWidget {
  const Monogram(this.name, {super.key, this.size = 40});
  final String name;
  final double size;

  static String initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    final first = words.first.characters.first;
    final second = words.length > 1 ? words[1].characters.first : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: Mono.soft(context),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials(name),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}

/// A small label over a value, e.g. "Start / 21 Oct, 09:00".
class LabeledValue extends StatelessWidget {
  const LabeledValue({
    super.key,
    required this.label,
    required this.value,
    this.end = false,
  });
  final String label;
  final String value;
  final bool end;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: text.titleSmall),
      ],
    );
  }
}

/// The Rentory logo (a box with a key) on a white rounded tile, so the
/// black line art reads the same in light and dark mode.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 36});
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(color: scheme.outline),
      ),
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'Rentory',
      ),
    );
  }
}

/// The bar at the bottom of a task page holding its main button.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: ContentWidth(max: 720, child: child),
        ),
      ),
    );
  }
}

/// A framed dropdown: a raised panel with a border, each option in its own
/// thin frame. Use instead of DropdownButton everywhere.
class MonoDropdown<T> extends StatelessWidget {
  const MonoDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    this.leading,
  });
  final String label;
  final T value;
  final List<(T, String)> options;
  final ValueChanged<T?> onSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final frame = dark ? const Color(0xFF3A3A3A) : const Color(0xFFD4D4D4);
    final item = ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: frame.withValues(alpha: 0.7)),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.hovered) || s.contains(WidgetState.focused)
            ? scheme.onSurface.withValues(alpha: 0.08)
            : scheme.surface,
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
    return DropdownMenu<T>(
      // Rebuilt when the value changes from outside.
      key: ValueKey(value),
      initialSelection: value,
      label: Text(label),
      leadingIcon: leading,
      expandedInsets: EdgeInsets.zero,
      requestFocusOnTap: false,
      onSelected: onSelected,
      dropdownMenuEntries: [
        for (final (v, text) in options)
          DropdownMenuEntry<T>(value: v, label: text, style: item),
      ],
    );
  }
}

/// Two fields side by side, or stacked when the screen is narrow.
class FieldPair extends StatelessWidget {
  const FieldPair(this.first, this.second, {super.key});
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => box.maxWidth < 420
        ? Column(children: [first, const SizedBox(height: 12), second])
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: first),
              const SizedBox(width: 12),
              Expanded(child: second),
            ],
          ),
  );
}
