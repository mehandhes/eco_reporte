# Sprint 5 · primer incremento después del MVP · Producción

> La versión 1.0.0 cerró el curso con las siete historias Must. El Sprint 5 empieza a bajar las **Should** del backlog,
> en el orden en que más valor dan sin depender de un servidor. Versión resultante: **1.1.0**.

## Sprint Planning

**Objetivo del Sprint:**
> «La empresa de aseo sabe qué recoger y la JAC le lleva un listado del mes que se abre en Excel».

| ID | Elemento | Pts | Rama |
|---|---|---|---|
| HU-06 | Tipo de residuo | 2 | `sprint-5` (commit propio) |
| HU-09 | Exportar el listado del mes | 5 | `sprint-5` (commit propio) |

**Total: 7 puntos.** Menos que en los sprints del cierre (10 a 11) porque la semana incluye probar en el teléfono lo
que quedó pendiente de TEC-04 y hacer INV-02 si no se alcanzó.

**Por qué estas dos y no otras.**

| Candidata | Pts | Decisión |
|---|---|---|
| HU-06 · Tipo de residuo | 2 | **Entra.** Barata y le da valor a HU-09: el listado sin tipo dice dónde, pero no qué |
| HU-09 · Listado del mes | 5 | **Entra.** Cumple la segunda mitad del Objetivo del Producto («que su JAC reciba un listado mensual verificable») |
| HU-07 · Subir con un botón | 3 | Espera: necesita un servidor y la decisión del docente sobre la API (Hito 3) |
| HU-13 · Subida automática | 5 | Espera: depende de HU-07 |
| HU-08 · Mapa del barrio | 5 | Espera: sin servidor solo mostraría los reportes propios |
| TEC-03 · Firebase App Distribution | 2 | Espera: el APK se reparte a mano mientras sean pocos testers |
| HU-11 · Aviso de recogida | 8 | Could; depende de un servidor |

**Decisiones técnicas:**

1. **La categoría es opcional.** Clasificar no puede frenar el reporte de menos de un minuto (RC-01). El detalle dice
   «Sin clasificar» y el listado también.
2. **Seis botones a la vista** (`ChoiceChip`), no una lista desplegable: se ve todo de una vez y se elige con un toque
   (heurística H6). Tocar el elegido lo quita.
3. **En la base se guarda un código** (`escombros`), no el texto («Escombros»): el texto se puede reescribir sin
   migrar. Un código desconocido se lee como «sin categoría» y no rompe la lista.
4. **Esquema 3** con su migración: `ALTER TABLE reportes ADD COLUMN categoria TEXT`. Se prueba desde una base real del
   esquema 2 (la de la versión 1.0.0) y desde una del esquema 1.
5. **El listado es CSV**, no Excel ni PDF: no necesita paquetes nuevos (M2 · cadena de suministro), se abre en Excel y
   en Hojas de cálculo de Google, y pesa pocos KB.
6. **CSV para Excel en español:** separador `;`, UTF-8 con BOM, coordenadas en una sola celda de texto y fecha
   `dd/mm/aaaa`. Sin esto, Excel daña las tildes y convierte `7.06531` en un número equivocado.
7. **CSV injection (OWASP M4):** una celda que empieza con `=`, `+`, `-`, `@` o tabulador lleva un apóstrofo delante.
   La vecina escribe la referencia; la empresa de aseo abre el archivo: el texto de una nunca se ejecuta en el
   computador de la otra.
8. **Sin fotos en el listado.** El archivo viaja por WhatsApp; la foto de un punto ya se comparte con HU-10.
9. **Alcance honesto de HU-09:** exporta los reportes **de este teléfono**. Juntar los de todo el barrio en un solo
   listado necesita un servidor (HU-07). Se dice en la Review.

## Lo que produjo

| Elemento | Resultado | Dónde quedó |
|---|---|---|
| HU-06 | Seis categorías, opcionales; se ven en la lista, el detalle y el mensaje de WhatsApp | `lib/domain/categoria.dart`, `lib/ui/nuevo/campo_categoria.dart` |
| HU-09 | Botón «Exportar listado del mes» en «Mis reportes», selector de mes con el número de reportes, archivo CSV al menú de compartir | `lib/domain/listado_mes.dart`, `lib/data/compartir/servicio_exportar.dart` |
| Base | Esquema 3 con migración y dos pruebas de actualización | `lib/data/repositorio_sqlite.dart` |
| Pruebas | De 73 a 98 | `test/listado_mes_test.dart`, `test/servicio_exportar_test.dart` y las existentes |

## Escenarios y dónde se comprueban

| Historia | Escenario | Prueba automática | En el teléfono |
|---|---|---|---|
| HU-06 | Elegir el tipo | ViewModel + widgets + mensaje | Sí |
| HU-06 | Cambiar de opinión | ViewModel | Sí |
| HU-06 | No sé qué tipo es | ViewModel + widgets | — |
| HU-06 | Reportes de antes de esta versión | Migración 2 → 3 | **Sí:** instalar 1.1.0 encima de 1.0.0 sin desinstalar |
| HU-09 | Exportar el mes | ViewModel + widgets + CSV | Sí: enviarlo a un contacto y abrirlo |
| HU-09 | Solo los meses con reportes | ViewModel + widgets | — |
| HU-09 | Sin reportes | Widgets | — |
| HU-09 | Abrirlo en Excel | CSV (BOM, `;`, coordenadas) | **Sí: abrirlo en Excel en un computador en español** |
| HU-09 | Referencia que parece fórmula | CSV | Opcional |
| HU-09 | Sin conexión | — | Sí, en modo avión |

## Ficha de prueba en dispositivo

| Casilla | HU-06 | HU-09 |
|---|---|---|
| Teléfono y versión de Android | *pendiente* | *pendiente* |
| Actualizar desde 1.0.0 conserva los reportes | *pendiente* | — |
| Los seis botones caben a 360 dp con letra grande | *pendiente* | — |
| El archivo llega por WhatsApp y se abre en Excel | — | *pendiente* |
| Tildes, columnas y coordenadas bien en Excel | — | *pendiente* |
| TalkBack lee los botones y el selector de mes | *pendiente* | *pendiente* |

## Para la Review

1. Mostrar en el teléfono: un reporte con tipo, la lista, y el listado del mes abierto en Excel.
2. **Validar las seis categorías** con la JAC y, si es posible, con la empresa de aseo. Si piden otras, solo cambia
   `lib/domain/categoria.dart` (y nada de la base, porque se guarda el código).
3. Decisión que sigue abierta: ¿servidor (HU-07) para juntar los reportes del barrio? Sin él, cada vecina exporta los
   suyos y la JAC los junta.
