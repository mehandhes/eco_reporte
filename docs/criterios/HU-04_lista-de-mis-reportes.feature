# language: es
Característica: HU-04 · Lista de mis reportes
  Como vecina, quiero ver la lista de mis reportes
  para saber cuáles ya hice.

  Escenario: Lista vacía
    Dado que todavía no he hecho ningún reporte
    Cuando abro «Mis reportes»
    Entonces veo un mensaje que me invita a crear el primero
    Y la forma de hacerlo

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

  # Requisito de calidad RC-03 (eficiencia de desempeño), vive aquí como criterio
  Escenario: Doscientos reportes
    Dado que tengo 200 reportes guardados en un Android de gama de entrada
    Cuando abro «Mis reportes»
    Entonces la lista se muestra en menos de 1 segundo
