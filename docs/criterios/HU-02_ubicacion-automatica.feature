# language: es
Característica: HU-02 · Ubicación automática del reporte
  Como vecina, quiero que la app tome mi ubicación automáticamente
  para no tener que escribir la dirección del punto.

  Regla: La ubicación se toma sola al abrir el formulario

    Escenario: Ubicación obtenida con buena señal
      Dado que concedí el permiso de ubicación
      Y el GPS del teléfono está encendido
      Cuando abro el formulario «Nuevo reporte»
      Entonces veo la ubicación del punto en menos de 10 segundos
      Y veo su precisión estimada en metros

    Escenario: Se ve que la app está buscando
      Dado que concedí el permiso de ubicación
      Cuando abro el formulario y la ubicación todavía no llega
      Entonces veo el texto «Buscando tu ubicación…»
      Y puedo tomar la foto mientras tanto

  Regla: Sin permiso también se puede reportar

    Escenario: Permiso de ubicación denegado
      Dado que negué el permiso de ubicación
      Cuando abro el formulario «Nuevo reporte»
      Entonces veo para qué necesita la app mi ubicación
      Y puedo escribir una referencia del lugar
      Y puedo guardar el reporte

  Regla: Una ubicación imprecisa se avisa, no se oculta

    Escenario: Precisión peor que 50 metros
      Dado que concedí el permiso de ubicación
      Cuando la ubicación llega con una precisión peor que 50 metros
      Entonces veo el aviso «Ubicación aproximada»
      Y puedo pedirla de nuevo
