# Product Backlog de EcoReporte

> El orden de esta tabla es el orden de la vista «Backlog» del tablero: el PO lo mantiene. Cada fila es un issue del
> repositorio; `scripts/crear-backlog.ps1` los crea todos con `gh`.

**Épicas:** Base (técnicas) · Reportar · Consultar · Sincronizar · Comunidad.
**Historia de referencia:** HU-05 «abrir el detalle de un reporte» = **2 puntos**. Escala: 1, 2, 3, 5, 8. Nada de 13.

## Plan de cierre · estado al final del Sprint 4 (cierre del curso)

El curso se cierra en tres sprints (`docs/plan-de-cierre.md`). Esta tabla manda sobre las de abajo, que quedan como
historia del refinamiento.

| ID | Elemento | Pts | Sprint | Estado |
|---|---|---|---|---|
| TEC-01 | Proyecto Flutter con `material_ui` | 2 | 0 | Hecho |
| TEC-02 | Modelo `Reporte` y repositorio SQLite | 3 | 2 | Hecho cuando su ficha de prueba en dispositivo esté completa |
| HU-01 | Tomar la foto del punto crítico | 3 | 2 | Hecho cuando su ficha de prueba en dispositivo esté completa |
| HU-12 | Referencia del lugar | 2 | 2 | Hecho cuando su ficha de prueba en dispositivo esté completa |
| HU-03 | Guardar el reporte en el teléfono | 3 | 2 | Hecho cuando su ficha de prueba en dispositivo esté completa |
| HU-02 | Ubicación automática | 3 | 3 | Hecho cuando su ficha de prueba en dispositivo esté completa |
| HU-04 | Lista de mis reportes | 3 | 3 | Hecho cuando RC-03 esté medido en el teléfono |
| HU-05 | Detalle de un reporte | 2 | 3 | Hecho cuando su ficha de prueba en dispositivo esté completa |
| HU-10 | Compartir por WhatsApp | 2 | 3 | Hecho cuando se haya enviado a un contacto real |
| TEC-04 | Calidad: plan de pruebas, accesibilidad, medición en gama de entrada | 3 | 4 | Fusionado · faltan las mediciones de RC en el teléfono |
| TEC-05 | Seguridad y privacidad (OWASP Mobile Top 10, Ley 1581) | 3 | 4 | Fusionado · falta revisar el manifiesto combinado |
| TEC-06 | Build de release firmado | 2 | 4 | Fusionado · falta firmar con la llave del equipo |
| INV-02 | Validar con dos vecinos, ahora con la app instalada | 3 | 4 | Protocolo listo · **falta la prueba** |
| INV-05 | Demo Day: pitch, modelo de impacto y guion de la demo | 3 | 4 | Guion listo · falta ensayarlo |
| HU-06, 07, 08, 09, 13 · TEC-03 · HU-11 | Should y Could | 30 | — | Fuera del cierre (HU-06 y HU-09 pasan al Sprint 5, abajo) |

## Después del cierre · Sprint 5 (versión 1.1.0)

| ID | Elemento | Pts | Sprint | Estado |
|---|---|---|---|---|
| HU-06 | Tipo de residuo | 2 | 5 | Construida · falta su ficha de prueba en dispositivo |
| HU-09 | Exportar el listado del mes | 5 | 5 | Construida · falta abrir el archivo en Excel en un computador en español |
| HU-07, HU-13, HU-08, HU-11 | Sincronizar, mapa y avisos | 21 | — | Esperan la decisión sobre el servidor |
| TEC-03 | Firebase App Distribution | 2 | — | Espera |

## Backlog refinado · fin del Sprint 1 (semana 4)

La línea marca el corte del MVP que se mostrará en el Hito 2 (semana 8).

