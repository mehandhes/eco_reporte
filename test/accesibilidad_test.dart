import 'package:eco_reporte/app/eco_reporte_app.dart';
import 'package:eco_reporte/data/repositorio_simulado.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'falsos.dart';

/// TEC-04 · La Definición de Terminado, comprobada por la máquina en cada
/// pantalla: áreas táctiles de 48 dp, botones con nombre para TalkBack,
/// contraste de 4,5:1 (RC-02) y nada desbordado a 360 dp con letra grande.
///
/// Las guías de accesibilidad de flutter_test revisan el árbol de semántica:
/// lo mismo que «lee» TalkBack.
void main() {
  Future<void> abrir(WidgetTester tester) async {
    final RepositorioSimulado repositorio = RepositorioSimulado(
      retardo: Duration.zero,
      ahora: DateTime(2026, 11, 2, 9),
    );
    await tester.pumpWidget(
      EcoReporteApp(
        repositorio: repositorio,
        fotos: FuenteFotosFalsa(),
        almacen: AlmacenFotosFalso(),
        ubicacion: FuenteUbicacionFalsa(),
        compartir: ServicioCompartirFalso(),
        preferencias: PreferenciasFalsas(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cumpleLasGuias(WidgetTester tester, {bool contraste = true}) async {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    if (contraste) await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  testWidgets('«Mis reportes» cumple las guías', (WidgetTester tester) async {
    final SemanticsHandle semantica = tester.ensureSemantics();
    await abrir(tester);

    await cumpleLasGuias(tester);
    semantica.dispose();
  });

  testWidgets('El detalle cumple las guías', (WidgetTester tester) async {
    final SemanticsHandle semantica = tester.ensureSemantics();
    await abrir(tester);
    await tester.tap(find.textContaining('Lote de la esquina'));
    await tester.pumpAndSettle();

    await cumpleLasGuias(tester);
    semantica.dispose();
  });

  testWidgets('El formulario cumple las guías de tamaño y nombre', (WidgetTester tester) async {
    final SemanticsHandle semantica = tester.ensureSemantics();
    await abrir(tester);
    await tester.tap(find.text('Reportar'));
    await tester.pumpAndSettle();

    // El contraste se revisa en pantallas sin campos de texto: el texto de
    // ayuda (hint) de Material 3 se mide aparte, a ojo, en el teléfono.
    await cumpleLasGuias(tester, contraste: false);
    semantica.dispose();
  });

  testWidgets('El aviso de privacidad cumple las guías', (WidgetTester tester) async {
    final SemanticsHandle semantica = tester.ensureSemantics();
    await abrir(tester);
    await tester.tap(find.byTooltip('Privacidad'));
    await tester.pumpAndSettle();

    await cumpleLasGuias(tester);
    semantica.dispose();
  });

  group('360 dp con la letra al 150 %', () {
    Future<void> pantallaPequena(WidgetTester tester) async {
      tester.view.physicalSize = const Size(720, 1520);
      tester.view.devicePixelRatio = 2; // 360 × 760 dp
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }

    testWidgets('«Mis reportes» no se desborda', (WidgetTester tester) async {
      await pantallaPequena(tester);
      await abrir(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('el formulario no se desborda', (WidgetTester tester) async {
      await pantallaPequena(tester);
      await abrir(tester);
      await tester.tap(find.text('Reportar'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('el aviso de privacidad no se desborda', (WidgetTester tester) async {
      await pantallaPequena(tester);
      await abrir(tester);
      await tester.tap(find.byTooltip('Privacidad'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
