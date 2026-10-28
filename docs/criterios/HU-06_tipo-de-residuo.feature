# language: es
Característica: HU-06 · Tipo de residuo
  Como vecina, quiero elegir la categoría del residuo
  para que la empresa sepa qué recoger.

  Escenario: Elegir el tipo
    Dado que estoy llenando un reporte
    Cuando toco «Escombros»
    Entonces «Escombros» queda marcado
    Y el reporte guardado dice «Escombros» en la lista, en el detalle y en el mensaje de WhatsApp

  Escenario: Cambiar de opinión
    Dado que elegí «Escombros»
    Cuando toco «Muebles y colchones»
    Entonces queda marcado solo «Muebles y colchones»
    Y si lo vuelvo a tocar, el reporte queda sin tipo

  Escenario: No sé qué tipo es
    Dado que no elegí ningún tipo
    Cuando guardo el reporte con su foto
    Entonces se guarda igual
    Y el detalle dice «Sin clasificar»

  Escenario: Reportes de antes de esta versión
    Dado que tengo reportes guardados con la versión 1.0.0
    Cuando actualizo la app
    Entonces mis reportes siguen ahí, sin tipo
