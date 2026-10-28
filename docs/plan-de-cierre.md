# Plan de cierre · tres sprints en tres semanas

> Decisión del curso tomada al terminar el Sprint 1: el proyecto se cierra en **tres semanas**. Quedan tres sprints de
> una semana, de Sesión B a Sesión B, con las mismas ceremonias del marco del curso (Scrumban con fases de Mobile-D).
> Este documento es la Planning de los tres a la vez: el PO y el equipo lo revisan al inicio de cada sprint.

## Qué se recorta y qué no

| Se mantiene | Se recorta |
|---|---|
| Las **7 historias Must** del MVP con todos sus escenarios | Las Should (HU-06, 07, 08, 09, 13) y la Could (HU-11): quedan en el backlog para después del curso |
| La **Definición de Terminado base**: PR revisado, `flutter analyze` limpio, pruebas, Android físico, 360 dp, cuatro estados, permisos denegados, 48 dp, contraste | La sincronización con un servidor: no hay API ni backend en el alcance |
| Una Review con el docente al final de cada sprint (Hitos 2, 3 y 4) | Firebase App Distribution (TEC-03): el APK se reparte a mano o por Drive |
| La validación con usuarios (INV-02), ahora sobre la app que funciona | |

**Consecuencia para el Hito 3.** La rúbrica pide integración con API, persistencia y dispositivo. Sin HU-07 no hay API:
el equipo presenta **persistencia (SQLite) + tres capacidades del dispositivo (cámara, GPS, compartir con otras apps)** y
lo dice en la Review. El docente decide si eso basta o si se agrega HU-07 (3 puntos) al Sprint 4.

## Los tres sprints

| Sprint | Semana | Fase de Mobile-D | Objetivo del Sprint | Elementos | Pts | Cierra |
|---|---|---|---|---|---|---|
| **2** | 1 | Inicialización → Producción | «Una vecina crea un reporte con foto y referencia, sin conexión, y lo ve en *Mis reportes*» | TEC-02 · HU-01 · HU-12 · HU-03 | 11 | **Hito 2** · MVP navegable |
| **3** | 2 | Producción | «El reporte dice dónde está el punto y llega a los vecinos por WhatsApp» | HU-02 · HU-04 · HU-05 · HU-10 | 10 | **Hito 3** · integración |
| **4** | 3 | Estabilización · Prueba y corrección | «La app es segura, accesible y se instala desde un APK firmado» | TEC-04 · TEC-05 · TEC-06 · INV-02 · INV-05 | 11 | **Hito 4** y **Hito 5** · Demo Day |

**Por qué este orden.** El Sprint 2 corta el producto de punta a punta (capturar → guardar → ver) en vez de construir
capas: al final de la primera semana ya hay algo que una vecina puede usar. La ubicación (HU-02) espera al Sprint 3
porque el reporte funciona sin ella —la referencia es obligatoria mientras no hay GPS— y así el riesgo del GPS no
bloquea el Hito 2.

**Capacidad.** Cada integrante declara en la Planning sus horas reales hasta la próxima Sesión B, como en el Sprint 1.
Si el plan no cabe, se recorta por escenarios (la S de SPIDR) o se pasa un elemento al sprint siguiente, nunca se
recorta la Definición de Terminado. Los 10 a 11 puntos por sprint de este plan son los de EcoReporte; cada equipo
estima los suyos.

## Elementos nuevos del Sprint 4

| ID | Elemento | Tipo | Pts |
|---|---|---|---|
| TEC-04 | Calidad: plan de pruebas que enlaza cada escenario con su prueba, accesibilidad automática y medición en un Android de gama de entrada | Técnica | 3 |
| TEC-05 | Seguridad y privacidad: OWASP Mobile Top 10 (2024), aviso de privacidad según la Ley 1581 de 2012, permisos mínimos y sin copia en la nube | Técnica | 3 |
| TEC-06 | Build de release: firma, ofuscación, versión 1.0.0 y APK distribuible | Técnica | 2 |
| INV-05 | Demo Day: pitch de 5 minutos, modelo de impacto y guion de la demo | Investigación | 3 |

INV-02 (validar con vecinos) estaba pendiente desde el Sprint 1. En el Sprint 4 se hace **sobre la app instalada**: es la
prueba de usabilidad de RC-01 («crea su primer reporte en menos de un minuto y sin ayuda»).

## Calendario de ceremonias

| Momento | Qué pasa | Duración |
|---|---|---|
| Inicio de cada Sesión B | Review del sprint que termina (con el docente en las de hito) → Retrospectiva → Planning del siguiente | 15 + 10 + 20 min |
| Inicio de cada sesión | Daily | 10 min |
| Lunes, miércoles y viernes | Daily asíncrono en tres líneas (experimento del Sprint 1) | — |
| Última Sesión B | Demo Day: pitch, demo en vivo y defensa | según el docente |
