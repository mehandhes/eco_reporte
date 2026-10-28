# Seguridad y privacidad de EcoReporte · TEC-05

> Sprint 4. Revisión contra el **OWASP Mobile Top 10 (2024)** y la **Ley 1581 de 2012** (protección de datos personales,
> reglamentada por el Decreto 1377 de 2013, hoy compilado en el Decreto 1074 de 2015). Cada fila dice qué riesgo hay,
> qué se hizo y cómo se comprueba.

## Qué datos maneja la app

| Dato | ¿Personal? | Dónde vive | Sale del teléfono |
|---|---|---|---|
| Foto del punto | Puede serlo si muestra personas o placas | Carpeta privada de la app (`fotos/`) | Solo si la vecina comparte |
| Ubicación | Sí: dice dónde estuvo la vecina | Base SQLite privada | Solo si la vecina comparte (enlace al mapa) |
| Referencia del lugar | Normalmente no | Base SQLite privada | Solo si la vecina comparte |
| Fecha y hora | Asociada a la ubicación, sí | Base SQLite privada | Solo si la vecina comparte |
| «Ya leí el aviso» | No | Preferencias de la app | Nunca |

No hay cuentas, nombres, teléfonos ni correos. Ningún dato es **sensible** en el sentido del artículo 5 de la Ley 1581
(origen racial, salud, orientación política…).

## OWASP Mobile Top 10 · 2024

| Riesgo | ¿Aplica? | Qué se hizo | Cómo se comprueba |
|---|---|---|---|
| **M1** Uso inadecuado de credenciales | Poco | No hay claves ni tokens en el código. La llave de firma y `key.properties` están en `.gitignore` | `git ls-files \| findstr /i "jks key.properties"` no devuelve nada |
| **M2** Cadena de suministro insegura | Sí | 10 dependencias directas, todas de editores verificados en pub.dev (flutter.dev, dart.dev, dash-overflow.net, tekartik.com, baseflow.com, fluttercommunity.dev). Versiones fijadas en `pubspec.lock` | `flutter pub outdated` en cada Review; revisar el editor verificado en pub.dev antes de añadir un paquete |
| **M3** Autenticación y autorización inseguras | No | No hay cuentas (fuera del alcance, ver `vision-y-alcance.md`) | — |
| **M4** Validación insuficiente de entradas y salidas | Sí | La referencia tiene tope de 120 caracteres. Todo SQL usa `whereArgs`; nunca se pega texto de la vecina en una consulta | Prueba de HU-12; buscar `rawQuery` y `execute(` con interpolación de datos de la vecina: no hay |
| **M5** Comunicación insegura | No | La app no usa la red. El manifiesto de release no tiene `INTERNET`. El enlace al mapa es `https` | Revisar el manifiesto combinado (ver abajo) |
| **M6** Controles de privacidad inadecuados | **Sí** | Aviso antes del primer reporte; ubicación una sola vez y en primer plano (RC-06); sin analítica ni publicidad; borrar un reporte borra su foto; consejo de no fotografiar personas | Pruebas de widgets de TEC-05; no hay `ACCESS_BACKGROUND_LOCATION` en el manifiesto |
| **M7** Protección insuficiente del binario | Sí | Release con R8 (por defecto) y Dart ofuscado: `--obfuscate --split-debug-info` | `docs/distribucion.md` |
| **M8** Configuración de seguridad incorrecta | Sí | `allowBackup="false"`; solo `MainActivity` exportada (la necesita el lanzador); release no depurable (por defecto) | Manifiesto combinado |
| **M9** Almacenamiento inseguro de datos | Sí | Base y fotos en el almacenamiento **interno** de la app, que otras apps no pueden leer; nada en la memoria externa compartida; sin copia en la nube | Explorador de archivos del teléfono: las fotos no aparecen en la galería |
| **M10** Criptografía insuficiente | Poco | No se cifra la base: los datos no son sensibles y viven en el espacio privado de la app. **Decisión revisable**: si se agregan cuentas o un servidor (HU-07), los tokens van a `flutter_secure_storage` y la conexión por HTTPS | — |

### Revisar el manifiesto combinado

El manifiesto final mezcla el de la app con el de cada paquete. Para ver los permisos que de verdad pide el APK:

```powershell
flutter build apk --release
# Con las build-tools de Android en el PATH:
aapt2 dump permissions build\app\outputs\flutter-apk\app-release.apk
```

Deben aparecer `CAMERA`, `ACCESS_COARSE_LOCATION` y `ACCESS_FINE_LOCATION`, y **ningún** `INTERNET` ni
`ACCESS_BACKGROUND_LOCATION`. Si un paquete añade un permiso inesperado, se anota aquí con su motivo.

## Ley 1581 de 2012 · cómo la cumple la app

| Exigencia | Dónde |
|---|---|
| **Autorización previa e informada** del titular | El primer «Reportar» muestra el aviso; «Entendido, crear mi reporte» queda guardado. El sistema operativo pide además cada permiso |
| **Finalidad** limitada y explícita | Aviso: «Sirven para una sola cosa: armar el reporte del punto de basura» |
| **Aviso de privacidad** con el contenido mínimo (Decreto 1377, art. 15): responsable y contacto, tratamiento y finalidad, derechos, cómo conocer la política | Pantalla «Privacidad» (`lib/ui/privacidad/`), abierta siempre desde «Mis reportes» |
| **Política de tratamiento** (Decreto 1377, art. 13) | `docs/privacidad.md` |
| Derecho a **suprimir** | Borrar un reporte desde su detalle borra la fila y la foto |
| **Circulación restringida** | Nada se envía a un servidor; compartir es siempre una acción de la vecina |

> **Antes de repartir el APK**, cada equipo cambia `PantallaPrivacidad.responsable` por su nombre y un contacto real, y
> revisa `docs/privacidad.md` con el docente. Este repositorio modelo deja un responsable genérico.
