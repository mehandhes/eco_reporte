<#
  Actualiza el tablero «EcoReporte» (GitHub Projects) al cierre del Sprint 4.

  Qué hace:
    1. Cierra el issue #39, que es un duplicado de INV-03 (#19).
    2. Crea los elementos nuevos del plan de cierre: TEC-04, TEC-05, TEC-06 e INV-05,
       con su etiqueta, y los añade al proyecto.
    3. Pone Status, Tipo, Prioridad, Épica y Puntos a esos elementos y a INV-02.

  Los issues #2 a #9 (TEC-02 y las 7 historias Must) ya se cerraron solos con el push,
  porque los commits decían «Closes #N»; el flujo «Item closed» del proyecto los pasa a «Hecho».

  Uso (una sola vez, desde la carpeta del repositorio):
    gh auth refresh -s project
    .\scripts\actualizar-tablero-cierre.ps1
#>
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Duenio   = 'mehandhes'
$Repo     = 'mehandhes/eco_reporte'
$Numero   = 5            # https://github.com/users/mehandhes/projects/5
$NombreProyecto = 'EcoReporte'

# ── Datos del proyecto y de sus campos ─────────────────────────────────────
$proyecto = gh project view $Numero --owner $Duenio --format json | ConvertFrom-Json
$campos   = (gh project field-list $Numero --owner $Duenio --format json --limit 50 | ConvertFrom-Json).fields

function Campo([string]$nombre) {
    $c = $campos | Where-Object { $_.name -eq $nombre }
    if (-not $c) { throw "No encuentro el campo '$nombre' en el proyecto." }
    return $c
}

function PonerOpcion([string]$item, [string]$campo, [string]$valor) {
    $c = Campo $campo
    $op = $c.options | Where-Object { $_.name -eq $valor }
    if (-not $op) { Write-Warning "El campo '$campo' no tiene la opción '$valor'. Se omite."; return }
    gh project item-edit --id $item --project-id $proyecto.id --field-id $c.id --single-select-option-id $op.id | Out-Null
}

function PonerNumero([string]$item, [string]$campo, [double]$valor) {
    $c = Campo $campo
    gh project item-edit --id $item --project-id $proyecto.id --field-id $c.id --number $valor | Out-Null
}

function ItemDeIssue([int]$numeroIssue) {
    $items = (gh project item-list $Numero --owner $Duenio --format json --limit 300 | ConvertFrom-Json).items
    $it = $items | Where-Object { $_.content.number -eq $numeroIssue -and $_.content.repository -like "*eco_reporte" }
    if (-not $it) {
        # No está en el proyecto: se añade.
        $url = "https://github.com/$Repo/issues/$numeroIssue"
        $it = gh project item-add $Numero --owner $Duenio --url $url --format json | ConvertFrom-Json
    }
    return @($it)[0].id
}

# ── 1. Duplicado ──────────────────────────────────────────────────────────
$dup = gh issue view 39 --repo $Repo --json state,title | ConvertFrom-Json
if ($dup.state -eq 'OPEN') {
    gh issue close 39 --repo $Repo --reason 'not planned' --comment 'Duplicado de #19 (INV-03), creado por una segunda ejecución de crear-backlog.ps1.' | Out-Null
    Write-Host '#39 cerrado como duplicado de #19.'
}

# ── 2. Elementos nuevos del plan de cierre ────────────────────────────────
$nuevos = @(
    @{ Id='TEC-04'; Titulo='Calidad: plan de pruebas, accesibilidad y medición en gama de entrada'; Etiqueta='tecnica'
       Cuerpo="Plan de pruebas que une cada escenario y requisito de calidad con su prueba (docs/calidad/plan-de-pruebas.md), guías de accesibilidad automáticas (test/accesibilidad_test.dart) y medición de RC-03 y RC-04 en el teléfono.`n`nCódigo fusionado en main (73 pruebas en verde). Falta: medir RC-03 y RC-04 en el moto g20 y anotarlos en el plan de pruebas."
       Tipo='Técnica'; Prioridad='Must'; Epica='Base'; Puntos=3; Estado='En dispositivo' },
    @{ Id='TEC-05'; Titulo='Seguridad y privacidad (OWASP Mobile Top 10, Ley 1581)'; Etiqueta='tecnica'
       Cuerpo="Aviso de privacidad antes del primer reporte, borrar un reporte con su foto, allowBackup=false, sin INTERNET en release. Revisión M1–M10 en docs/seguridad.md y política en docs/privacidad.md.`n`nCódigo fusionado en main. Falta: revisar los permisos del APK con aapt2 y poner un contacto real como responsable."
       Tipo='Técnica'; Prioridad='Must'; Epica='Base'; Puntos=3; Estado='En dispositivo' },
    @{ Id='TEC-06'; Titulo='Build de release firmado'; Etiqueta='tecnica'
       Cuerpo="Firma con android/key.properties, compilación ofuscada y versión 1.0.0+4 (docs/distribucion.md).`n`nFalta: crear la llave del equipo y generar el APK firmado con ella."
       Tipo='Técnica'; Prioridad='Must'; Epica='Base'; Puntos=2; Estado='En dispositivo' },
    @{ Id='INV-05'; Titulo='Demo Day: pitch, modelo de impacto y guion de la demo'; Etiqueta='investigacion'
       Cuerpo="Guion en docs/cierre/demo-day.md: pitch de 5 minutos, demo en modo avión con plan B y preguntas de la defensa. Falta: ensayarlo y grabar el video del plan B."
       Tipo='Investigación'; Prioridad='Must'; Epica='Comunidad'; Puntos=3; Estado='Listo' }
)

$existentes = gh issue list --repo $Repo --state all --limit 200 --json number,title | ConvertFrom-Json

foreach ($n in $nuevos) {
    $ya = $existentes | Where-Object { $_.title -like "$($n.Id):*" }
    if ($ya) {
        $num = @($ya)[0].number
        Write-Host "$($n.Id) ya existe (#$num): no se vuelve a crear."
    } else {
        $url = gh issue create --repo $Repo --title "$($n.Id): $($n.Titulo)" --body $n.Cuerpo --label $n.Etiqueta
        $num = [int]($url -split '/')[-1]
        Write-Host "$($n.Id) creado: #$num"
    }
    $item = ItemDeIssue $num
    PonerOpcion $item 'Status'    $n.Estado
    PonerOpcion $item 'Tipo'      $n.Tipo
    PonerOpcion $item 'Prioridad' $n.Prioridad
    PonerOpcion $item 'Épica'     $n.Epica
    PonerNumero $item 'Puntos'    $n.Puntos
}

# ── 3. INV-02 pasa al último sprint ───────────────────────────────────────
$inv02 = ItemDeIssue 18
PonerOpcion $inv02 'Status' 'Listo'
gh issue comment 18 --repo $Repo --body 'Sprint 4: la validación se hace ahora como prueba de usabilidad con la app instalada. Protocolo en docs/validacion/prueba-usabilidad.md.' | Out-Null
Write-Host 'INV-02 en «Listo», con el protocolo enlazado.'

Write-Host ''
Write-Host "Listo. Abre https://github.com/users/$Duenio/projects/$Numero y revisa la columna «Hecho»."
Write-Host 'Si algún issue cerrado (#2 a #9) no está en «Hecho», muévelo a mano o activa el flujo «Item closed» en Workflows.'
