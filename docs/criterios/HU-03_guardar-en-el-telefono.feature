# language: es
Característica: HU-03 · Guardar el reporte en el teléfono
  Como vecina, quiero guardar el reporte en mi teléfono aunque no tenga datos,
  para no perderlo.

  Escenario: Guardar sin conexión
    Dado que el teléfono está en modo avión
    Y el formulario tiene foto
    Cuando guardo el reporte
    Entonces veo la confirmación «Reporte guardado»
    Y el reporte aparece de primero en «Mis reportes»

  Escenario: Sobrevive al cierre
    Dado que guardé un reporte
    Cuando cierro la app por completo y la vuelvo a abrir
    Entonces el reporte sigue en «Mis reportes» con su foto

  Escenario: Falta la foto
    Dado que el formulario no tiene foto
    Cuando intento guardar
    Entonces no se guarda nada
    Y veo qué falta

  Escenario: Doble toque
    Dado que el formulario está completo
    Cuando pido guardar dos veces seguidas
    Entonces se crea un solo reporte

  # Nació de la inspección heurística (H5 · prevención, severidad 4)
  Escenario: Sin espacio en el teléfono
    Dado que al teléfono le queda menos espacio libre del que ocupa la foto
    Cuando intento guardar el reporte
    Entonces veo que no hay espacio suficiente
    Y el formulario conserva la foto y la ubicación

  # Nació de la inspección heurística (H10 · ayuda, severidad 3)
  Escenario: La confirmación dice qué sigue
    Dado que el formulario está completo
    Cuando guardo el reporte
    Entonces la confirmación me dice que puedo compartirlo con mi JAC desde «Mis reportes»
