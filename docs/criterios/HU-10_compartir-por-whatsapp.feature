# language: es
Característica: HU-10 · Compartir un reporte por WhatsApp
  Como vecina, quiero compartir un reporte por WhatsApp
  para avisar a mis vecinos.

  Escenario: Compartir un reporte
    Dado que estoy viendo el detalle de un reporte
    Cuando pido compartirlo
    Entonces se abre el menú de compartir del teléfono
    Y el mensaje lleva la foto, la fecha, la referencia del lugar y un enlace al mapa con la ubicación

  Escenario: WhatsApp no está instalado
    Dado que el teléfono no tiene WhatsApp
    Cuando pido compartir el reporte
    Entonces puedo enviarlo por cualquier otra app del menú de compartir

  Escenario: Compartir sin conexión
    Dado que el teléfono está en modo avión
    Cuando comparto el reporte por WhatsApp
    Entonces el mensaje queda en WhatsApp para enviarse cuando vuelva la señal
    Y el reporte sigue guardado en «Mis reportes»
