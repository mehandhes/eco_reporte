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

# Un issue por elemento, en el orden del backlog.
# Los de cuerpo largo (historias Must) leen su cuerpo de scripts\issues\.
$elementos = @(
    @{ Id = 'TEC-01'; Titulo = 'Crear proyecto y migrar a material_ui'; Etiqueta = 'tecnica'; Cuerpo = 'Crear el proyecto Flutter, migrarlo a material_ui y configurar ramas y protección de main.'; Archivo = '' },
    @{ Id = 'HU-01'; Titulo = 'Tomar foto del punto crítico'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero tomar una foto del punto crítico para mostrar el estado real del lugar.'; Archivo = '' },
    @{ Id = 'HU-02'; Titulo = 'Ubicación automática'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero que la app tome mi ubicación automáticamente para no escribir la dirección.'; Archivo = '' },
    @{ Id = 'TEC-02'; Titulo = 'Modelo Reporte y repositorio SQLite'; Etiqueta = 'tecnica'; Cuerpo = 'Modelo Reporte y repositorio SQLite con sus pruebas.'; Archivo = '' },
    @{ Id = 'HU-03'; Titulo = 'Guardar sin conexión'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero guardar el reporte aunque no tenga datos para enviarlo cuando tenga señal.'; Archivo = '' },
    @{ Id = 'HU-04'; Titulo = 'Lista de mis reportes'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero ver la lista de mis reportes para saber cuáles ya hice.'; Archivo = '' },
    @{ Id = 'HU-05'; Titulo = 'Detalle de un reporte'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero abrir el detalle de un reporte para ver la foto y el lugar.'; Archivo = '' },
    @{ Id = 'HU-06'; Titulo = 'Categoría del residuo'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero elegir la categoría del residuo para que la empresa sepa qué recoger.'; Archivo = '' },
    @{ Id = 'HU-09'; Titulo = 'Exportar listado para la JAC'; Etiqueta = 'historia'; Cuerpo = 'Como presidenta de la JAC, quiero exportar el listado del mes para llevarlo a la empresa de aseo.'; Archivo = '' },
    @{ Id = 'HU-07'; Titulo = 'Sincronizar con la nube'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero que mis reportes se suban solos a la nube al recuperar la conexión.'; Archivo = '' },
    @{ Id = 'HU-08'; Titulo = 'Mapa de reportes del barrio'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero ver en un mapa los reportes de mi barrio para no repetir uno que ya existe.'; Archivo = '' },
    @{ Id = 'TEC-03'; Titulo = 'Firebase App Distribution'; Etiqueta = 'tecnica'; Cuerpo = 'Configurar Firebase App Distribution para repartir el APK de prueba.'; Archivo = '' },
    @{ Id = 'HU-10'; Titulo = 'Compartir por WhatsApp'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero compartir un reporte por WhatsApp para avisar a mis vecinos.'; Archivo = '' },
    @{ Id = 'HU-11'; Titulo = 'Aviso cuando se recoja'; Etiqueta = 'historia'; Cuerpo = 'Como vecino, quiero recibir un aviso cuando se recoja un punto que reporté para saber que sirvió.'; Archivo = '' }
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
Write-Host "Listo: 14 issues. Revisa el proyecto con: gh project item-list <N> --owner <USUARIO>"
