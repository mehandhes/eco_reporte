# Sistema visual y de interacción de EcoReporte · Sprint 6

> Versión 1.2.0. Mejora la accesibilidad y la experiencia sin cambiar qué hace la app. Se diseña para **una situación**:
> Yolanda, 46 años, de pie en la calle, con sol de mediodía en Barrancabermeja, el teléfono en una mano y la bolsa del
> mandado en la otra.

## Auditoría de la versión 1.1.0

Revisión de la app a la luz de las heurísticas de Nielsen, RC-01 (menos de un minuto) y RC-02 (48 dp, 4,5:1).

| # | Hallazgo | Severidad (0–4) | Qué se hizo |
|---|---|---|---|
| D1 | El botón «Guardar reporte» quedaba al final del formulario: con la foto tomada había que desplazarse para encontrarlo (las propias pruebas automáticas tuvieron que bajar hasta él) | 3 | Barra fija abajo con el botón, al alcance del pulgar |
| D2 | El formulario solo decía qué faltaba **después** de tocar «Guardar» (H5: prevenir el error) | 2 | La barra dice qué falta antes: «Falta: la foto», «Listo. Se guarda aunque no tengas datos.» |
| D3 | Lo obligatorio se marcaba con un asterisco: TalkBack lo lee como «asterisco» y no todo el mundo lo entiende | 2 | «Obligatoria» y «Opcional» escritos en palabras |
| D4 | El verde de UNIPAZ (`#00963F`) con letra blanca da 3,9:1: no pasa RC-02. Material lo oscurecía solo, pero sin control | 2 | Paleta fija con contraste medido (abajo) |
| D5 | Letra por omisión (Roboto 14–16): se cansa la vista con sol y con presbicia | 2 | Atkinson Hyperlegible y cuerpo de 17 |
| D6 | Las seis categorías eran solo texto | 1 | Icono + palabra en cada una |
| D7 | Al guardar no había confirmación si no se alcanza a leer la pantalla | 1 | Vibración corta al guardar |
| D8 | El formulario era una sola columna sin partes: TalkBack no podía saltar de sección en sección | 1 | Títulos «Foto del punto», «Dónde está», «Tipo de residuo», anunciados como encabezados |
| D9 | El tema oscuro no se probaba | 1 | Dos pruebas de accesibilidad en oscuro |
| D10 | «Exportar listado del mes» era un icono sin texto en la barra superior: la presidenta podía no encontrarlo | 1 | Botón con palabra: «Listado» (revisado en el teléfono el 28-oct) |
| D11 | En la lista, tipo y fecha iban en una línea y la hora caía sola al renglón siguiente (visto en el moto g20) | 1 | Tipo con su icono en una línea, fecha en la siguiente; el mismo icono en el formulario, la lista y el detalle |
| D12 | La ayuda de la referencia se apretaba en tres renglones porque el contador «Te quedan 120 caracteres» ocupaba media fila (visto en el moto g20) | 1 | El contador aparece solo cuando faltan 30 o menos |
| D13 | «Ubicación aproximada» se veía igual que «Ubicación lista»; el amarillo señal del tema no se usaba | 2 | El aviso va en amarillo señal, con su icono y sus palabras; la referencia pasa a decir «Recomendada» |

## Tres reglas

1. **Contraste alto siempre.** Todo texto pasa 4,5:1 y casi todo pasa 7:1, en claro y en oscuro.
2. **Letra que no se confunde.** Atkinson Hyperlegible, del Braille Institute, hecha para baja visión: distingue 1, l, I
   y 0, O. Licencia OFL 1.1, va dentro del APK (no se descarga nada: la app no tiene Internet).
3. **Lo importante abajo y grande.** Lo que se toca con el pulgar mide 56 dp de alto; nada mide menos de 48.

## Color

| Nombre | Claro | Uso | Contraste medido |
|---|---|---|---|
| Verde monte | `#0B6B3A` | Botones principales, iconos activos | 6,6:1 con blanco |
| Tinta | `#14231B` | Texto | 15,3:1 sobre papel |
| Papel | `#F6F8F5` | Fondo, apenas verdoso y frío | — |
| Gris hoja | `#3F4F45` | Texto secundario | 8,1:1 sobre papel |
| Amarillo señal | `#FFE08A` | Lo que pide atención sin ser error | 10,2:1 con su texto `#3D2E00` |
| Rojo ladrillo | `#B3261E` | Errores | 6,1:1 sobre papel |

