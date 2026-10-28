import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';

import 'fuente_fotos.dart';

/// [FuenteFotos] real, con el paquete `image_picker`.
///
/// RC-04 (cada foto pesa menos de 1 MB): se pide la imagen ya reducida a
/// 1600 px por el lado mayor y con calidad JPEG 70. Una foto de 12 MP pasa
/// de unos 4 MB a unos 300–500 KB, y la evidencia se sigue viendo.
class FuenteFotosImagePicker implements FuenteFotos {
  FuenteFotosImagePicker([ImagePicker? selector])
      : _selector = selector ?? ImagePicker();

  final ImagePicker _selector;

  static const double _ladoMaximo = 1600;
  static const int _calidad = 70;

  @override
  Future<ResultadoFoto> tomar() => _pedir(ImageSource.camera);

  @override
  Future<ResultadoFoto> elegirDeGaleria() => _pedir(ImageSource.gallery);

  Future<ResultadoFoto> _pedir(ImageSource origen) async {
    try {
      final XFile? foto = await _selector.pickImage(
        source: origen,
        maxWidth: _ladoMaximo,
        maxHeight: _ladoMaximo,
        imageQuality: _calidad,
      );
      return foto == null ? const FotoCancelada() : FotoTomada(foto.path);
    } on PlatformException catch (e) {
      // Como el manifiesto declara CAMERA, image_picker pide el permiso él
      // mismo y, si se niega, responde con este código.
      if (e.code == 'camera_access_denied') return const CamaraDenegada();
      return FotoFallida(e.message ?? e.code);
    }
  }

  @override
  Future<String?> recuperarPerdida() async {
    try {
      final LostDataResponse respuesta = await _selector.retrieveLostData();
      if (respuesta.isEmpty) return null;
      return respuesta.file?.path;
    } catch (_) {
      // Recuperar es un extra: si falla, el formulario sigue sin foto.
      return null;
    }
  }
}
