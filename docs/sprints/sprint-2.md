# Sprint 2 · semana 1 del cierre · Inicialización → Producción

> Primer sprint con código de producto. Cierra el **Hito 2 (MVP navegable)**. Plan general en `docs/plan-de-cierre.md`.

## Sprint Planning

**¿Por qué es valioso este sprint?** Objetivo del Sprint:
> «Una vecina crea un reporte con foto y referencia, sin conexión, y lo ve en *Mis reportes*».

**¿Qué se puede terminar?**

| ID | Elemento | Pts | Rama | Depende de |
|---|---|---|---|---|
| TEC-02 | Modelo `Reporte` y repositorio SQLite con sus pruebas | 3 | `tec-02-sqlite` | — |
| HU-01 | Tomar la foto del punto crítico | 3 | `hu-01-tomar-foto` | — |
| HU-12 | Referencia del lugar | 2 | `hu-12-referencia-lugar` | HU-01 (el formulario) |
| HU-03 | Guardar el reporte en el teléfono | 3 | `hu-03-guardar-en-telefono` | TEC-02, HU-01, HU-12 |

**Total: 11 puntos.** TEC-02 y HU-01 arrancan en paralelo el primer día; HU-12 y HU-03 los cierran.

**¿Cómo se hará?** Decisiones técnicas tomadas en la Planning:

1. **El repositorio cambia, las pantallas no.** `ReporteRepository` ya existía desde INV-04; TEC-02 solo añade
   `guardar()` y una segunda implementación. `main.dart` decide cuál se inyecta.
2. **La cámara detrás de un contrato** (`FuenteFotos`), con un resultado `sealed` de cuatro casos: foto, cancelada,
   permiso negado y fallo. Las pruebas usan una cámara falsa; ninguna prueba necesita un teléfono.
3. **Ningún archivo temporal se referencia desde la base.** La foto se copia a la carpeta privada de la app al guardar
   (`AlmacenFotos`), no al tomarla: si la vecina cancela, no queda basura.
4. **Sin GPS todavía:** mientras HU-02 no exista, la referencia es obligatoria. Así el reporte siempre dice dónde está.
5. **RC-04 desde el principio:** la foto se pide reducida a 1600 px y calidad 70.

## Lo que produjo

| Elemento | Resultado | Dónde quedó |
|---|---|---|
| TEC-02 | Tabla `reportes` con índice por fecha; `Reporte.aFila()` / `desdeFila()`; `BorradorReporte` para lo que aún no tiene id | `lib/data/repositorio_sqlite.dart`, `lib/domain/reporte.dart` |
| HU-01 | Formulario en `/nuevo`; miniatura, repetir, galería; explicación si se niega la cámara; recuperación de la foto si Android cierra la app | `lib/ui/nuevo/`, `lib/data/fotos/` |
| HU-12 | Campo con límite de 120 y contador «Te quedan N caracteres»; obligatorio sin ubicación | `lib/ui/nuevo/campo_referencia.dart` |
| HU-03 | Guardar sin conexión, con doble toque, falta de foto, falta de espacio y confirmación que dice qué sigue; lista y detalle con la foto real | `lib/ui/nuevo/`, `lib/data/fotos/almacen_fotos.dart` |
| Pruebas | De 12 a 39: 6 del repositorio SQLite, 13 del formulario, 3 del almacén de fotos y 5 de widgets | `test/` |

## Escenarios y dónde se comprueban

| Historia | Escenario | Prueba automática | En el teléfono |
|---|---|---|---|
| HU-01 | Foto tomada | `nuevo_reporte_viewmodel_test` | Sí |
| HU-01 | Permiso de cámara denegado | ViewModel + widgets | Sí: negar el permiso al primer uso |
| HU-01 | Cancelar no borra lo demás | ViewModel | Sí |
| HU-01 | Una llamada a mitad del formulario | ViewModel (foto recuperada) | **Sí, obligatorio**: llamar al teléfono con el formulario lleno |
| HU-12 | Escribir una referencia | Widgets (HU-03) | Sí |
| HU-12 | Sin ubicación, la referencia es obligatoria | ViewModel + widgets | Sí |
| HU-12 | Referencia demasiado larga | Widgets | Sí: pegar un texto largo |
| HU-03 | Guardar sin conexión | ViewModel + widgets | **Sí, en modo avión** |
| HU-03 | Sobrevive al cierre | Repositorio SQLite | **Sí**: cerrar la app desde recientes y abrirla |
| HU-03 | Falta la foto | ViewModel + widgets | Sí |
| HU-03 | Doble toque | ViewModel | Sí |
| HU-03 | Sin espacio en el teléfono | ViewModel (almacén falso) | Difícil de provocar: se acepta la prueba automática |
| HU-03 | La confirmación dice qué sigue | Widgets | Sí |

**Límite conocido.** Si Android mata la app *mientras el formulario está abierto pero sin la cámara* (pasa con poca
memoria y llamadas largas), se pierde la referencia escrita. La foto sí se recupera. Guardar el borrador en disco se
deja como candidato para después del curso; no lo pide ningún escenario.

## Definición de Terminado · estado al cierre

| Casilla | TEC-02 | HU-01 | HU-12 | HU-03 |
|---|---|---|---|---|
| Criterios comprobados en Android físico | n/a | ☐ | ☐ | ☐ |
| PR revisado y fusionado | ✔ | ✔ | ✔ | ✔ |
| `flutter analyze` limpio y pruebas pasan | ☐ | ☐ | ☐ | ☐ |
| 360 dp sin desbordes | n/a | ☐ | ☐ | ☐ |
| Permiso denegado manejado | n/a | ✔ | n/a | n/a |
| Áreas táctiles de 48 dp | n/a | ✔ | ✔ | ✔ |

> Las casillas vacías las marca el equipo después de correr `flutter analyze`, `flutter test` y la lista de la columna
> «En el teléfono» en un Android físico. En este repositorio modelo no se marcan por adelantado.

## Para la Review (Hito 2)

1. Demo en un teléfono **en modo avión**: tomar la foto, escribir la referencia, guardar, ver el reporte de primero,
   cerrar la app y abrirla otra vez.
2. Negar el permiso de cámara y mostrar la salida por la galería.
3. Las pruebas en verde (`flutter test`) y `flutter analyze` sin problemas.
4. Métricas: throughput del sprint (meta: 4) y el elemento en curso de mayor edad.
5. Pregunta para el docente: ¿el Hito 3 se acepta sin API (ver `docs/plan-de-cierre.md`)?
