# language: es
Característica: HU-05 · Detalle de un reporte
  Como vecina, quiero abrir el detalle de un reporte
  para ver la foto y el lugar.

  Escenario: Abrir el detalle
    Dado que estoy en «Mis reportes»
    Cuando elijo un reporte
    Entonces veo su foto en grande, la fecha y la hora, y el lugar

  Escenario: Volver a la lista
    Dado que abrí un detalle desde la mitad de la lista
    Cuando vuelvo atrás
    Entonces la lista está en la misma posición

  Escenario: Pantalla pequeña
    Dado un teléfono de 360 dp de ancho
    Cuando abro el detalle
    Entonces todo se lee sin cortarse y sin desplazarme de lado
