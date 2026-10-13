# Examen práctico · Sprint 1 · Flutter + Dart

> **Modelo resuelto** con el proyecto EcoReporte, sobre la plantilla del examen `24_Examen_Sprint1_Flutter_DAM.html`
> (versión de máximo 3 horas). Un equipo real escribe esto sobre **su propio** proyecto: copiar este contenido no
> puntúa.

- **Equipo y proyecto:** Equipo modelo · EcoReporte
- **Integrantes y rol:** Integrante 1 (PO) · Integrante 2 (Scrum Master) · Integrante 3 (líder de UX/UI) ·
  Integrante 4 (Developer). Los cuatro son Developers.
- **Historia técnica:** HU-04 · **Otra historia Must:** HU-05

## 1. Persona y mapa de hoy
- **Contexto:** Yolanda Pérez, 46 años, tendera del barrio Primero de Mayo. Atiende de 7 a. m. a 8 p. m. y ve el lote
  de la esquina cada vez que abre.
- **Teléfono y conexión:** Android de gama de entrada con poco espacio libre *(por validar)*; datos prepago que no le
  alcanzan para todo el mes *(por validar)*; WhatsApp a diario.
- **Quiere lograr:** que recojan el punto sin dejar la tienda sola ni pasar media hora en una llamada.
- **La frena hoy:** no sabe a quién avisar ni cómo dar la dirección exacta; cuando avisó, nunca supo si sirvió
  *(por validar)*.
- **Una frase suya:** «Yo llamo, me piden la nomenclatura, y ese lote no tiene. Al final uno se cansa.» *(supuesta)*

| | 1 · Ve el punto | 2 · Avisa | 3 · Espera | 4 · No sabe qué pasó |
|---|---|---|---|---|
| **Hace** | Ve bolsas nuevas en el lote al abrir la tienda | Llama a la línea de aseo y publica una foto en el grupo del barrio | Mira el lote cada mañana | Deja de avisar la siguiente vez |
| **Dolor** | — | No puede dar la ubicación; la llamada es larga | No queda constancia de que avisó | Nadie le responde |
| **Historia** | HU-01 | HU-01 · HU-02 · HU-12 · HU-03 | **HU-04** · **HU-05** | HU-10 · HU-09 |

## 2. Criterios de aceptación

### HU-04 · Lista de mis reportes (historia técnica)
```gherkin
# language: es
Escenario: Lista con datos
  Dado que tengo varios reportes
  Cuando abro «Mis reportes»
  Entonces los veo del más reciente al más antiguo
  Y cada uno muestra miniatura, fecha y lugar

Escenario: No se pueden leer
  Dado que los reportes guardados no se pueden leer
  Cuando abro «Mis reportes»
  Entonces veo un mensaje en lenguaje llano
  Y puedo reintentar

Escenario: Lista vacía
  Dado que todavía no he hecho ningún reporte
  Cuando abro «Mis reportes»
  Entonces veo un mensaje que me invita a crear el primero
  Y la forma de hacerlo
```
**Revisó:** Integrante 3

### HU-05 · Detalle de un reporte
```gherkin
# language: es
Escenario: Abrir el detalle
  Dado que estoy en «Mis reportes»
  Cuando elijo un reporte
  Entonces veo su foto en grande, la fecha y la hora, y el lugar

Escenario: Volver a la lista
  Dado que abrí un detalle desde la mitad de la lista
  Cuando vuelvo atrás
  Entonces la lista está en la misma posición

Escenario: Pantalla pequeña
  Dado un teléfono de 360 dp de ancho
  Cuando abro el detalle
  Entonces todo se lee sin cortarse y sin desplazarme de lado
```
**Revisó:** Integrante 4. *Observación de la revisión:* HU-05 no tiene escenario de error propio; el equipo decide que lo
cubre HU-04 y lo deja como pregunta para el Sprint 2.

## 3. MVP y calidad

| Actividad | Historia del MVP |
|---|---|
| Capturar el punto | HU-01 · HU-02 · HU-12 |
| Guardar el reporte | HU-03 |
| Consultar mis reportes | HU-04 · HU-05 |
| Hacer que llegue a alguien | HU-10 |

- **Puntos del MVP:** 23 de 53 (43 %), con TEC-01 y TEC-02.
- **Requisito de calidad 1:** «Mis reportes» se muestra en menos de 1 s con 200 reportes guardados, en un Android de gama
  de entrada (vive en HU-04).
- **Requisito de calidad 2:** ningún reporte guardado se pierde si la app se cierra, el teléfono se apaga o se queda sin
  batería (vive en HU-03).

## 4. Prueba técnica · Flutter + Dart
- **Pull request:** `examen/sprint1-tecnico` → `main` (en este repositorio modelo ya está revisado y fusionado; ver
  `git log --graph`).
- **Dispositivo:** *(el equipo anota aquí su Android y versión)*
- **Analizador** (`flutter analyze`): *(el equipo pega aquí el resultado)*

Lo que construyó la pareja técnica, en `lib/`:

| Archivo | Qué hace |
|---|---|
| `domain/reporte.dart` | El modelo, con los campos de HU-04 y HU-05 |
| `data/reporte_repository.dart` | El contrato de datos que conocen los ViewModel |
| `data/repositorio_simulado.dart` | Seis reportes del barrio y los cuatro escenarios, con 1,5 s de retardo |
| `ui/reportes/reportes_viewmodel.dart` | `ChangeNotifier` con `EstadoUi { cargando, vacio, error, listo }` |
| `ui/reportes/pantalla_reportes.dart` | Los cuatro estados con un `switch` sobre el enum |
| `ui/reportes/selector_escenario.dart` | Menú de escenarios, solo en modo de desarrollo |
| `ui/detalle/pantalla_detalle.dart` | HU-05, por id con `go_router` |
| `test/` | Los escenarios de HU-04 y HU-05 como pruebas automáticas |

| Escenario | ¿Cumple? (sí / no / aún no aplica) | Por qué |
|---|---|---|
| HU-04 · Lista con datos | **No del todo** | Ordena del más reciente al más antiguo, con fecha y lugar; la miniatura es un hueco porque la foto llega con HU-01 |
| HU-04 · No se pueden leer | Sí | Mensaje en lenguaje llano y «Reintentar» que vuelve a cargar |
| HU-04 · Lista vacía | Sí, a medias | Invita a crear el primero; la acción avisa que crear llega con HU-01 |
| HU-05 · Abrir el detalle | No del todo | Fecha, hora y lugar sí; la foto en grande es un hueco (HU-01) |
| HU-05 · Volver a la lista | Sí | La ruta del detalle es hija de `/`: la lista sigue en la pila con su posición |
| HU-05 · Pantalla pequeña | Sí | Lo cubre una prueba de widgets a 360 dp; en el teléfono se comprueba con `adb shell wm size 720x1600` y `wm density 320` |

> En este modelo la tabla muestra el resultado **esperado** según el código. El equipo la rellena con lo que ve en su
> teléfono: si algo no coincide, eso es lo que se anota.

**Pendiente para el Sprint 2:**
- TEC-02: cambiar el repositorio simulado por el de SQLite (solo cambia `main.dart`).
- HU-01 y HU-03: miniatura y foto reales; la acción «Crear el primero» deja de ser un aviso.
- Escenario de error de HU-05, si la revisión lo pide.
