#Script verificação de nomes das impressoras!

$ListaDeImpressoras = Get-Content 'C:\Temp\Nomes_Impressoras.txt'

$Padrao = '^(IMP|ETIQ)\d{6}(-\w+)?$'


function EscreveLog {
    param (
        [string]$LogPath = "C:\Temp\Logs\meulog.log",
        [string]$LogMessage = "Impressora fora do padrão!",
        [string]$LogType = "INFO" 
    )

    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $formattedMessage = "$timeStamp [$LogType] $LogMessage"

    Add-Content -Path $LogPath -Value $formattedMessage
}

WorkFlow Iniciar-Notas {

  Start-Process 'C:\Temp\Impressoras_Corretas.txt'
  Sleep 2
  Start-Process 'C:\Temp\Impressoras_Incorretas.txt'
  Sleep 1
  Start-Process 'C:\Temp\Logs\meulog.log'
}

ForEach ($Impressoras in $ListaDeImpressoras){
       If($Impressoras -match $Padrao){
            $Script = "`n $Impressoras"
            Add-Content -Path "C:\Temp\Impressoras_Corretas.txt" -value $Script   
       }Else{
            $Script2 = "`n $Impressoras" 
            Add-Content -Path "C:\Temp\Impressoras_Incorretas.txt" -value $Script2
            EscreveLog
       }
}
Iniciar-Notas




