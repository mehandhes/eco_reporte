# language: es
Característica: HU-09 · Exportar el listado del mes
  Como presidenta de la JAC, quiero exportar el listado del mes
  para llevarlo a la empresa de aseo.

  Escenario: Exportar el mes
    Dado que tengo reportes de octubre de 2026
    Cuando pido «Exportar listado del mes» y elijo «Octubre de 2026»
    Entonces se abre el menú de compartir con el archivo «ecoreporte_2026-10.csv»
    Y el archivo tiene una fila por reporte de octubre, del más antiguo al más reciente
    Y cada fila lleva fecha, hora, tipo de residuo, lugar, coordenadas, precisión, enlace al mapa y si ya se compartió

  Escenario: Solo los meses con reportes
    Dado que tengo reportes de septiembre y octubre
    Cuando pido exportar
    Entonces solo puedo elegir septiembre u octubre, cada uno con su número de reportes

  Escenario: Sin reportes
    Dado que no tengo reportes
    Entonces no aparece la opción de exportar

  Escenario: Abrirlo en Excel
    Dado que la empresa de aseo abre el archivo en Excel en español
    Entonces las tildes y las eñes se ven bien
    Y cada dato queda en su columna
    Y las coordenadas no se convierten en números equivocados

  Escenario: Una referencia que parece fórmula
    Dado que una referencia empieza con «=»
    Cuando se abre el listado en Excel
    Entonces se ve como texto y no se ejecuta

  Escenario: Sin conexión
    Dado que el teléfono está en modo avión
    Cuando exporto el listado y lo envío por WhatsApp
    Entonces el archivo queda en WhatsApp para enviarse cuando vuelva la señal
