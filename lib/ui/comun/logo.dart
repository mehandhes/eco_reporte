import 'package:material_ui/material_ui.dart';

/// Sprint 6 · El logo de EcoReporte: un marcador de mapa con una hoja.
///
/// El marcador dice «dónde» (la app sirve para señalar un punto) y la hoja
/// dice «para qué» (un barrio limpio). Se dibuja con código, sin imagen:
/// se ve nítido a cualquier tamaño y toma los colores del tema, en claro y
/// en oscuro. El icono de la app y la pantalla de arranque de Android usan
/// la misma forma (`android/app/src/main/res`).
class LogoEcoReporte extends StatelessWidget {
  const LogoEcoReporte({super.key, this.tamano = 72});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: 'Logo de EcoReporte',
      child: CustomPaint(
        size: Size.square(tamano),
        painter: _Pintor(marcador: colores.primary, hoja: colores.onPrimary),
      ),
    );
  }
}

class _Pintor extends CustomPainter {
  const _Pintor({required this.marcador, required this.hoja});

  final Color marcador;
  final Color hoja;

  @override
  void paint(Canvas canvas, Size size) {
    // Todo se dibuja en una caja de 100 × 100 y se escala.
    final double k = size.width / 100;
    canvas.save();
    canvas.scale(k, k);
    canvas.translate(0, 2);

    final Path pin = Path()
      ..moveTo(50, 92)
      ..cubicTo(40, 76, 20, 62, 20, 40)
      ..arcToPoint(const Offset(80, 40), radius: const Radius.circular(30))
      ..cubicTo(80, 62, 60, 76, 50, 92)
      ..close();
    canvas.drawPath(pin, Paint()..color = marcador);

    final Path forma = Path()
      ..moveTo(36, 54)
      ..quadraticBezierTo(34, 28, 64, 26)
      ..quadraticBezierTo(66, 52, 36, 54)
      ..close();
    canvas.drawPath(forma, Paint()..color = hoja);

    canvas.drawLine(
      const Offset(41, 49),
      const Offset(56, 34),
      Paint()
        ..color = marcador
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_Pintor anterior) =>
      anterior.marcador != marcador || anterior.hoja != hoja;
}
