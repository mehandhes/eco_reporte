# Requisitos de EcoReporte · v0.1

> Sprint 1 · semana 4 · elemento INV-03. Base del documento de requisitos y alcance del **Hito 1** (semana 5).
> Este documento reúne y enlaza: las historias viven en los issues y en `docs/criterios/`, no se copian aquí.

| Versión | Sprint | Qué cambió |
|---|---|---|
| 0.1 | Sprint 1 | Primera versión: persona, mapa, MVP, calidad y hallazgos heurísticos. Validación con usuarios pendiente |
| 0.2 | Sprint 4 | Cierre en tres sprints (`plan-de-cierre.md`). H1 resuelto con la marca «Compartido» (Sprint 3). Cada RC enlazado con su prueba en `calidad/plan-de-pruebas.md`. La validación pasa a ser una prueba de usabilidad con la app instalada (`validacion/prueba-usabilidad.md`) |

## 1. Problema y ODS

Los vecinos de Barrancabermeja ven puntos de basura acumulada y no saben a quién avisar ni cómo dar la ubicación exacta;
cuando avisan, no queda constancia. **ODS 11**, meta 11.6 (gestión de los desechos municipales). Detalle en
`vision-y-alcance.md`.

## 2. Visión y Objetivo del Producto

**Objetivo del Producto:** «Que cualquier vecino reporte un punto crítico de residuos en menos de un minuto, incluso sin
conexión, y que su JAC reciba un listado mensual verificable». La declaración de visión completa está en
`vision-y-alcance.md`.

## 3. Usuarios

### 3.1 Proto-persona · Yolanda Pérez

**46 años · tendera · barrio Primero de Mayo, Barrancabermeja.** Usuaria principal: la que aparece en todas las historias
Must. La presidenta de la JAC tendrá su persona cuando lleguen HU-09 y HU-11.

| Campo | Contenido |
|---|---|
| **Contexto** | Atiende su tienda de siete de la mañana a ocho de la noche. Ve el lote de la esquina, donde se acumula la basura, cada vez que abre. Los clientes le comentan el problema a ella. |
| **Teléfono y conexión** | Android de gama de entrada, con poco espacio libre *(por validar)*. Datos prepago que no le alcanzan para todo el mes *(por validar)*. Usa WhatsApp y Facebook a diario. |
| **Quiere lograr** | Que recojan el punto sin tener que dejar la tienda sola ni pasar media hora en una llamada. |
| **La frena hoy** | No sabe a quién avisar ni cómo dar la dirección exacta del lote. Cuando avisó, nunca supo si sirvió *(por validar)*. |
| **Una frase suya** | «Yo llamo, me piden la nomenclatura, y ese lote no tiene. Al final uno se cansa.» *(frase supuesta)* |

**Cada dato cambia una decisión:** el poco espacio obliga a comprimir las fotos (RC-04) y a avisar si no cabe la foto
(HU-03); los datos prepago vuelven el modo sin conexión un caso diario (HU-03); el lote sin nomenclatura hace nacer HU-12;
WhatsApp a diario hace de HU-10 el canal más barato para cerrar el recorrido.

### 3.2 Mapa de experiencia · la situación de hoy, sin la app

**Escenario:** Yolanda ve basura acumulada en el lote de la esquina y quiere que la recojan esta semana.

| | 1 · Ve el punto | 2 · Decide avisar | 3 · Avisa | 4 · Espera | 5 · No sabe qué pasó |
|---|---|---|---|---|---|
| **Hace** | Abre la tienda y ve bolsas nuevas en el lote | Busca en Facebook a quién llamar | Llama a la línea de aseo; publica una foto en el grupo del barrio | Mira el lote cada mañana | Deja de avisar la siguiente vez |
| **Piensa** | «Otra vez. Esto trae ratas.» | «Alguien tiene que decirlo.» | «Me piden una dirección que no existe.» | «¿Lo habrán anotado?» | «Para qué, si no sirve.» |
| **Siente** | Molesta | Decidida | Frustrada ↓ | Ansiosa | Resignada ↓↓ |
| **Dolor** | — | No sabe cuál es el canal | No puede dar la ubicación; la llamada es larga | No queda constancia de que avisó | Nadie le responde |
| **Oportunidad** | Reportar en el momento, desde donde está | Un único canal, claro | Foto y ubicación automáticas, en menos de un minuto | Ver su reporte guardado | Que el reporte llegue a alguien que pueda actuar |
| **Historia** | HU-01 | Objetivo del Producto | HU-01 · HU-02 · HU-03 · **HU-12** | HU-04 · HU-05 | HU-09 · HU-10 · HU-11 |