| Orden | ID | Épica | Elemento | MoSCoW | Pts | Escenarios |
|---|---|---|---|---|---|---|
| 1 | TEC-01 | Base | Crear el proyecto Flutter, migrarlo a `material_ui` y configurar ramas y protección de `main` | Must | 2 | — |
| 2 | TEC-02 | Base | Modelo `Reporte` y repositorio SQLite con sus pruebas | Must | 3 | — |
| 3 | HU-01 | Reportar | Como vecina, quiero tomar una foto del punto crítico para mostrar el estado real del lugar | Must | 3 | 4 |
| 4 | HU-02 | Reportar | Como vecina, quiero que la app tome mi ubicación automáticamente para no tener que escribir la dirección del punto | Must | 3 | 4 |
| 5 | HU-12 | Reportar | Como vecina, quiero añadir una referencia del lugar para que quien recoja lo encuentre aunque el GPS falle por unos metros | Must ↑ | 2 | 3 |
| 6 | HU-03 | Reportar | Como vecina, quiero guardar el reporte en mi teléfono aunque no tenga datos, para no perderlo | Must | 3 | 6 |
| 7 | HU-04 | Consultar | Como vecina, quiero ver la lista de mis reportes para saber cuáles ya hice | Must | 3 | 4 |
| 8 | HU-05 | Consultar | Como vecina, quiero abrir el detalle de un reporte para ver la foto y el lugar | Must | 2 | 3 |
| 9 | HU-10 | Comunidad | Como vecina, quiero compartir un reporte por WhatsApp para avisar a mis vecinos | Must ↑ | 2 | 3 |
| | | | **— línea del MVP · 9 elementos · 23 puntos —** | | | |
| 10 | HU-06 | Reportar | Como vecina, quiero elegir la categoría del residuo para que la empresa sepa qué recoger | Should | 2 | — |
| 11 | HU-07 | Sincronizar | Como vecina, quiero subir mis reportes pendientes con un botón | Should | 3 | — |
| 12 | HU-13 | Sincronizar | Como vecina, quiero que mis reportes pendientes se suban solos al recuperar la conexión | Should | 5 | — |
| 13 | HU-09 | Comunidad | Como presidenta de la JAC, quiero exportar el listado del mes para llevarlo a la empresa de aseo | Should | 5 | — |
| 14 | HU-08 | Consultar | Como vecina, quiero ver en un mapa los reportes de mi barrio para no repetir uno que ya existe | Should | 5 | — |
| 15 | TEC-03 | Base | Configurar Firebase App Distribution para repartir el APK de prueba | Should | 2 | — |
| 16 | HU-11 | Comunidad | Como vecina, quiero recibir un aviso cuando se recoja un punto que reporté para saber que sirvió | Could | 8 | — |

**Total:** 16 elementos · 53 puntos. **MVP:** 9 elementos · 23 puntos · **43 %** del backlog · 4 de 4 actividades cubiertas.
↑ = subió de prioridad en el Sprint 1. Los escenarios de cada historia Must están en `docs/criterios/`.

### Qué cambió al refinar, y por qué

| Elemento | Antes (Sprint 0) | Después (Sprint 1) | Motivo |
|---|---|---|---|
| HU-03 | Guardar y enviar cuando haya señal · 5 pts | Guardar en el teléfono · 3 pts | Mezclaba su trabajo con el de HU-07 |
| HU-07 | Subida automática · 8 pts | Subir con un botón · 3 pts | Partida por **caminos** (P de SPIDR); antes, una investigación de 2 h sobre el backend |
| HU-13 | — | Subida automática · 5 pts | El otro camino de HU-07 |
| HU-12 | — | Referencia del lugar · Must · 2 pts | Nació en el mapa de experiencia (el lote no tiene nomenclatura) y la exige un escenario de HU-02 |
| HU-10 | Could | Must | Cierra la actividad «Hacer que llegue a alguien» en el MVP |
| «vecino» | — | «vecina» | La persona principal es Yolanda |

## Elementos de investigación del Sprint 1

No suman al backlog del producto: son el trabajo del sprint que no es historia ni código. Tipo «Investigación», etiqueta
`investigacion`. Pasan de «En revisión» a «Hecho» sin pasar por «En dispositivo».

| ID | Elemento | Pts | Responsable | Estado |
|---|---|---|---|---|
| INV-01 | Proto-persona y mapa de experiencia de la vecina | 1 | Todo el equipo | Hecho |
| INV-02 | Validar los criterios con dos vecinos del barrio Primero de Mayo | 3 | PO y líder de UX/UI | **Pendiente** de la visita |
| INV-03 | Documento de requisitos v0.1 en `docs/requisitos.md` | 2 | Scrum Master | Hecho |
| INV-04 | Prueba técnica del examen: HU-04 y HU-05 con datos simulados | 3 | Pareja técnica | Hecho |
