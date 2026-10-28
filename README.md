# EcoReporte

**Reporte ciudadano de puntos críticos de residuos · ODS 11 · Barrancabermeja**

Proyecto modelo del curso *Desarrollo de Aplicaciones Móviles* (Ingeniería Informática, VIII semestre, UNIPAZ). Muestra
cómo un equipo lleva un producto de la idea al APK con el marco del curso (Scrumban con fases de Mobile-D) y **Flutter**.
Es un ejemplo para estudiar, no para copiar: su problema es otro.

> **Estado: versión 1.2.0, Sprint 6 (UX/UI y accesibilidad).** Las siete historias Must del MVP más dos
> Should (HU-06 y HU-09) están construidas, con 111 pruebas automáticas, revisión de seguridad y build de release. Falta lo que solo puede hacer un equipo de
> verdad: probar cada historia en un Android físico, medir los requisitos de calidad en el teléfono y hacer la prueba
> de usabilidad con vecinos (INV-02). Las celdas *pendientes* de los documentos no se inventan.

## Objetivo del Producto

> «Que cualquier vecino reporte un punto crítico de residuos en menos de un minuto, incluso sin conexión, y que su JAC
> reciba un listado mensual verificable».

## Qué hace la app

1. **Reportar** (HU-01, HU-02, HU-12, HU-03): foto con la cámara o la galería, ubicación automática con aviso si es
   aproximada, referencia del lugar y guardado en el teléfono **sin conexión**.
2. **Consultar** (HU-04, HU-05): «Mis reportes» del más reciente al más antiguo, con sus cuatro estados, y el detalle con
   la foto en grande.
3. **Hacer que llegue** (HU-10): compartir por WhatsApp (o cualquier app) con la foto, la fecha, el lugar y un enlace al
   mapa; la lista marca lo que ya se compartió.
4. **Tipo de residuo y listado del mes** (HU-06, HU-09): cada reporte puede decir qué hay (escombros, colchones…) y la
   JAC exporta el listado del mes en un CSV que se abre en Excel.
5. **Privacidad** (TEC-05): aviso antes del primer reporte, borrar un reporte con su foto, nada sale del teléfono sin
   que la vecina lo decida.

## Dónde está cada cosa

| Sprint | Tema | Archivo |
|---|---|---|
| 0 | Visión, alcance, backlog, tablero, flujo de trabajo | [`docs/vision-y-alcance.md`](docs/vision-y-alcance.md) · [`docs/backlog.md`](docs/backlog.md) · [`docs/tablero.md`](docs/tablero.md) · [`docs/flujo-de-trabajo.md`](docs/flujo-de-trabajo.md) |
| 1 | Requisitos, criterios Dado / Cuando / Entonces, validación | [`docs/requisitos.md`](docs/requisitos.md) · [`docs/criterios/`](docs/criterios/) · [`docs/validacion/`](docs/validacion/) |
| 2–4 | **Plan de cierre en tres sprints** | [`docs/plan-de-cierre.md`](docs/plan-de-cierre.md) |
| 2 | SQLite, foto, referencia, guardar sin conexión → Hito 2 | [`docs/sprints/sprint-2.md`](docs/sprints/sprint-2.md) |
| 3 | Ubicación, compartir, 200 reportes, migración de la base → Hito 3 | [`docs/sprints/sprint-3.md`](docs/sprints/sprint-3.md) |
| 4 | Calidad, seguridad, build de release, usabilidad, Demo Day → Hitos 4 y 5 | [`docs/sprints/sprint-4.md`](docs/sprints/sprint-4.md) · [`docs/calidad/plan-de-pruebas.md`](docs/calidad/plan-de-pruebas.md) · [`docs/seguridad.md`](docs/seguridad.md) · [`docs/privacidad.md`](docs/privacidad.md) · [`docs/distribucion.md`](docs/distribucion.md) · [`docs/cierre/demo-day.md`](docs/cierre/demo-day.md) |
| 5 | Tipo de residuo, listado del mes en CSV, migración al esquema 3 | [`docs/sprints/sprint-5.md`](docs/sprints/sprint-5.md) |
| 6 | UX/UI y accesibilidad: paleta con contraste medido, letra Atkinson Hyperlegible, barra de «Guardar» fija, pantalla de inicio con logo y eslogan | [`docs/diseno.md`](docs/diseno.md) |

