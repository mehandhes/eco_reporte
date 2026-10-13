# language: es
Característica: HU-01 · Tomar la foto del punto crítico
  Como vecina, quiero tomar una foto del punto crítico
  para mostrar el estado real del lugar.

  Escenario: Foto tomada
    Dado que concedí el permiso de cámara
    Cuando tomo la foto y la acepto
    Entonces la veo en miniatura dentro del formulario
    Y puedo repetirla

  Escenario: Permiso de cámara denegado
    Dado que negué el permiso de cámara
    Cuando pido tomar la foto
    Entonces veo para qué se necesita
    Y puedo elegir una foto de la galería

  Escenario: Cancelar no borra lo demás
    Dado que el formulario ya tiene la ubicación
    Cuando abro la cámara y la cierro sin tomar la foto
    Entonces vuelvo al formulario con la ubicación intacta

  # Nació de la inspección heurística (H3 · control y libertad, severidad 3)
  Escenario: Una llamada a mitad del formulario
    Dado que el formulario tiene foto y ubicación
    Cuando entra una llamada y vuelvo a la app al terminarla
    Entonces encuentro el formulario con la foto y la ubicación que ya tenía
