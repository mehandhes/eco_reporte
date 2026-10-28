/// HU-06 · Qué tipo de residuo hay en el punto crítico.
///
/// Le dice a la empresa de aseo qué vehículo mandar: no se recogen igual
/// unas bolsas que un colchón o una montaña de escombros. La lista es
/// corta a propósito (seis botones caben en la pantalla sin desplazarse) y
/// se valida con la JAC en la Review del Sprint 5.
///
/// El [codigo] es lo que se guarda en SQLite y nunca cambia; el [nombre]
/// es lo que lee la vecina y se puede reescribir sin migrar la base.
enum Categoria {
  domestica('domestica', 'Bolsas de basura'),
  escombros('escombros', 'Escombros'),
  voluminosos('voluminosos', 'Muebles y colchones'),
  poda('poda', 'Poda y jardín'),
  llantas('llantas', 'Llantas'),
  otro('otro', 'Otro');

  const Categoria(this.codigo, this.nombre);

  /// Código estable para la base de datos.
  final String codigo;

  /// Texto para la vecina, en la app, en WhatsApp y en el listado.
  final String nombre;

  /// La categoría con ese [codigo], o nula si no hay ninguna (reportes de
  /// antes del Sprint 5) o si el código no se conoce.
  static Categoria? desdeCodigo(Object? codigo) {
    for (final Categoria categoria in values) {
      if (categoria.codigo == codigo) return categoria;
    }
    return null;
  }
}
