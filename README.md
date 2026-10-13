# EcoReporte

**Reporte ciudadano de puntos críticos de residuos · ODS 11 · Barrancabermeja**

Proyecto modelo del curso *Desarrollo de Aplicaciones Móviles* (Ingeniería Informática, VIII semestre, UNIPAZ). Muestra
cómo un equipo aplica el **Sprint 0** y el **Sprint 1** del marco del curso (Scrumban con fases de Mobile-D) con
**Flutter**. Es un ejemplo para estudiar, no para copiar: su problema es otro.

> **Estado: fin del Sprint 1 (semana 4), fase de Exploración.** Hay requisitos v0.1 y criterios de aceptación de las
> siete historias Must. El único código es la **prueba técnica del examen** (INV-04): «Mis reportes» con sus cuatro
> estados y el detalle, sobre datos simulados. **Falta la validación con vecinos reales (INV-02).**

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
| 1 | Review, Retrospectiva y Planning | [`docs/sprints/sprint-0.md`](docs/sprints/sprint-0.md) · [`docs/sprints/sprint-1.md`](docs/sprints/sprint-1.md) |
| 1 | Persona, mapa, MVP, calidad, heurísticas | [`docs/requisitos.md`](docs/requisitos.md) (v0.1) |
| 1 | Criterios Dado / Cuando / Entonces | [`docs/criterios/`](docs/criterios/) · cuerpos de issue en [`scripts/issues/`](scripts/issues/) |
| 1 | Validación con usuarios (pendiente) | [`docs/validacion/`](docs/validacion/) |
| 1 | Examen práctico resuelto | [`docs/examen-sprint1.md`](docs/examen-sprint1.md) |
| 1 | Prueba técnica en Flutter | [`lib/`](lib/) · [`test/`](test/) |

## Ejecutar la prueba técnica

Requisitos del curso: Flutter 3.47 / Dart 3.13, Android SDK API 36 y un Android con depuración USB (o un emulador).

```powershell
# 1. Generar la carpeta android/ (no se versiona en el modelo: depende del SDK de cada equipo).
#    flutter create no sobrescribe los archivos que ya existen.
flutter create --org co.edu.unipaz.dam --project-name eco_reporte --platforms=android .

# 2. Dependencias, análisis y pruebas
flutter pub get
flutter analyze        # meta: No issues found!
flutter test           # 12 pruebas: los escenarios de HU-04 y HU-05

# 3. A correr
flutter run
```

En modo de desarrollo, el icono de matraz de la barra superior cambia el escenario: **con datos**, **vacío**, **falla al
leer** y **cargando sin fin**. Así se ven en el teléfono los cuatro estados de la lista.

**Arquitectura (MVVM del curso):** `domain/` (modelo) · `data/` (repositorio: hoy simulado, en el Sprint 2 SQLite) ·
`ui/` (pantallas que leen un `ChangeNotifier` con `context.watch`) · `app/` (Provider, `go_router` y tema). Paquetes:
`material_ui`, `provider` y `go_router`.

## Ramas y forma de trabajar

- `main` está protegida: todo entra por pull request con una revisión.
- Una rama por elemento del backlog: `hu-04-lista-reportes`, `tec-02-sqlite`, `inv-04-…`.
- El PR dice `Closes #N` para cerrar el issue y mover la tarjeta a «Hecho» al fusionar.
- La prueba técnica del examen se hizo en `examen/sprint1-tecnico` y se fusionó tras la revisión. `git log --graph
  --oneline` muestra la historia por sprints.

## Historial de sprints

| Sprint | Semana | Objetivo | Throughput | Resultado |
|---|---|---|---|---|
| 0 | 3 | Tablero y backlog listos para trabajar | 0 (línea de base) | Hecho |
| 1 | 4 | Las historias Must tienen criterios de aceptación validados con dos vecinos del barrio | 3 (INV-01, INV-03, INV-04) | Criterios hechos; **validación pendiente** |

## Usar este repositorio en clase

1. Leerlo junto a las guías-taller **22 · Sprint 0** y **23 · Sprint 1**: cada archivo dice a qué paso responde.
2. Para practicar el tablero: crear un proyecto propio en GitHub Projects (`docs/tablero.md`) y cargar el backlog con
   `scripts/crear-backlog.ps1`.
3. Para el examen del Sprint 1: comparar el formato de `docs/examen-sprint1.md` con lo que entregó el equipo, y la
   prueba técnica con la parte 2 del examen.

---
Desarrollo de Aplicaciones Móviles · Ingeniería Informática · UNIPAZ · 2026
