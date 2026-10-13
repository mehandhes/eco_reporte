# language: es
Característica: HU-12 · Referencia del lugar
  Como vecina, quiero añadir una referencia del lugar («frente a la cancha»)
  para que quien recoja lo encuentre aunque el GPS falle por unos metros.

  Escenario: Escribir una referencia
    Dado que estoy llenando un reporte
    Cuando escribo «frente a la cancha, junto al poste» como referencia
    Entonces la referencia aparece en el reporte guardado y en su detalle

  Escenario: Sin ubicación, la referencia es obligatoria
    Dado que negué el permiso de ubicación
    Cuando intento guardar el reporte sin referencia
    Entonces no se guarda nada
    Y veo que necesito escribir una referencia del lugar

  Escenario: Referencia demasiado larga
    Dado que estoy llenando un reporte
    Cuando escribo una referencia de más de 120 caracteres
    Entonces veo cuántos caracteres me sobran
    Y no puedo escribir más allá del límite
