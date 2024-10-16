#Teste de internet
Clear
$Conn = (Test-Connection www.google.com -Count 1 -Quiet)
If($Conn -eq "True"){
    Write-Host "Internet funcionando!" -ForegroundColor Yellow
    }