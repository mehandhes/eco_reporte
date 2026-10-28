# Sprint 4 · semana 3 del cierre · Estabilización · Prueba y corrección

> Último sprint. Cierra el **Hito 4 (calidad, seguridad y build distribuible)** y prepara el **Hito 5 (Demo Day)**.
> Plan general en `docs/plan-de-cierre.md`.

## Sprint Planning

**Objetivo del Sprint:**
> «La app es segura, accesible y se instala desde un APK firmado».

| ID | Elemento | Pts | Rama |
|---|---|---|---|
| TEC-05 | Seguridad y privacidad | 3 | `tec-05-seguridad-privacidad` |
| TEC-04 | Calidad: plan de pruebas y accesibilidad | 3 | `tec-04-calidad` |
| TEC-06 | Build de release firmado | 2 | `tec-06-build-release` |
| INV-02 | Prueba de usabilidad con dos vecinos | 3 | — (trabajo de campo) |
| INV-05 | Demo Day: pitch, modelo de impacto y guion | 3 | `sprint-4-cierre` |

**Total: 14 puntos** (11 de elementos técnicos y de cierre más los 3 de INV-02, que viene del Sprint 1). Es el sprint más
cargado: por eso **no entra ninguna historia nueva** y lo primero es terminar las comprobaciones en dispositivo del
Sprint 3.

**Orden:** TEC-05 primero, porque cambia pantallas (aviso, borrar) y TEC-04 tiene que probarlas; TEC-06 al final, sobre
el código ya estable. INV-02 el fin de semana, con el APK de TEC-06.

**Decisiones:**

1. **El aviso de privacidad va antes del primer «Reportar»**, no al abrir la app: la vecina lo lee justo antes de que se
   le pida la cámara y la ubicación (RC-06). Se recuerda con `shared_preferences`.
2. **Borrar un reporte** entra como parte de TEC-05: es el derecho a suprimir de la Ley 1581 y la tercera tarea de la
   prueba de usabilidad. Primero se borra la fila y después la foto.
3. **Sin copia a la nube** (`allowBackup="false"`): los datos no salen del teléfono sin que la vecina lo decida.
4. **La accesibilidad la revisa la máquina** en cada PR (`test/accesibilidad_test.dart`); lo que la máquina no ve (el
   texto de ayuda de los campos, TalkBack de verdad) va a la ficha de prueba en dispositivo.
5. **La base no se cifra**: decisión anotada en `docs/seguridad.md` (M10), revisable si llega un servidor.

## Lo que produjo

| Elemento | Resultado | Dónde quedó |
|---|---|---|
| TEC-05 | Aviso de privacidad, borrar con confirmación, manifiesto endurecido, revisión M1–M10, política de datos | `lib/ui/privacidad/`, `docs/seguridad.md`, `docs/privacidad.md` |
| TEC-04 | Matriz de 27 escenarios y 7 requisitos con su prueba; guías de accesibilidad en 4 pantallas; 360 dp con letra al 150 % | `docs/calidad/plan-de-pruebas.md`, `test/accesibilidad_test.dart` |
| TEC-06 | Firma con `key.properties`, compilación ofuscada, comprobaciones y reparto; versión 1.0.0+4 | `android/app/build.gradle.kts`, `docs/distribucion.md`, `CHANGELOG.md` |
| INV-02 | Protocolo de la prueba con tres tareas y ficha | `docs/validacion/prueba-usabilidad.md` |
| INV-05 | Pitch minuto a minuto, guion de demo en modo avión con plan B, modelo de impacto y preguntas de defensa | `docs/cierre/demo-day.md` |
| Pruebas | De 62 a 73 | `test/` |

## Estado al cierre del curso

| Comprobación | Estado |
|---|---|
| Las 7 historias Must construidas y fusionadas | ✔ |
| 27 escenarios: 25 con prueba automática | ✔ |
| `flutter analyze` sin problemas y `flutter test` en verde | ☐ lo corre el equipo y lo muestra en la Review |
| Ficha de prueba en dispositivo de cada historia | ☐ |
| RC-01, RC-03, RC-04, RC-05 y RC-07 medidos | ☐ (ver plan de pruebas) |
| INV-02 hecha con dos vecinos | ☐ |
| APK 1.0.0 firmado con la llave del equipo | ☐ |

## Para la Review final y el Demo Day

1. El guion de `docs/cierre/demo-day.md`.
2. El plan de pruebas con las celdas *pendientes* ya llenas con datos reales.
3. Los resultados de INV-02 y qué cambió por ellos.
4. **Retrospectiva final del curso** (10 min): una práctica que el equipo conserva para su próximo proyecto y una que
   cambiaría. Métricas de los cuatro sprints: throughput y el elemento que más tiempo pasó en curso.
