#Criando um LOG

function Write-CMTraceLog {
    param (
        [string]$LogPath,     # Caminho do arquivo de log
        [string]$LogMessage,    # Mensagem de log a ser gravada
        [string]$LogType = "INFO" # Tipo de log (INFO, ERROR, WARNING)
    )

    # Pega a data e hora atual no formato correto para o CMTrace
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    # Formata a mensagem no estilo padrão do CMTrace
    $formattedMessage = "$timeStamp [$LogType] $LogMessage"

    # Adiciona a mensagem ao arquivo de log
    Add-Content -Path $LogPath -Value $formattedMessage
}