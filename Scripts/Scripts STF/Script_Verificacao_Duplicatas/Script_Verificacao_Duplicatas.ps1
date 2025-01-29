#Script conferência de máquinas duplicadas
#===========================================
#Variaveis
$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$End = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script_Verificacao_Duplicatas\Duplicadas.txt'

$End1 = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script_Verificacao_Duplicatas\ETI.txt'

$End2 = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script_Verificacao_Duplicatas\ETU.txt'

$ETU = @()

$ETI = @()

Add-Content -Path $End1 -Value $($ETI)

Add-Content -Path $End2 -Value $($ETU)
#===========================================
#Importando módulo AD

Try {
    Import-Module ActiveDirectory 
    Write-Host "Módulo Importado com sucesso..."
} Catch {
    Write-Host "Ocorreu um erro ao importar o módulo AD!!"
}

$Computadores = @()

$MaquinasAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN

ForEach($Maquina in $MaquinasAD){
    $Computadores += [PSCustomObject] @{
        CN = ($Maquina.CN -Split ',',1)[0]
    
        }
}
#===========================================
#InicioAlgoritimo 
 
ForEach($Computador in $Computadores){

    If ($Computador.CN -match "ETU") {
        $ETU += [PsCustomObject] @{
           CN = $($Computador.CN)
        }
    } ElseIf ($Computador.CN -match "ETI") {
        $ETI += [PsCustomObject] @{
           CN = $($Computador.CN)
        }

    } Else {
        continue
    
    }
}

ForEach($Estacao_ETU in $ETU){
    ForEach($Estacao_ETI in $ETI){

        If($Estacao_ETU -eq $Estacao_ETI){

            Write-Host "$($Computador.CN)"
        
        }
    }
}



#FimAlgoritimo
#=============================================
