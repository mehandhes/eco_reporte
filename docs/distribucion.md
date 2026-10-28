# Build de release y distribución · TEC-06

> Sprint 4. Cómo pasar del código a un **APK firmado** que cualquier vecina pueda instalar. Basado en la guía oficial
> *Build and release an Android app* (docs.flutter.dev/deployment/android). Distribución interna: no se publica en
> Google Play.

## 1. Crear la llave de firma (una sola vez por equipo)

La llave identifica al equipo como autor del APK. **Si se pierde, las actualizaciones ya no se pueden instalar encima de
la versión anterior**: hay que desinstalar y se pierden los reportes. La guarda el Product Owner, fuera del repositorio,
con copia en un lugar seguro.

```powershell
keytool -genkey -v -keystore $env:USERPROFILE\eco-reporte-release.jks `
        -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
        -alias upload
```

Si `keytool` no se encuentra: `flutter doctor -v` muestra la ruta de Java («Java binary at:»); `keytool.exe` está en la
misma carpeta.

## 2. Decirle a Gradle dónde está

Crear `android/key.properties` (ya está en `.gitignore`):

```properties
storePassword=la-contraseña-del-paso-1
keyPassword=la-contraseña-del-paso-1
keyAlias=upload
storeFile=C:\\Users\\tu-usuario\\eco-reporte-release.jks
```

En Windows la ruta lleva **barras dobles**. `android/app/build.gradle.kts` ya lee este archivo; si no existe, el release
se firma con la llave de depuración (sirve para probar, no para repartir).

## 3. Compilar

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --obfuscate --split-debug-info=build\simbolos
```

- `--obfuscate` cambia los nombres de clases y funciones de Dart por nombres sin sentido (OWASP M7).
- `--split-debug-info` guarda aparte los símbolos para leer los errores. **La carpeta `build\simbolos` se guarda junto
  a la llave**, una por versión: sin ella no se puede descifrar un error que reporte una vecina.
- El resultado es `build\app\outputs\flutter-apk\app-release.apk` (un solo APK para todos los teléfonos). Con
  `--split-per-abi` salen tres más pequeños; para repartir a mano, uno solo es más simple.

## 4. Comprobar antes de repartir

| Comprobación | Cómo |
|---|---|
| Está firmado con la llave del equipo | `apksigner verify --print-certs build\app\outputs\flutter-apk\app-release.apk` (build-tools de Android) |
| Versión correcta | `version: 1.0.0+4` en `pubspec.yaml` → «1.0.0» en Ajustes › Aplicaciones › EcoReporte |
| Permisos mínimos | `docs/seguridad.md`, «Revisar el manifiesto combinado» |
| Se actualiza encima de la anterior sin perder reportes | Instalar la 0.3.0, crear un reporte, instalar la 1.0.0 encima |
| Funciona sin cable | Desconectar el teléfono, abrir la app, crear y compartir un reporte |

## 5. Repartir

1. Subir el APK a una carpeta compartida (Drive del equipo) y generar un código QR del enlace.
2. En el teléfono: abrir el enlace, descargar, y permitir «Instalar apps desconocidas» **solo para el navegador o
   Drive** cuando Android lo pida. Explicarle a la vecina que puede volver a desactivarlo después.
3. Anotar en `CHANGELOG.md` qué trae la versión.

> TEC-03 (Firebase App Distribution) quedó fuera del cierre. Si el equipo lo agrega, reemplaza los pasos 1 y 2 y avisa
> a los probadores por correo.

## 6. Versiones

`version: A.B.C+N` en `pubspec.yaml`. `A.B.C` es lo que ve la vecina; `N` (el *versionCode* de Android) **sube siempre**,
aunque sea una corrección mínima: Android no instala un APK con un número menor o igual al que ya tiene.

| Versión | Sprint | Qué trae |
|---|---|---|
| 0.1.0+1 | 1 | Prueba técnica con datos simulados |
| 0.2.0+2 | 2 | Crear y guardar reportes con foto y referencia, sin conexión |
| 0.3.0+3 | 3 | Ubicación automática y compartir por WhatsApp |
| 1.0.0+4 | 4 | Privacidad, borrar reportes, accesibilidad y build firmado |
