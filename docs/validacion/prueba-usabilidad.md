# Prueba de usabilidad con la app instalada · INV-02 · Sprint 4

> INV-02 quedó pendiente en el Sprint 1. En el cierre se hace **con la app de verdad** en el teléfono de la persona (o
> en uno del equipo): así sirve a la vez para validar las historias y para medir **RC-01** («crea su primer reporte en
> menos de un minuto y sin ayuda»). Dos vecinos del barrio Primero de Mayo, 15 minutos cada uno. Van el PO (conduce) y
> la líder de UX/UI (cronometra y anota).

## Antes de empezar

- Las mismas reglas del guion del Sprint 1 (`guion-entrevista.md`): explicar para qué es, sin grabar ni fotografiar a la
  persona, sin apellidos ni teléfonos.
- APK 1.0.0 instalado y **la app recién instalada** (sin reportes y sin el aviso aceptado): así se ve el primer uso real.
- Un punto real cerca para fotografiar.

## Las tres tareas

Se lee la tarea y **no se ayuda**. Si la persona pregunta, se responde «¿usted qué haría?». Se anota dónde duda.

| # | Tarea que se lee | Mide | Éxito |
|---|---|---|---|
| 1 | «Usted ve esa basura y quiere que quede reportada. Hágalo con la app.» | RC-01, HU-01, HU-02, HU-12, HU-03 | Reporte guardado **en menos de 60 s**, desde que toca el icono de la app, sin ayuda |
| 2 | «Ahora quiere que su vecina de enfrente se entere. Avísele.» | HU-10 | Llega al menú de compartir sin ayuda |
| 3 | «Ya la recogieron. Quite ese reporte de su teléfono.» | TEC-05 (borrar) | Lo borra sin ayuda |

Después de las tareas, dos preguntas: «¿Qué fue lo más difícil?» y «¿Qué palabra de la app no entendió o cambiaría?»
(sigue abierto el hallazgo H2 sobre «punto crítico» y «reporte»).

## Ficha por persona

Se escribe como comentario del issue INV-02 el mismo día.

```markdown
### Prueba de usabilidad · persona __ (edad aproximada, oficio; sin nombre)
- Teléfono y Android:
- Tarea 1: __ s · ¿sin ayuda? sí/no · dónde dudó:
- Tarea 2: ¿lo logró? · dónde dudó:
- Tarea 3: ¿lo logró? · dónde dudó:
- Lo más difícil, en sus palabras:
- Palabras que no entendió:
- ¿Qué cambia en el backlog? (issue nuevo o escenario nuevo):
```

## Qué se hace con los resultados

| Resultado | Acción |
|---|---|
| Las dos personas cumplen la tarea 1 en menos de 60 s | RC-01 se marca como cumplido en el plan de pruebas |
| Alguien no lo logra | Defecto o historia nueva con lo observado; se muestra en la Review del Demo Day como aprendizaje |
| Se repite una duda | Se cambia el texto de la app (es barato) y se anota en `CHANGELOG.md` |

> Este repositorio modelo **no trae resultados**: la prueba no se ha hecho. Un equipo real no puede marcar RC-01 sin ella.
