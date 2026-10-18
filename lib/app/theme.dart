import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Black and white, matching blasedoesit.com: ink on paper, with a few soft
/// greys for structure. No colour anywhere; state is shown by weight,
/// fill and outline instead.
abstract final class Mono {
  static const radius = 16.0;
  static const radiusSmall = 12.0;
  static const ease = Curves.easeOutCubic;
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 280);
}

ThemeData rentoryTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final ink = dark ? Colors.white : Colors.black;
  final paper = dark ? Colors.black : Colors.white;
  final background = dark ? Colors.black : const Color(0xFFF5F5F5);
  final card = dark ? const Color(0xFF0F0F0F) : Colors.white;
  final raised = dark ? const Color(0xFF181818) : const Color(0xFFF0F0F0);
  final line = dark ? const Color(0xFF262626) : const Color(0xFFE4E4E4);
  final muted = dark ? const Color(0xFF9A9A9A) : const Color(0xFF6B6B6B);

  final scheme =
      ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      ).copyWith(
        primary: ink,
        onPrimary: paper,
        primaryContainer: ink,
        onPrimaryContainer: paper,
        secondary: ink,
        onSecondary: paper,
        secondaryContainer: raised,
        onSecondaryContainer: ink,
        surface: card,
        onSurface: ink,
        onSurfaceVariant: muted,
        surfaceContainerLowest: card,
        surfaceContainerLow: card,
        surfaceContainer: raised,
        surfaceContainerHigh: raised,
        surfaceContainerHighest: raised,
        outline: line,
        outlineVariant: line,
        error: ink,
        onError: paper,
        surfaceTint: Colors.transparent,
      );

  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    brightness: brightness,
  );
  final text = base.textTheme.copyWith(
    displaySmall: base.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -1,
    ),
    headlineMedium: base.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
    ),
    headlineSmall: base.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    titleLarge: base.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
    ),
    titleMedium: base.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    titleSmall: base.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    labelSmall: base.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
    ),
  );

  final rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Mono.radiusSmall),
  );
  const buttonSize = Size(64, 48);
  const buttonPadding = EdgeInsets.symmetric(horizontal: 20);

  return base.copyWith(
    scaffoldBackgroundColor: background,
    canvasColor: background,
    textTheme: text,
    dividerTheme: DividerThemeData(color: line, thickness: 1, space: 1),
    splashFactory: InkSparkle.splashFactory,
    visualDensity: VisualDensity.standard,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(color: ink),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mono.radius),
        side: BorderSide(color: line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: buttonSize,
        padding: buttonPadding,
        shape: rounded,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: buttonSize,
        padding: buttonPadding,
        shape: rounded,
        foregroundColor: ink,
        side: BorderSide(color: line),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ink,
        shape: rounded,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: ink),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ink,
      foregroundColor: paper,
      elevation: 2,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mono.radius),
      ),
      extendedTextStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: raised,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: muted),
      labelStyle: TextStyle(color: muted),
      floatingLabelStyle: TextStyle(color: ink),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Mono.radiusSmall),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Mono.radiusSmall),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Mono.radiusSmall),
        borderSide: BorderSide(color: ink, width: 1.5),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: card,
      selectedColor: ink,
      checkmarkColor: paper,
      side: BorderSide(color: line),
      shape: const StadiumBorder(),
      labelStyle: TextStyle(color: ink, fontWeight: FontWeight.w500),
      secondaryLabelStyle: TextStyle(color: paper, fontWeight: FontWeight.w600),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: ink,
        selectedForegroundColor: paper,
        side: BorderSide(color: line),
        shape: rounded,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: BorderSide(color: muted, width: 1.5),
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStatePropertyAll(line),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mono.radiusSmall),
      ),
      iconColor: ink,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      indicatorColor: ink,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: s.contains(WidgetState.selected) ? ink : muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? paper : muted,
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: line,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ink,
      contentTextStyle: TextStyle(color: paper),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mono.radiusSmall),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ink,
      linearTrackColor: raised,
      circularTrackColor: Colors.transparent,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: paper, fontSize: 12),
    ),
  );
}
