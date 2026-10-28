import 'package:material_ui/material_ui.dart';

// Sprint 6 · Sistema visual de EcoReporte (docs/diseno.md).
//
// Se diseña para una situación: Yolanda, 46 años, de pie en la calle, con
// sol de mediodía en Barrancabermeja, el teléfono en una mano y la bolsa
// del mandado en la otra. De ahí salen las tres reglas:
//
// 1. Contraste alto siempre: todo texto pasa 4,5:1 y casi todo pasa 7:1.
// 2. Letra que no se confunde: Atkinson Hyperlegible (Braille Institute,
//    licencia OFL), hecha para baja visión; distingue 1, l, I y 0, O.
// 3. Lo importante abajo, al alcance del pulgar, y con 56 dp de alto.

/// Verde institucional de UNIPAZ. Con letra blanca da 3,9:1 (no pasa
/// RC-02), así que en la app se usa el tono más oscuro, [verdeMonte].
const Color verdeUnipaz = Color(0xFF00963F);

/// Verde monte: botones principales. 6,6:1 con letra blanca.
const Color verdeMonte = Color(0xFF0B6B3A);

/// Tinta: casi negro con un poco de verde. 15:1 sobre [papel].
const Color tinta = Color(0xFF14231B);

/// Papel: fondo frío, apenas verdoso, para que el sol no lo queme.
const Color papel = Color(0xFFF6F8F5);

/// Amarillo señal: lo que pide atención sin ser un error (ubicación
/// aproximada, falta algo). Siempre con texto oscuro encima.
const Color amarilloSenal = Color(0xFFFFE08A);

/// Familia tipográfica de toda la app (assets/fuentes).
const String familia = 'AtkinsonHyperlegible';

ColorScheme _esquemaClaro() => const ColorScheme(
      brightness: Brightness.light,
      primary: verdeMonte,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFCDEBD6),
      onPrimaryContainer: Color(0xFF052E18),
      secondary: Color(0xFF3F5A49),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFDCEFE3),
      onSecondaryContainer: Color(0xFF0F2B1B),
      tertiary: Color(0xFF6B5300),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: amarilloSenal,
      onTertiaryContainer: Color(0xFF3D2E00),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      surface: papel,
      onSurface: tinta,
      onSurfaceVariant: Color(0xFF3F4F45),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF0F4F1),
      surfaceContainer: Color(0xFFEAEFEB),
      surfaceContainerHigh: Color(0xFFE3EAE5),
      surfaceContainerHighest: Color(0xFFDDE5DF),
      outline: Color(0xFF6B7A70),
      outlineVariant: Color(0xFFBFCAC2),
      inverseSurface: Color(0xFF29342D),
      onInverseSurface: Color(0xFFEDF2EE),
      inversePrimary: Color(0xFF7FD8A0),
    );

ColorScheme _esquemaOscuro() => const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7FD8A0),
      onPrimary: Color(0xFF003919),
      primaryContainer: Color(0xFF0B4A28),
      onPrimaryContainer: Color(0xFFC9F0D6),
      secondary: Color(0xFFB4CCBC),
      onSecondary: Color(0xFF1F3528),
      secondaryContainer: Color(0xFF1E3328),
      onSecondaryContainer: Color(0xFFD2E8DA),
      tertiary: Color(0xFFF2C94C),
      onTertiary: Color(0xFF3D2E00),
      tertiaryContainer: Color(0xFF4A3800),
      onTertiaryContainer: amarilloSenal,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF8C1D18),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF0F1712),
      onSurface: Color(0xFFE3EBE5),
      onSurfaceVariant: Color(0xFFBCC9C0),
      surfaceContainerLowest: Color(0xFF0A110D),
      surfaceContainerLow: Color(0xFF17201A),
      surfaceContainer: Color(0xFF1B241E),
      surfaceContainerHigh: Color(0xFF242E27),
      surfaceContainerHighest: Color(0xFF2A342D),
      outline: Color(0xFF86948A),
      outlineVariant: Color(0xFF3F4F45),
      inverseSurface: Color(0xFFE3EBE5),
      onInverseSurface: Color(0xFF29342D),
      inversePrimary: verdeMonte,
    );

/// Escala de texto: un paso más grande que la de Material en lo que se lee
/// (cuerpo 17 en vez de 16) y títulos firmes pero no gritones.
TextTheme _textos(ColorScheme c) => TextTheme(
      headlineSmall: TextStyle(fontSize: 24, height: 1.25, fontWeight: FontWeight.w700, color: c.onSurface),
      titleLarge: TextStyle(fontSize: 22, height: 1.25, fontWeight: FontWeight.w700, color: c.onSurface),
      titleMedium: TextStyle(fontSize: 18, height: 1.3, fontWeight: FontWeight.w700, color: c.onSurface),
      titleSmall: TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w700, color: c.onSurface),
      bodyLarge: TextStyle(fontSize: 17, height: 1.45, color: c.onSurface),
      bodyMedium: TextStyle(fontSize: 16, height: 1.45, color: c.onSurface),
      bodySmall: TextStyle(fontSize: 14, height: 1.4, color: c.onSurfaceVariant),
      labelLarge: TextStyle(fontSize: 16, height: 1.2, fontWeight: FontWeight.w700, color: c.onSurface),
      labelMedium: TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w700, color: c.onSurface),
      labelSmall: TextStyle(fontSize: 13, height: 1.2, fontWeight: FontWeight.w700, color: c.onSurface),
    );

ThemeData _tema(ColorScheme c) {
  final TextTheme textos = _textos(c);
  const RoundedRectangleBorder forma =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)));
  return ThemeData(
    colorScheme: c,
    fontFamily: familia,
    textTheme: textos,
    scaffoldBackgroundColor: c.surface,
    // Áreas táctiles de 48 dp en todo, aunque el botón se vea más pequeño.
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    appBarTheme: AppBarTheme(
      backgroundColor: c.surface,
      foregroundColor: c.onSurface,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: textos.titleLarge,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        textStyle: textos.labelLarge,
        shape: forma,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: textos.labelLarge,
        side: BorderSide(color: c.outline),
        shape: forma,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        textStyle: textos.labelLarge,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.primary,
      foregroundColor: c.onPrimary,
      extendedTextStyle: textos.labelLarge,
      shape: forma,
    ),
    cardTheme: CardThemeData(
      color: c.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: c.outlineVariant),
      ),
    ),
    chipTheme: ChipThemeData(
      labelStyle: textos.labelMedium,
      side: BorderSide(color: c.outline),
      selectedColor: c.primaryContainer,
      checkmarkColor: c.onPrimaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surfaceContainerLowest,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      helperStyle: textos.bodySmall,
      helperMaxLines: 2,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: textos.bodyMedium?.copyWith(color: c.onInverseSurface),
      shape: forma,
    ),
    dividerTheme: DividerThemeData(color: c.outlineVariant, space: 1),
  );
}

ThemeData temaClaro() => _tema(_esquemaClaro());

ThemeData temaOscuro() => _tema(_esquemaOscuro());
