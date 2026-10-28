# Sprint 3 · semana 2 del cierre · Producción

> Cierra el **Hito 3 (integración)**. Plan general en `docs/plan-de-cierre.md`.

## Review del Sprint 2 (resumen para la Planning)

Lo que el equipo lleva a la Review está en `docs/sprints/sprint-2.md` («Para la Review»). Dos decisiones que el Sprint 3
hereda de ahí:

1. **El Hito 3 sin API.** Si el docente pide integración con un servicio web, HU-07 (3 pts) entra al Sprint 4 en lugar
   de INV-05, y el pitch se prepara fuera del sprint.
2. **La comprobación en Android físico** de TEC-02, HU-01, HU-12 y HU-03 se hace el primer día del Sprint 3, antes de
   tomar trabajo nuevo: son si se dejan para después, se acumulan con las del Sprint 3.

## Sprint Planning

**Objetivo del Sprint:**
> «El reporte dice dónde está el punto y llega a los vecinos por WhatsApp».

| ID | Elemento | Pts | Rama |
|---|---|---|---|
| HU-02 | Ubicación automática | 3 | `hu-02-ubicacion` |
| HU-10 | Compartir por WhatsApp | 2 | `hu-10-compartir` |
| HU-04 | Lista de mis reportes (terminar: 200 reportes) | 3 | `hu-04-hu-05-terminar` |
| HU-05 | Detalle de un reporte (terminar: volver a la misma posición) | 2 | `hu-04-hu-05-terminar` |

**Total: 10 puntos.** HU-04 y HU-05 ya tenían la base de INV-04 y la foto real del Sprint 2: lo que falta es pequeño,
por eso van juntas en una rama.

**Decisiones técnicas:**

1. **La ubicación también es un contrato** (`FuenteUbicacion`) con resultado `sealed`: obtenida, sin permiso (o
   bloqueado), GPS apagado y sin señal. Son cuatro mensajes distintos para la vecina, no un «error» genérico.
2. **Una sola lectura con límite de 10 s**, sin seguimiento ni segundo plano (RC-06). Se piden juntos los permisos
   `COARSE` y `FINE`: desde Android 12 la vecina puede conceder solo la aproximada, y esa llega con más de 50 m y se
   avisa.
3. **Con ubicación, la referencia deja de ser obligatoria** (HU-12 lo decía desde el Sprint 1).
4. **Compartir no apunta a WhatsApp**: abre el menú del sistema. Así se cumplen gratis «WhatsApp no está instalado» y
   «Compartir sin conexión».
5. **El enlace al mapa es un enlace universal de Google Maps** (`https://www.google.com/maps/search/?api=1&query=…`):
   no necesita clave de API ni paquete.
6. **Hallazgo H1 del Sprint 1** («tras compartir, el reporte no muestra que ya se compartió»): se resuelve con una
   columna nueva. Es el primer cambio de esquema, así que llega con su **migración** de la versión 1 a la 2.

## Lo que produjo

| Elemento | Resultado | Dónde quedó |
|---|---|---|
| HU-02 | Búsqueda automática al abrir el formulario, seis estados con su mensaje y su acción, aviso de precisión > 50 m | `lib/data/ubicacion/`, `lib/ui/nuevo/bloque_ubicacion.dart` |
| HU-10 | Mensaje con fecha, referencia y mapa; foto adjunta; marca «Compartido» en la lista y el detalle | `lib/domain/mensaje_compartir.dart`, `lib/data/compartir/` |
| HU-04 | Escenario de 200 reportes para medir en el teléfono; prueba de que solo se construye lo visible | `lib/data/repositorio_simulado.dart` |
| HU-05 | La posición de la lista se conserva al volver y al recargar | `lib/ui/reportes/pantalla_reportes.dart` |
| Base | Esquema 2 con migración y su prueba sobre una base real del esquema 1 | `lib/data/repositorio_sqlite.dart` |
| Pruebas | De 39 a 62 | `test/` |

## Escenarios y dónde se comprueban

| Historia | Escenario | Prueba automática | En el teléfono |
|---|---|---|---|
| HU-02 | Ubicación obtenida con buena señal (< 10 s) | ViewModel + widgets | **Sí, al aire libre**, cronometrando |
| HU-02 | Se ve que la app está buscando | ViewModel + widgets | Sí, dentro de un edificio |
| HU-02 | Permiso de ubicación denegado | ViewModel + widgets | Sí: negar al primer uso; luego «No volver a preguntar» |
| HU-02 | Precisión peor que 50 m | ViewModel + widgets | Sí: conceder solo «aproximada» (Android 12+) |
| HU-04 | Lista vacía · con datos · no se pueden leer | ViewModel + widgets (Sprint 1) | Con `--dart-define=DATOS=simulados` y el matraz |
| HU-04 | Doscientos reportes en menos de 1 s | Repositorio (lectura) + widgets (construcción) | **Sí, obligatorio**: `flutter run --profile`, gama de entrada |
| HU-05 | Abrir el detalle | Widgets | Sí |
| HU-05 | Volver a la lista en la misma posición | Widgets | Sí |
| HU-05 | Pantalla pequeña (360 dp) | Widgets | Sí |
| HU-10 | Compartir un reporte | Mensaje + ViewModel + widgets | **Sí**, enviándolo a un contacto |
| HU-10 | WhatsApp no está instalado | — (lo resuelve el sistema) | Sí, en un emulador sin WhatsApp |
| HU-10 | Compartir sin conexión | — (lo resuelve WhatsApp) | Sí, en modo avión |

**Cómo medir RC-03 (200 reportes en menos de 1 s).** En un Android de gama de entrada:
`flutter run --profile --dart-define=DATOS=simulados`, abrir DevTools → *Performance*, elegir «Doscientos reportes» en el
matraz y medir desde el toque hasta el primer cuadro con la lista. Anotar el teléfono, la versión de Android y el tiempo
en el issue de HU-04. Con los datos simulados se mide la interfaz; la lectura de SQLite se mide en la prueba del
repositorio.

## Para la Review (Hito 3)

1. Demo de punta a punta en un teléfono: abrir el formulario y ver cómo llega la ubicación; tomar la foto; guardar en modo
   avión; abrir el detalle; compartir por WhatsApp a un contacto del equipo; volver y ver la marca «Compartido».
2. Negar la ubicación y reportar igual, con referencia.
3. La migración: instalar la versión del Sprint 2, crear un reporte, instalar encima la del Sprint 3 y comprobar que el
   reporte sigue ahí.
4. La medición de RC-03 con el teléfono y el tiempo anotados.
5. Métricas: throughput del sprint y el elemento en curso de mayor edad.
