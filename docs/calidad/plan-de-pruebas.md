# Plan de pruebas de EcoReporte · TEC-04

> Sprint 4. Une cada escenario de `docs/criterios/` y cada requisito de calidad con **la prueba automática que lo cubre**
> y con **lo que se comprueba a mano en un Android físico**. Es la evidencia del Hito 4.

## 1. Tres niveles de prueba

| Nivel | Qué prueba | Dónde | Cuándo corre |
|---|---|---|---|
| **Unitarias** | ViewModel, repositorio SQLite (con `sqflite_common_ffi`), mensaje de compartir, almacén de fotos | `test/*_test.dart` | `flutter test`, antes de cada PR |
| **De widgets** | Pantallas completas con cámara, GPS, menú de compartir y preferencias **falsos** (`test/falsos.dart`) | `test/widget_test.dart`, `test/accesibilidad_test.dart` | `flutter test`, antes de cada PR |
| **En dispositivo** | Lo que solo existe en un teléfono: permisos reales, modo avión, llamadas, WhatsApp, rendimiento | Ficha de la sección 4 | Columna «En dispositivo» del tablero; una ficha por historia |

**Por qué falsos:** la cámara, el GPS y el menú de compartir no existen en `flutter test` (corre en el computador). Cada
uno está detrás de un contrato (`FuenteFotos`, `FuenteUbicacion`, `ServicioCompartir`, `PreferenciasApp`) y las pruebas
inyectan una versión que responde lo que el escenario necesita: permiso negado, señal que no llega, cancelación…

## 2. Matriz de escenarios

Prueba automática: **VM** = `nuevo_reporte_viewmodel_test` o `reportes_viewmodel_test` · **W** = `widget_test` ·
**R** = `repositorio_sqlite_test` · **M** = `mensaje_compartir_test` · **A** = `almacen_fotos_test` ·
**Acc** = `accesibilidad_test`.

| Historia | Escenario | Automática | En el teléfono |
|---|---|---|---|
| HU-01 | Foto tomada | VM, W | Sí |
| HU-01 | Permiso de cámara denegado | VM, W | Sí |
| HU-01 | Cancelar no borra lo demás | VM | Sí |
| HU-01 | Una llamada a mitad del formulario | VM (foto recuperada) | **Obligatorio** |
| HU-02 | Ubicación obtenida con buena señal | VM, W | **Obligatorio**, cronometrado |
| HU-02 | Se ve que la app está buscando | VM, W | Sí |
| HU-02 | Permiso de ubicación denegado | VM, W | Sí, también «no volver a preguntar» |
| HU-02 | Precisión peor que 50 metros | VM, W | Sí, con «aproximada» (Android 12+) |
| HU-12 | Escribir una referencia | W | Sí |
| HU-12 | Sin ubicación, la referencia es obligatoria | VM, W | Sí |
| HU-12 | Referencia demasiado larga | W | Sí, pegando un texto |
| HU-03 | Guardar sin conexión | VM, W | **Obligatorio**, modo avión |
| HU-03 | Sobrevive al cierre | R | **Obligatorio** |
| HU-03 | Falta la foto | VM, W | Sí |
| HU-03 | Doble toque | VM | Sí |
| HU-03 | Sin espacio en el teléfono | VM | No (difícil de provocar); se acepta la automática |
| HU-03 | La confirmación dice qué sigue | W | Sí |
| HU-04 | Lista vacía | VM, W | Con `DATOS=simulados` |
| HU-04 | Lista con datos | VM, W, R | Sí |
| HU-04 | No se pueden leer | VM, W | Con `DATOS=simulados` |
| HU-04 | Doscientos reportes (RC-03) | R, W | **Obligatorio**, gama de entrada, `--profile` |
| HU-05 | Abrir el detalle | W | Sí |
| HU-05 | Volver a la lista en la misma posición | W | Sí |
| HU-05 | Pantalla pequeña | W, Acc | Sí, en el teléfono más angosto del equipo |
| HU-10 | Compartir un reporte | M, VM, W | **Obligatorio**, a un contacto real |
| HU-10 | WhatsApp no está instalado | — (lo resuelve el sistema) | Sí, en un emulador |
| HU-10 | Compartir sin conexión | — (lo resuelve WhatsApp) | Sí, modo avión |

**27 escenarios**: 25 con prueba automática; los 2 que dependen de otra app se comprueban solo en el teléfono.

## 3. Requisitos de calidad

| ID | Requisito | Cómo se mide | Resultado |
|---|---|---|---|
| RC-01 | Primer reporte en menos de 1 minuto, sin ayuda | Prueba de usabilidad con dos vecinos (INV-02, `docs/validacion/prueba-usabilidad.md`) | *Pendiente de la prueba* |
| RC-02 | 48 dp y contraste de 4,5:1 | `accesibilidad_test` en las cuatro pantallas; el texto de ayuda de los campos, a ojo con el «Escáner de accesibilidad» de Google | Automática: ver `flutter test` |
| RC-03 | Lista con 200 reportes en menos de 1 s, gama de entrada | `flutter run --profile --dart-define=DATOS=simulados` → matraz → «Doscientos reportes» → DevTools › Performance | *Teléfono, Android y tiempo: pendiente* |
| RC-04 | Cada foto pesa menos de 1 MB | La consola de `flutter run` imprime «Foto guardada: N KB» al guardar; tomar 5 fotos con luz distinta | *Pendiente: anotar las 5 medidas* |
| RC-05 | Ningún reporte se pierde al cerrar, apagar o quedarse sin batería | Escenario «Sobrevive al cierre» + apagar el teléfono con un reporte recién guardado | *Pendiente* |
| RC-06 | Ubicación solo mientras se crea el reporte; aviso antes del primer dato | No hay `ACCESS_BACKGROUND_LOCATION`; prueba de widgets del aviso; Ajustes › Ubicación › EcoReporte dice «Solo mientras se usa» | Automática + teléfono |
| RC-07 | La versión de Android más antigua de los entrevistados y 360 dp | `minSdk` de Flutter 3.47 (ver `flutter doctor -v`) frente a las entrevistas; `accesibilidad_test` a 360 dp con letra al 150 % | *Falta el dato de las entrevistas* |

> Las celdas *pendientes* las llena el equipo con datos reales. Este repositorio modelo no las inventa.

## 4. Ficha de prueba en dispositivo

Una por historia, como comentario de su issue, antes de moverla de «En dispositivo» a «Hecho».

```markdown
### Prueba en dispositivo · HU-__
- Teléfono y Android: (p. ej., moto g20 · Android 11)
- APK: rama ______ · commit ______
- Fecha y quién probó:

| Escenario | ¿Pasa? | Nota o captura |
|---|---|---|
| | ✅ / ❌ | |

- 360 dp sin desbordes: ✅ / ❌
- Con TalkBack se entiende cada botón: ✅ / ❌
- Defectos encontrados (issue de tipo Defecto): #__
```

## 5. Antes de cada PR

```powershell
flutter analyze          # meta: No issues found!
flutter test             # todas en verde
flutter test --coverage  # opcional: coverage/lcov.info
```
