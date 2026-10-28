# Demo Day · INV-05 · Hito 5

> Última Sesión B. Pitch de **5 minutos**, demo en vivo y defensa ante el docente y los demás equipos. Este archivo es el
> guion del equipo; los datos de impacto son **hipótesis** hasta que la prueba de usabilidad (INV-02) diga otra cosa.

## 1. El pitch en cinco minutos

| Min. | Bloque | Qué se dice (EcoReporte) | Quién |
|---|---|---|---|
| 0:00 | **Problema** | Yolanda ve el mismo lote lleno de basura cada mañana. Llama, le piden una dirección que el lote no tiene, y nunca sabe si sirvió. Así deja de avisar. | PO |
| 0:45 | **Por qué importa** | ODS 11, meta 11.6: gestión de los residuos municipales. Un punto que nadie reporta no existe para la empresa de aseo. | PO |
| 1:15 | **Solución** | Una app que reporta un punto con foto y ubicación en menos de un minuto, sin datos, y lo hace llegar por WhatsApp. | Líder UX/UI |
| 1:45 | **Demo en vivo** | Ver el guion de la sección 2 | Scrum Master |
| 3:45 | **Cómo se construyó** | Cuatro sprints, siete historias Must, pruebas automáticas, seguridad revisada contra OWASP y la Ley 1581 | Un developer |
| 4:15 | **Qué sigue** | Validar con más vecinos; listado mensual para la JAC (HU-09) y subida a un servidor (HU-07) | PO |
| 4:45 | **Cierre** | Una frase: «Que avisar de un punto de basura cueste menos que ignorarlo». | PO |

## 2. Guion de la demo (2 minutos)

Teléfono proyectado (por ejemplo, con `scrcpy`) y **en modo avión** desde el principio: es el argumento más fuerte.

1. Abrir la app recién instalada → aviso de privacidad → «Entendido».
2. La ubicación aparece sola. Tomar la foto. Escribir «frente a la cancha».
3. Guardar → la confirmación dice qué sigue → el reporte aparece de primero.
4. Abrir el detalle → «Compartir por WhatsApp» → elegir el chat del equipo → el mensaje queda en cola (modo avión).
5. Volver: la lista muestra «Compartido».
6. Quitar el modo avión: el mensaje sale y llega al teléfono de otro integrante (que lo muestra en alto).

**Plan B** si algo falla en vivo: video de 90 segundos grabado el día anterior con el mismo guion. Se dice en voz alta
«les mostramos la grabación» y se sigue: no se depura en el escenario.

## 3. Modelo de impacto (hipótesis)

| Bloque | Hipótesis | Cómo se valida |
|---|---|---|
| Usuarios | Vecinos con Android de gama de entrada y datos prepago; la JAC como canal | Prueba de usabilidad (INV-02) |
| Propuesta de valor | Reportar en menos de un minuto, sin datos, con constancia | RC-01 medido |
| Canal | La JAC reparte el APK por WhatsApp con un QR | Preguntar a la presidenta de la JAC |
| Sostenibilidad | Sin servidor no hay costo de operación. Si llega HU-07, un plan gratuito de un backend como servicio alcanza para un barrio | Investigación de 2 h prevista en HU-07 |
| Aliados | JAC, empresa de aseo, UNIPAZ (proyección social) | Reunión con la JAC antes de HU-09 |
| Métrica de impacto | Puntos reportados por mes y, con HU-11, puntos recogidos | Solo con servidor; hoy no se puede medir |

## 4. Preguntas probables en la defensa

| Pregunta | Respuesta corta | Evidencia |
|---|---|---|
| ¿Por qué no hay servidor? | Recortamos el alcance a tres semanas; el MVP funciona entero sin red y eso es justo lo que necesita una vecina sin datos | `docs/plan-de-cierre.md` |
| ¿Qué pasa si la vecina niega la ubicación? | Reporta igual: la referencia se vuelve obligatoria | Escenario HU-02 «Permiso denegado» y su prueba |
| ¿Cómo saben que funciona con 200 reportes? | Prueba automática de lectura y medición en un teléfono de gama de entrada | `docs/calidad/plan-de-pruebas.md`, RC-03 |
| ¿Qué datos personales guardan? | Foto, ubicación, referencia y fecha, solo en el teléfono | `docs/seguridad.md` |
| ¿Qué harían distinto? | Llevarlo a la Retrospectiva final: una cosa que conservar y una que cambiar | `docs/sprints/sprint-4.md` |
| ¿Por qué Flutter? | Decisión del Hito 0 con la matriz ponderada | ADR del Hito 0 |

## 5. Lista del día

- [ ] APK 1.0.0 firmado instalado en dos teléfonos cargados.
- [ ] Modo avión probado con el guion completo esa mañana.
- [ ] Video del plan B en los dos teléfonos y en el computador.
- [ ] Cable y adaptador para proyectar.
- [ ] Repositorio con la etiqueta `v1.0.0` y el README actualizado.
- [ ] Coevaluación individual entregada.
