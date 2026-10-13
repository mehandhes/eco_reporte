# El tablero de EcoReporte en GitHub Projects

> Sprint 0 · Paso 5. Lo configura el Scrum Master. Si se clona este repositorio para practicar, hay que crear el proyecto
> propio: un proyecto de GitHub no viaja con el repositorio.

## 1. Crear el proyecto y enlazarlo

1. Perfil (u organización del equipo) → **Projects** → **New project** → plantilla en blanco **Board**.
2. **Nombre:** `EcoReporte`. **Descripción:** el Objetivo del Producto de `docs/vision-y-alcance.md`.
3. En el repositorio: pestaña **Projects** → **Link a project** → `EcoReporte`.
4. Proyecto → **⋯ → Settings → Manage access**: rol **Write** a cada integrante y **Read** al docente.

## 2. Columnas, límites y campos

**Status** (columnas, en este orden): Backlog · Listo · En desarrollo · En revisión · En dispositivo · Hecho.

**Límites WIP** (menú de cada columna → *Set column limit*, solo en vistas Board): Listo 5 · En desarrollo 4 ·
En revisión 2 · En dispositivo 2.

**Campos personalizados** (vista de tabla → **+** → *New field*):

| Campo | Tipo | Valores |
|---|---|---|
| Tipo | Single select | Historia · Técnica · Defecto · Investigación |
| Prioridad | Single select | Must · Should · Could |
| Épica | Single select | Base · Reportar · Consultar · Sincronizar · Comunidad |
| Puntos | Number | 1 · 2 · 3 · 5 · 8 |
| Sprint | Iteration | 1 semana, empezando el día de la Sesión B de la semana 3 |

## 3. Cargar el backlog

Con GitHub CLI, desde la carpeta del repositorio:

```powershell
gh auth refresh -s project              # una sola vez
.\scripts\crear-backlog.ps1 -Proyecto "EcoReporte"
```

El script crea las etiquetas (`historia`, `tecnica`, `defecto`, `investigacion`, `bloqueada`) y un issue por elemento de
`docs/backlog.md`, ya añadido al proyecto. Después, en la vista de tabla, se rellenan **Tipo, Prioridad, Épica, Puntos y
Sprint** de cada fila (se puede copiar y pegar un valor en varias celdas).

## 4. Vistas

| Vista | Layout | Configuración |
|---|---|---|
| **Backlog** | Table | Filtro `-status:Hecho`, orden manual del PO, *View → Field sum → Puntos* |
| **Sprint actual** | Board | Columnas por Status, filtro `sprint:@current`. Es la que se proyecta en el Daily |
| **Por épica** | Table | *View → Group by → Épica*. Sirve para el documento del Hito 1 |

## 5. Flujos automáticos

**⋯ → Workflows**: activar *Item added to project* → Backlog; *Item closed* → Hecho; *Pull request merged* → Hecho.
El PR que dice `Closes #N` cierra el issue al fusionarse y la tarjeta llega sola a «Hecho». Antes de fusionar, la tarjeta
tiene que haber pasado por «En dispositivo».

## Errores frecuentes

| Síntoma | Qué hacer |
|---|---|
| No aparece *Set column limit* | La vista está en Table o Roadmap: cámbiala a Board |
| `gh` responde «missing required scopes» | `gh auth refresh -s project` |
| Un compañero no puede mover tarjetas | Proyecto → Settings → Manage access → rol Write |
| La plantilla de issue no sale | Debe estar en `.github/ISSUE_TEMPLATE/`, terminar en `.yml` y estar en `main` |
