# Definición del Flujo de Trabajo y Definición de Terminado

> Sprint 0 · Paso 6. Marco del curso: Scrumban con fases de Mobile-D, sprints de una semana de Sesión B a Sesión B.

## Columnas del tablero y políticas de entrada

Cada política responde a una pregunta: **¿qué tiene que cumplir una tarjeta para entrar en esta columna?**
Equipo de cuatro integrantes.

| Columna | Política de entrada | WIP |
|---|---|---|
| **Backlog** | Cualquier idea con título claro. El PO decide su orden. | — |
| **Listo** | Cumple INVEST, tiene criterios de aceptación y puntos, y el equipo la entiende. | 5 |
| **En desarrollo** | Alguien se la asigna y crea su rama (`hu-04-lista-reportes`). Solo una tarjeta por persona. | 4 |
| **En revisión** | Hay un PR abierto que enlaza el issue y `flutter analyze` está limpio. | 2 |
| **En dispositivo** | PR aprobado por otra persona; APK de la rama instalado en un Android físico. | 2 |
| **Hecho** | Cumple la Definición de Terminado y el PR está fusionado. | — |

**Política añadida en el Sprint 1 · elementos de investigación (INV):** esperan en «Backlog» con el campo Sprint puesto
(la vista «Sprint actual» los muestra igual) y pasan a «En desarrollo» cuando alguien los toma. **No pasan por «En
dispositivo»**: de «En revisión», donde otra persona lee el resultado, van a «Hecho».

**Las historias Must se quedan en «Listo»** durante la fase de Exploración. Llegan a «Hecho» cuando estén construidas y
probadas en un teléfono, desde la semana 6.

## El resto de la definición

- **Elemento de trabajo:** un issue del repositorio (historia, tarea técnica, defecto o investigación).
- **Empieza** cuando entra en «En desarrollo»; **termina** cuando entra en «Hecho». Entre esos dos momentos se mide el
  *cycle time*.
- **Expectativa de nivel de servicio (provisional):** «la mayoría de nuestros elementos se terminan en 4 días o menos».
  Se revisará con datos reales en el Sprint 4.
- **Bloqueos:** una tarjeta bloqueada lleva la etiqueta `bloqueada` y se menciona en el siguiente Daily. Si sigue así dos
  días, el Scrum Master interviene.
- **Métricas que se anotan en cada Review:** *throughput* (elementos que llegaron a «Hecho» en el sprint) y el elemento en
  curso de mayor edad.
- **Ramas:** `main` protegida; una rama por elemento (`hu-04-…`, `tec-02-…`, `inv-04-…`); todo entra por pull request con
  una revisión de otra persona. El PR dice `Closes #N` para que el issue se cierre al fusionar.

## Ceremonias

| Evento | Cuándo | Duración |
|---|---|---|
| Sprint Review | Inicio de cada Sesión B | 15 min |
| Retrospectiva | Después de la Review | 10 min |
| Sprint Planning | Después de la Retrospectiva | 20 min |
| Daily | Inicio de cada sesión; asíncrono lunes, miércoles y viernes | 10 min |

## Definición de Terminado de la fase de Exploración (semanas 3 a 5)

Certifica que una historia está **lista para construirse**. Se lleva como tres casillas dentro de cada issue:

- [ ] La historia tiene criterios de aceptación verificables en formato Dado / Cuando / Entonces, revisados por otra pareja.
- [ ] Su pantalla existe en el prototipo de Figma, en baja fidelidad como mínimo.
- [ ] El PO la validó con al menos un usuario real y anotó qué dijo.

## Definición de Terminado base del curso (desde la semana 6)

Una historia está **Hecha** cuando:

- [ ] Cumple todos sus criterios de aceptación, comprobados en un **Android físico**.
- [ ] Entró por un PR revisado por otra persona y fusionado en `main`.
- [ ] `flutter analyze` no reporta problemas y las pruebas pasan.
- [ ] Se ve bien en una pantalla de **360 dp** de ancho, sin desbordamientos.
- [ ] Toda lista modela sus **cuatro estados**: cargando, vacío, error y con datos.
- [ ] Si usa un permiso, maneja el caso de **permiso denegado**.
- [ ] Toda área táctil mide al menos **48 dp**.
- [ ] El texto tiene un contraste de 4,5:1 o más. *(Añadido en el Sprint 1, requisito de calidad RC-02.)*
