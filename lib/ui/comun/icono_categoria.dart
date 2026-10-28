import 'package:material_ui/material_ui.dart';

import '../../domain/categoria.dart';

/// Sprint 6 · El icono de cada tipo de residuo. El mismo en el formulario,
/// la lista y el detalle: se aprende una vez (Material Symbols, incluidos en
/// Flutter).
IconData iconoDe(Categoria categoria) => switch (categoria) {
      Categoria.domestica => Icons.delete_outline,
      Categoria.escombros => Icons.construction,
      Categoria.voluminosos => Icons.chair_outlined,
      Categoria.poda => Icons.grass,
      Categoria.llantas => Icons.tire_repair,
      Categoria.otro => Icons.more_horiz,
    };
