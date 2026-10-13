# Product Backlog de EcoReporte

> El orden de esta tabla es el orden de la vista «Backlog» del tablero: el PO lo mantiene. Cada fila es un issue del
> repositorio; `scripts/crear-backlog.ps1` los crea todos con `gh`.

**Épicas:** Base (técnicas) · Reportar · Consultar · Sincronizar · Comunidad.
**Historia de referencia:** HU-05 «abrir el detalle de un reporte» = **2 puntos**. Escala: 1, 2, 3, 5, 8. Nada de 13.

## Backlog inicial · Sprint 0 (semana 3)

| Orden | ID | Épica | Elemento | MoSCoW | Pts |
|---|---|---|---|---|---|
| 1 | TEC-01 | Base | Crear el proyecto Flutter, migrarlo a `material_ui` y configurar ramas y protección de `main` | Must | 2 |
| 2 | HU-01 | Reportar | Como vecino, quiero tomar una foto del punto crítico para mostrar el estado real del lugar | Must | 3 |
| 3 | HU-02 | Reportar | Como vecino, quiero que la app tome mi ubicación automáticamente para no escribir la dirección | Must | 3 |
| 4 | TEC-02 | Base | Modelo `Reporte` y repositorio SQLite con sus pruebas | Must | 3 |
| 5 | HU-03 | Reportar | Como vecino, quiero guardar el reporte aunque no tenga datos para enviarlo cuando tenga señal | Must | 5 |
| 6 | HU-04 | Consultar | Como vecino, quiero ver la lista de mis reportes para saber cuáles ya hice | Must | 3 |
| 7 | HU-05 | Consultar | Como vecino, quiero abrir el detalle de un reporte para ver la foto y el lugar | Must | 2 |
| 8 | HU-06 | Reportar | Como vecino, quiero elegir la categoría del residuo para que la empresa sepa qué recoger | Should | 2 |
| 9 | HU-09 | Comunidad | Como presidenta de la JAC, quiero exportar el listado del mes para llevarlo a la empresa de aseo | Should | 5 |
| 10 | HU-07 | Sincronizar | Como vecino, quiero que mis reportes se suban solos a la nube al recuperar la conexión | Should | 8 |
| 11 | HU-08 | Consultar | Como vecino, quiero ver en un mapa los reportes de mi barrio para no repetir uno que ya existe | Should | 5 |
| 12 | TEC-03 | Base | Configurar Firebase App Distribution para repartir el APK de prueba | Should | 2 |
| 13 | HU-10 | Comunidad | Como vecino, quiero compartir un reporte por WhatsApp para avisar a mis vecinos | Could | 2 |
| 14 | HU-11 | Comunidad | Como vecino, quiero recibir un aviso cuando se recoja un punto que reporté para saber que sirvió | Could | 8 |

**Total:** 14 elementos · 53 puntos · Must 21 puntos (40 %).
