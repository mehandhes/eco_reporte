import 'package:material_ui/material_ui.dart';

/// Verde institucional de UNIPAZ como semilla de Material 3.
const Color verdeUnipaz = Color(0xFF00963F);

ThemeData temaClaro() => ThemeData(
      colorSchemeSeed: verdeUnipaz,
      brightness: Brightness.light,
    );

ThemeData temaOscuro() => ThemeData(
      colorSchemeSeed: verdeUnipaz,
      brightness: Brightness.dark,
    );