**Lo que el mapa enseñó:**
1. La fase 5, la que hace que Yolanda deje de avisar, no tenía ninguna historia Must. Se resolvió en el corte del MVP
   subiendo HU-10.
2. En la fase 3 apareció un dato nuevo: el lote no tiene nomenclatura, así que el GPS solo puede no bastar. Nació
   **HU-12 · Referencia del lugar**.

## 4. Alcance

### 4.1 Mapa de historias y línea del MVP

| | Capturar el punto | Guardar el reporte | Consultar mis reportes | Hacer que llegue a alguien |
|---|---|---|---|---|
| *Fases del mapa* | *1 y 3* | *3* | *4* | *5* |
| **MVP · Hito 2** | HU-01 · Tomar la foto (3) | HU-03 · Guardar en el teléfono (3) | HU-04 · Lista de mis reportes (3) | HU-10 · Compartir por WhatsApp (2) ↑ |
| | HU-02 · Ubicación automática (3) | | HU-05 · Detalle de un reporte (2) | |
| | HU-12 · Referencia del lugar (2) ↑ | | | |
| **Después del MVP · Hito 3** | HU-06 · Categoría del residuo (2) | HU-07 · Subir con un botón (3) | HU-08 · Mapa del barrio (5) | HU-09 · Exportar listado para la JAC (5) |
| | | HU-13 · Subida automática (5) | | |
| **Si sobra tiempo** | | | | HU-11 · Aviso de recogida (8) |

Sostienen todo el mapa, sin colgarse de una actividad: **TEC-01** (2) y **TEC-02** (3) en el MVP; **TEC-03** (2) después.

| Comprobación | Resultado |
|---|---|
| Cada actividad tiene al menos una historia sobre la línea | 4 de 4 |
| Nada sobre la línea se puede quitar sin romper el Objetivo del Producto | Sí |
| Elementos en el MVP, con las dos técnicas | 9 |
| Puntos sobre la línea | 23 de 53 = **43 %** (tope: 60 %) |
| Revisión contra el Hito 3 | Cámara y GPS en el MVP; SQLite en HU-03; API en HU-07 |

### 4.2 MoSCoW actualizado y fuera del alcance

En `vision-y-alcance.md`, con la tabla de cambios del Sprint 1.

## 5. Historias de usuario y criterios de aceptación

Vista **«Por épica»** del tablero. Criterios completos en `docs/criterios/*.feature` (Gherkin en español).

| ID | Historia | Prioridad | Pts | Escenarios | Feliz · error · móvil |
|---|---|---|---|---|---|
| HU-01 | Tomar la foto del punto crítico | Must | 3 | 4 | Foto tomada · cámara denegada · llamada a mitad |
| HU-02 | Ubicación automática | Must | 3 | 4 | Buena señal · permiso denegado · precisión > 50 m |
| HU-12 | Referencia del lugar | Must | 2 | 3 | Escribirla · obligatoria sin ubicación · demasiado larga |
| HU-03 | Guardar en el teléfono | Must | 3 | 6 | Guardar · falta la foto · sin conexión, doble toque, sin espacio |
| HU-04 | Lista de mis reportes | Must | 3 | 4 | Con datos · no se pueden leer · lista vacía, 200 reportes |
| HU-05 | Detalle de un reporte | Must | 2 | 3 | Abrir · — · volver a la misma posición, 360 dp |
| HU-10 | Compartir por WhatsApp | Must | 2 | 3 | Compartir · sin WhatsApp · sin conexión |

HU-05 no tiene escenario de error propio: el detalle lee el mismo repositorio que la lista y su error lo cubre HU-04.
Queda anotado como pregunta para la revisión del Sprint 2.

## 6. Requisitos de calidad y restricciones

Según ISO/IEC 25010:2023. La DoD base del curso ya cubre 360 dp, 48 dp, cuatro estados y permisos denegados.

