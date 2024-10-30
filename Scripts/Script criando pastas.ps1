#Criando pastas para o Script principal

Function Nomear-Pastas{
    $Nome = Read-Host ("Digite o nome da estação")
    $Caminho  = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script nomes das maquinas\EstaçoesSTF\" + "$Nome"
    New-Item -Path $Caminho -ItemType Directory
}  

Function Script{
    Nomear-Pastas
    $Resp = Read-Host ("Deseja continuar S/N ?")
    If($Resp -match 'S'){
        cls
        Script
    }Else{
        Write-Host ("Processo Finalizado!!")
    }
}

#---------------------------------------------------------
#Inicio Script

Script


