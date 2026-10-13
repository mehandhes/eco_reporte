# Visión y alcance de EcoReporte

> Sprint 0 · semana 3 · Paso 1 y Paso 2 de la guía-taller del Sprint 0.
> Actualizado en el Sprint 1 (semana 4): MoSCoW tras el corte del MVP.

## Problema y ODS

En los barrios de Barrancabermeja se forman **puntos críticos de residuos**: lotes y esquinas donde la basura se acumula
durante días. Los vecinos los ven, pero no saben a quién avisar ni cómo dar la ubicación exacta, y cuando avisan no queda
constancia de que lo hicieron.

- **ODS 11 · Ciudades y comunidades sostenibles**, meta 11.6: reducir el impacto ambiental negativo de las ciudades,
  prestando especial atención a la gestión de los desechos municipales.
- **Usuario principal:** vecinas y vecinos de los barrios (persona: Yolanda Pérez, ver `requisitos.md`).
- **Usuario secundario:** la presidenta de la Junta de Acción Comunal (JAC), que lleva los reportes a la empresa de aseo.

## Declaración de visión (plantilla de Moore)

**Para** los vecinos de los barrios de Barrancabermeja **que** ven puntos de basura acumulada y no saben a quién avisar,
**EcoReporte es una** app móvil de reporte ciudadano **que** permite reportar un punto crítico con foto y ubicación en
menos de un minuto.
**A diferencia de** llamar a la línea de atención o escribir en grupos de Facebook, **nuestro producto** deja un registro
georreferenciado que funciona sin conexión y que la Junta de Acción Comunal puede llevar a la empresa de aseo.

## Objetivo del Producto

> «Que cualquier vecino reporte un punto crítico de residuos en menos de un minuto, incluso sin conexión, y que su JAC
> reciba un listado mensual verificable».

Va también en la descripción del proyecto de GitHub Projects.

## Alcance con MoSCoW

### Como quedó en el Sprint 0

| Must | Should | Could | Won't (este semestre) |
|---|---|---|---|
| Tomar foto del punto | Sincronizar con la nube | Compartir por WhatsApp | Versión iOS publicada |
| Ubicación automática por GPS | Mapa de reportes del barrio | Modo oscuro | Chat entre vecinos |
| Guardar sin conexión | Categoría del residuo | Notificar cuando se recoja | Panel web para la empresa de aseo |
| Lista de mis reportes | Exportar listado para la JAC | | Gamificación con puntos |
| Detalle de un reporte | | | |

**Regla del 60 %:** las Must del Sprint 0 suman 21 de 53 puntos (40 %).

**Revisión contra el Hito 3** (API + persistencia + función del dispositivo): cámara y GPS (Must), SQLite (Must, HU-03)
y API de sincronización (Should, HU-07). Cubierto.

### Cambios del Sprint 1

| Cambio | Por qué |
|---|---|
| **HU-12 · Referencia del lugar** entra como Should y sube a **Must** | El mapa de experiencia mostró que el lote no tiene nomenclatura; y el escenario «permiso de ubicación denegado» de HU-02 no se puede cumplir sin ella |
| **HU-10 · Compartir por WhatsApp** sube de Could a **Must** | Sin ella la actividad «Hacer que llegue a alguien» quedaba vacía sobre la línea del MVP. Es la forma más barata (2 pts) de cerrar el recorrido |
| **HU-07** se parte en HU-07 (subir con un botón) y **HU-13** (subida automática) | Valía 8 puntos y mezclaba dos caminos (corte P de SPIDR) |
| **HU-03** se reescribe: «guardar en mi teléfono» (5 → 3 pts) | Mezclaba guardar en el teléfono con enviar a la nube, que es HU-07 |


## Fuera del alcance este semestre

- Publicar la versión de iOS (se distribuye solo el APK de Android por Firebase App Distribution).
- Chat entre vecinos y cualquier función de red social.
- Panel web para la empresa de aseo: la JAC recibe un listado exportado (HU-09), no un sistema.
- Gamificación, puntos o premios.
- Cuentas de usuario con contraseña: el reporte es anónimo dentro del teléfono.
- Garantizar que la empresa de aseo recoja el punto: la app deja constancia, no presta el servicio.
