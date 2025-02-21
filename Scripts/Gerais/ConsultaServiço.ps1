#Consultar serviço do windows
Clear-Host
$Serv = Get-Service -Name Spooler
If ($Serv.Status -eq "Running"){
    Write-Host "Em execução..."
    }
    Else{
    Write-Host "Serviço parado!"
    }