Cada sprint tiene su etiqueta de Git (`sprint-2`, `sprint-3`, `v1.0.0`, `v1.1.0`) y cada elemento del backlog su rama fusionada con
`--no-ff`: `git log --graph --oneline` cuenta la historia.

## Ejecutar

Requisitos del curso: Flutter 3.47 / Dart 3.13, Android SDK API 36, Java 17 y un Android con depuración USB.

```powershell
flutter pub get
flutter analyze        # meta: No issues found!
flutter test           # 111 pruebas
flutter run            # en el teléfono conectado
```

| Para… | Comando |
|---|---|
| Ver los cuatro estados de la lista y los 200 reportes de prueba | `flutter run --dart-define=DATOS=simulados` y el icono del matraz |
| Medir el rendimiento (RC-03) | `flutter run --profile --dart-define=DATOS=simulados` + DevTools |
| Compilar el APK para repartir | ver [`docs/distribucion.md`](docs/distribucion.md) |

## Arquitectura (MVVM del curso)

```
lib/
├── domain/      Reporte, BorradorReporte y el mensaje de compartir: Dart puro, sin Flutter
├── data/        Contratos y sus implementaciones reales
│   ├── repositorio_sqlite.dart        ReporteRepository sobre sqflite (esquema 2 con migración)
│   ├── repositorio_simulado.dart      datos de ejemplo para pruebas y para revisar estados
│   ├── fotos/       FuenteFotos (image_picker) y AlmacenFotos (carpeta privada)
│   ├── ubicacion/   FuenteUbicacion (geolocator, una lectura, sin segundo plano)
│   ├── compartir/   ServicioCompartir (share_plus)
│   └── preferencias/ PreferenciasApp (shared_preferences)
├── ui/          Una carpeta por pantalla: Pantalla + ViewModel (ChangeNotifier)
│   ├── reportes/  · detalle/ · nuevo/ · privacidad/ · comun/
└── app/         Provider (inyección), go_router (rutas) y tema Material 3
```

**La regla que sostiene todo:** las pantallas solo hablan con su ViewModel y los ViewModel solo con **contratos**
(`abstract interface class`). Por eso las 73 pruebas corren en el computador con cámara, GPS y menú de compartir falsos
(`test/falsos.dart`), y por eso cambiar los datos simulados por SQLite en el Sprint 2 no tocó ninguna pantalla.

## Ramas y forma de trabajar

- `main` protegida: todo entra por pull request con una revisión y `Closes #N`.
- Una rama por elemento: `tec-02-sqlite`, `hu-01-tomar-foto`, `hu-02-ubicacion`, `tec-05-seguridad-privacidad`…
- La Definición de Terminado está en [`docs/flujo-de-trabajo.md`](docs/flujo-de-trabajo.md); el plan de pruebas dice
  qué se comprueba en el teléfono antes de mover una tarjeta a «Hecho».

## Historial de sprints

| Sprint | Semana | Objetivo | Puntos | Resultado |
|---|---|---|---|---|
| 0 | 3 | Tablero y backlog listos para trabajar | — | Hecho |
| 1 | 4 | Las historias Must tienen criterios de aceptación validados con dos vecinos | — | Criterios hechos; validación pendiente |
| 2 | Cierre · 1 | Una vecina crea un reporte con foto y referencia, sin conexión, y lo ve en «Mis reportes» | 11 | Código fusionado · Hito 2 |
| 3 | Cierre · 2 | El reporte dice dónde está el punto y llega a los vecinos por WhatsApp | 10 | Código fusionado · Hito 3 |
| 4 | Cierre · 3 | La app es segura, accesible y se instala desde un APK firmado | 14 | Código y documentos fusionados · Hitos 4 y 5 |

## Usar este repositorio en clase

Leerlo junto a las guías-taller de cada sprint (22 · Sprint 0, 23 · Sprint 1, 25 · Sprint 2, 26 · Sprint 3 y
27 · Sprint 4): cada archivo dice a qué paso responde. Para comparar con un equipo, sirve mirar el mismo archivo en la
etiqueta del sprint: `git checkout sprint-2`.

---
Desarrollo de Aplicaciones Móviles · Ingeniería Informática · UNIPAZ · 2026
