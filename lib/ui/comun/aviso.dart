import 'package:material_ui/material_ui.dart';

/// Pantalla de aviso reutilizable para los estados «vacío» y «error».
///
/// Siempre dice qué pasa y, si hay algo que hacer, ofrece la acción
/// (heurísticas H1 y H9).
class Aviso extends StatelessWidget {
  const Aviso({
    super.key,
    required this.icono,
    required this.titulo,
    required this.detalle,
    this.accion,
    this.alPulsar,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final String? accion;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icono, size: 64, color: tema.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: tema.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              detalle,
              style: tema.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (accion != null && alPulsar != null) ...<Widget>[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: alPulsar,
                style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                child: Text(accion!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