En oscuro: verde `#7FD8A0` sobre `#0F1712` (10,6:1), texto `#E3EBE5` (15:1), secundario `#BCC9C0` (10,6:1). Los
valores completos están en `lib/app/tema.dart`.

## Tipo

| Estilo | Tamaño | Peso | Dónde |
|---|---|---|---|
| titleLarge | 22 | 700 | Barra superior |
| titleMedium | 18 | 700 | Títulos de cada parte del formulario |
| titleSmall | 16 | 700 | Nombre de un estado («Ubicación lista») |
| bodyLarge | 17 | 400 | Texto que se lee |
| bodyMedium | 16 | 400 | Texto de apoyo y la barra de guardar |
| bodySmall | 14 | 400 | Ayudas («Opcional…») |
| labelLarge | 16 | 700 | Botones |

## Formulario «Nuevo reporte»

```
┌──────────────────────────────┐
│ Nuevo reporte                │
├──────────────────────────────┤
│ Foto del punto               │
│ ┌──────────────────────────┐ │
│ │   Toca para tomar la foto │ │
│ │        Obligatoria        │ │
│ └──────────────────────────┘ │
│ Dónde está                   │
│ [ Ubicación lista · ± 8 m ]  │
│ [ Referencia del lugar     ] │
│ Tipo de residuo              │
│ (Bolsas) (Escombros) (…)     │
├──────────────────────────────┤  ← fija, siempre visible
│ ⓘ Falta: la foto             │
│ [      Guardar reporte     ] │  56 dp
└──────────────────────────────┘
```

## Cómo se comprueba

| Qué | Prueba automática | En el teléfono |
|---|---|---|
| 48 dp, nombres para TalkBack, 4,5:1 en claro | `test/accesibilidad_test.dart` | — |
| Lo mismo en oscuro | `test/accesibilidad_test.dart` (grupo «tema oscuro») | Activar el tema oscuro del teléfono |
| 360 dp con letra al 150 % | `test/accesibilidad_test.dart` | Letra al máximo en Ajustes |
| La barra dice qué falta | `test/nuevo_reporte_viewmodel_test.dart`, `test/widget_test.dart` | Sí |
| Se lee al sol | — | **Sí: al aire libre, a mediodía** |
| Vibración al guardar | — | Sí |
| RC-01 (menos de un minuto) | — | Prueba de usabilidad (INV-02): comparar con la 1.1.0 si se alcanzó a medir |

## Marca y pantalla de inicio

**Logo.** Un marcador de mapa con una hoja dentro: el marcador dice *dónde* (la app sirve para señalar un punto) y la
hoja dice *para qué* (un barrio limpio). Es un dibujo original del proyecto, con dos colores del tema.

| Pieza | Dónde vive | Cómo se hizo |
|---|---|---|
| Logo dentro de la app | `lib/ui/comun/logo.dart` | Dibujado con código (`CustomPainter`): nítido a cualquier tamaño, toma los colores del tema claro u oscuro |
| Icono de la app | `android/app/src/main/res/mipmap-*/ic_launcher.png` | Marcador blanco sobre «verde monte», con la misma forma; 48 a 192 px |
| Arranque de Android (11 y anteriores) | `res/drawable*/launch_background.xml` + `drawable-xxhdpi/logo_inicio.png` | Fondo «papel» (o el oscuro) con el logo al centro, sin destello blanco |

**Eslogan:** «Tu barrio limpio empieza con una foto.» Dice qué hace la vecina (una foto) y para qué (el barrio), sin
prometer lo que la app no controla, como que la empresa recoja.

**Pantalla de inicio** (`lib/ui/inicio/pantalla_inicio.dart`):

```
┌──────────────────────────────┐
│ [logo]                       │
│ EcoReporte                   │  40, negrita
│ Tu barrio limpio empieza     │
│ con una foto.                │
│ ┌──────────────────────────┐ │
│ │ Mis reportes           › │ │  «6 guardados en este teléfono»
│ │ Listado del mes        › │ │  apagado si no hay reportes
│ │ Privacidad             › │ │
│ └──────────────────────────┘ │
├──────────────────────────────┤  fija, como la barra de «Guardar»
│ [ 📷  Reportar un punto    ] │  64 dp: el botón principal
│ Se guarda en tu teléfono,    │
│ aunque no tengas datos.      │
└──────────────────────────────┘
```

No es una pantalla de espera con temporizador: se puede reportar desde el primer segundo (RC-01). «Mis reportes» pasa a
la ruta `/reportes` y conserva su botón «Reportar».