| ID | Característica | Requisito medible | Dónde vive |
|---|---|---|---|
| RC-01 | Capacidad de interacción | Una persona que nunca ha usado la app crea su primer reporte en menos de un minuto y sin ayuda. | Objetivo del Producto; se mide en la prueba con usuarios de la semana 5 |
| RC-02 | Capacidad de interacción · accesibilidad | Toda área táctil mide al menos 48 dp y el texto tiene un contraste de 4,5:1 o más. | Definición de Terminado |
| RC-03 | Eficiencia de desempeño | «Mis reportes» se muestra en menos de 1 segundo con 200 reportes guardados, en un Android de gama de entrada. | Criterio de HU-04 |
| RC-04 | Eficiencia de desempeño · uso de recursos | Cada foto guardada ocupa menos de 1 MB *(por validar)*. | Criterio de HU-01 |
| RC-05 | Fiabilidad | Ningún reporte guardado se pierde si la app se cierra, el teléfono se apaga o se queda sin batería. | Criterio de HU-03 |
| RC-06 | Seguridad · privacidad | La ubicación solo se lee mientras se crea un reporte, nunca en segundo plano. Antes de pedir un dato personal se informa para qué se usará (Ley 1581 de 2012). | Restricción; se desarrolla en la Unidad 4 |
| RC-07 | Compatibilidad | Funciona en la versión de Android más antigua que tengan los vecinos entrevistados y en pantallas desde 360 dp de ancho *(por validar)*. | Restricción y Definición de Terminado |

**Restricciones del curso:** Flutter 3.47 / Dart 3.13 con `material_ui`, MVVM con Provider y `go_router`; Android con
`targetSdk 36`; distribución interna por APK o Firebase App Distribution.

## 7. Hallazgos heurísticos

Inspección de las historias Must con las diez heurísticas de Nielsen, antes de que existan pantallas. Severidad de 0 a 4.

| Heurística | Historia | Hallazgo | Sev. | Destino |
|---|---|---|---|---|
| H5 · Prevención de errores | HU-03 | Si no queda espacio en el teléfono, la foto no se guarda y ningún criterio decía qué pasa. | 4 | Escenario nuevo «Sin espacio en el teléfono» |
| H3 · Control y libertad | HU-01 | Si entra una llamada a mitad del formulario, no estaba escrito que se conserve lo ya llenado. | 3 | Escenario nuevo «Una llamada a mitad del formulario» |
| H10 · Ayuda | HU-03 | Nada le explicaba a la vecina qué pasa con su reporte después de guardarlo. | 3 | Escenario nuevo «La confirmación dice qué sigue» |
| H1 · Visibilidad del estado | HU-10 | Tras compartir, el reporte no muestra que ya se compartió. | 2 | Resuelto en el Sprint 3: marca «Compartido» en la lista y el detalle |
| H2 · Relación con el mundo real | Todas | «Punto crítico» y «reporte» pueden no ser las palabras del barrio. | 2 | Pregunta para la entrevista (INV-02) |

## 8. Validación con usuarios

**Estado: pendiente.** INV-02 · dos vecinos del barrio Primero de Mayo, entrevista de 15 minutos cada uno, con el PO y la
líder de UX/UI, antes de la Sesión B de la semana 5. Guion y ficha en `docs/validacion/`. Las fichas se escriben como
comentario del issue INV-02 el mismo día de la visita, y después se actualizan la persona (se quitan los «por validar»)
y el backlog.

> Este repositorio es un modelo para el curso: **no incluye resultados de entrevistas** porque no se hicieron. Un equipo
> real no puede cerrar el Sprint 1 sin ellas.

## 9. Preguntas abiertas

| Pregunta | A quién |
|---|---|
| ¿Cuántos metros de error aguanta quien va a recoger? ¿Sirven 50? | Presidenta de la JAC |
| ¿Yolanda tiene el GPS encendido normalmente, o lo apaga para ahorrar batería? | Entrevista (INV-02) |
| ¿Cómo le dicen en el barrio a un sitio así, y a avisar de él? | Entrevista (INV-02) |
| ¿Tiene datos todo el mes? ¿Cuánto espacio libre le queda para fotos? | Entrevista (INV-02) |
| ¿Cuál es la versión de Android más antigua entre los entrevistados? | Entrevista (INV-02) |
| ¿Qué formato de listado acepta la empresa de aseo? | Presidenta de la JAC (antes de HU-09) |
