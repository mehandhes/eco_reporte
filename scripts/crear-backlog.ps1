<#
  Crea las etiquetas y los issues del backlog de EcoReporte, y los añade al proyecto de GitHub.

  Uso (PowerShell, desde la carpeta del repositorio):
    gh auth refresh -s project      # una sola vez
    .\scripts\crear-backlog.ps1 -Proyecto "EcoReporte"

  Después, en la vista de tabla del proyecto, rellena Tipo, Prioridad, Épica, Puntos y Sprint.
#>
param(
    [string]$Proyecto = "EcoReporte"
)

$ErrorActionPreference = "Stop"

# Etiquetas por tipo de elemento (--force las actualiza si ya existen)
gh label create historia      --color 2FD27A --description "Historia de usuario" --force
gh label create tecnica       --color FFCB6B --description "Tarea técnica" --force
gh label create defecto       --color FF6B7A --description "Defecto" --force
gh label create bloqueada     --color B60205 --description "Bloqueada: se menciona en el Daily" --force
gh label create investigacion --color 8FA3FF --description "Investigación o validación con usuarios" --force

# Un issue por elemento, en el orden del backlog.
# Los de cuerpo largo (historias Must) leen su cuerpo de scripts\issues\.
$elementos = @(
    @{ Id = 'TEC-01'; Titulo = 'Crear proyecto y migrar a material_ui'; Etiqueta = 'tecnica'; Cuerpo = 'Crear el proyecto Flutter, migrarlo a material_ui y configurar ramas y protección de main.'; Archivo = '' },
    @{ Id = 'TEC-02'; Titulo = 'Modelo Reporte y repositorio SQLite'; Etiqueta = 'tecnica'; Cuerpo = 'Modelo Reporte y repositorio SQLite con sus pruebas. Reemplaza al repositorio simulado de INV-04 sin tocar las pantallas.'; Archivo = '' },
    @{ Id = 'HU-01'; Titulo = 'Tomar la foto del punto crítico'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-01.md' },
    @{ Id = 'HU-02'; Titulo = 'Ubicación automática'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-02.md' },
    @{ Id = 'HU-12'; Titulo = 'Referencia del lugar'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-12.md' },
    @{ Id = 'HU-03'; Titulo = 'Guardar el reporte en el teléfono'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-03.md' },
    @{ Id = 'HU-04'; Titulo = 'Lista de mis reportes'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-04.md' },
    @{ Id = 'HU-05'; Titulo = 'Detalle de un reporte'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-05.md' },
    @{ Id = 'HU-10'; Titulo = 'Compartir por WhatsApp'; Etiqueta = 'historia'; Cuerpo = ''; Archivo = 'scripts/issues/HU-10.md' },
    @{ Id = 'HU-06'; Titulo = 'Categoría del residuo'; Etiqueta = 'historia'; Cuerpo = 'Como vecina, quiero elegir la categoría del residuo para que la empresa sepa qué recoger.'; Archivo = '' },
    @{ Id = 'HU-07'; Titulo = 'Subir mis reportes pendientes con un botón'; Etiqueta = 'historia'; Cuerpo = 'Como vecina, quiero subir mis reportes pendientes con un botón. Antes: investigación de 2 horas para elegir entre Supabase y Firebase.'; Archivo = '' },
    @{ Id = 'HU-13'; Titulo = 'Subida automática al recuperar la conexión'; Etiqueta = 'historia'; Cuerpo = 'Como vecina, quiero que mis reportes pendientes se suban solos al recuperar la conexión.'; Archivo = '' },
    @{ Id = 'HU-09'; Titulo = 'Exportar listado para la JAC'; Etiqueta = 'historia'; Cuerpo = 'Como presidenta de la JAC, quiero exportar el listado del mes para llevarlo a la empresa de aseo.'; Archivo = '' },
    @{ Id = 'HU-08'; Titulo = 'Mapa de reportes del barrio'; Etiqueta = 'historia'; Cuerpo = 'Como vecina, quiero ver en un mapa los reportes de mi barrio para no repetir uno que ya existe.'; Archivo = '' },
    @{ Id = 'TEC-03'; Titulo = 'Firebase App Distribution'; Etiqueta = 'tecnica'; Cuerpo = 'Configurar Firebase App Distribution para repartir el APK de prueba.'; Archivo = '' },
    @{ Id = 'HU-11'; Titulo = 'Aviso cuando se recoja'; Etiqueta = 'historia'; Cuerpo = 'Como vecina, quiero recibir un aviso cuando se recoja un punto que reporté para saber que sirvió.'; Archivo = '' },
    @{ Id = 'INV-01'; Titulo = 'Proto-persona y mapa de experiencia'; Etiqueta = 'investigacion'; Cuerpo = 'Persona principal y mapa de la situación actual. Resultado en docs/requisitos.md.'; Archivo = '' },
    @{ Id = 'INV-02'; Titulo = 'Validar criterios con dos vecinos'; Etiqueta = 'investigacion'; Cuerpo = 'Entrevista de 15 minutos a dos vecinos del barrio Primero de Mayo. Guion en docs/validacion/. Resultado: una ficha por persona, como comentario de este issue.'; Archivo = '' },
    @{ Id = 'INV-03'; Titulo = 'Documento de requisitos v0.1'; Etiqueta = 'investigacion'; Cuerpo = 'docs/requisitos.md con persona, mapa, alcance del MVP, requisitos de calidad y hallazgos heurísticos.'; Archivo = '' },
    @{ Id = 'INV-04'; Titulo = 'Prueba técnica del examen'; Etiqueta = 'investigacion'; Cuerpo = 'HU-04 y HU-05 con datos simulados y los cuatro estados de la lista, en la rama examen/sprint1-tecnico. Límite: 90 minutos.'; Archivo = '' }
)

foreach ($e in $elementos) {
    $titulo = "$($e.Id): $($e.Titulo)"
    Write-Host "Creando $titulo"
    if ($e.Archivo) {
        gh issue create --title $titulo --body-file $e.Archivo --label $e.Etiqueta --project $Proyecto
    } else {
        gh issue create --title $titulo --body $e.Cuerpo --label $e.Etiqueta --project $Proyecto
    }
}

Write-Host ""
Write-Host "Listo: 20 issues. Revisa el proyecto con: gh project item-list <N> --owner <USUARIO>"
