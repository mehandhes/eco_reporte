import 'package:material_ui/material_ui.dart';

import 'app/tema.dart';

/// TEC-01: proyecto creado y migrado a material_ui. La primera pantalla
/// real llega con la prueba técnica del Sprint 1.
void main() => runApp(const EcoReporteApp());

class EcoReporteApp extends StatelessWidget {
  const EcoReporteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoReporte',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaOscuro(),
      home: const Scaffold(
        body: Center(child: Text('EcoReporte')),
      ),
    );
  }
}
