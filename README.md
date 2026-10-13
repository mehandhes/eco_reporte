# EcoReporte

**Reporte ciudadano de puntos críticos de residuos · ODS 11 · Barrancabermeja**

Proyecto modelo del curso *Desarrollo de Aplicaciones Móviles* (Ingeniería Informática, VIII semestre, UNIPAZ). Muestra
cómo un equipo aplica el **Sprint 0** y el **Sprint 1** del marco del curso (Scrumban con fases de Mobile-D) con
**Flutter**. Es un ejemplo para estudiar, no para copiar: su problema es otro.

> **Estado: fin del Sprint 0 (semana 3).** Hay visión, alcance, backlog, tablero y reglas de trabajo. Todavía no hay
> código.

## Objetivo del Producto

> «Que cualquier vecino reporte un punto crítico de residuos en menos de un minuto, incluso sin conexión, y que su JAC
> reciba un listado mensual verificable».

**Para** los vecinos de los barrios de Barrancabermeja **que** ven puntos de basura acumulada y no saben a quién avisar,
**EcoReporte es una** app móvil de reporte ciudadano **que** permite reportar un punto crítico con foto y ubicación en
menos de un minuto. **A diferencia de** llamar a la línea de atención o escribir en grupos de Facebook, **nuestro
producto** deja un registro georreferenciado que funciona sin conexión y que la Junta de Acción Comunal puede llevar a la
empresa de aseo.

## Dónde está cada cosa

| Sprint | Paso de la guía | Archivo |
|---|---|---|
| 0 | Visión, Objetivo del Producto, MoSCoW y fuera del alcance | [`docs/vision-y-alcance.md`](docs/vision-y-alcance.md) |
| 0 | Backlog ordenado y estimado | [`docs/backlog.md`](docs/backlog.md) |
| 0 | Tablero en GitHub Projects | [`docs/tablero.md`](docs/tablero.md) · [`scripts/crear-backlog.ps1`](scripts/crear-backlog.ps1) |
| 0 | Definición del Flujo de Trabajo y Definición de Terminado | [`docs/flujo-de-trabajo.md`](docs/flujo-de-trabajo.md) |
| 0 | Plantillas de issue y de pull request | [`.github/`](.github/) |
| 0 | Roles, entregable y planificación del Sprint 1 | [`docs/sprints/sprint-0.md`](docs/sprints/sprint-0.md) |


## Ramas y forma de trabajar

- `main` está protegida: todo entra por pull request con una revisión.
- Una rama por elemento del backlog: `hu-04-lista-reportes`, `tec-02-sqlite`, `inv-04-…`.
- El PR dice `Closes #N` para cerrar el issue y mover la tarjeta a «Hecho» al fusionar.

## Historial de sprints

| Sprint | Semana | Objetivo | Throughput | Resultado |
|---|---|---|---|---|
| 0 | 3 | Tablero y backlog listos para trabajar | 0 (línea de base) | Hecho |

## Usar este repositorio en clase

1. Leerlo junto a las guías-taller **22 · Sprint 0** y **23 · Sprint 1**: cada archivo dice a qué paso responde.
2. Para practicar el tablero: crear un proyecto propio en GitHub Projects (`docs/tablero.md`) y cargar el backlog con
   `scripts/crear-backlog.ps1`.

---
Desarrollo de Aplicaciones Móviles · Ingeniería Informática · UNIPAZ · 2026
