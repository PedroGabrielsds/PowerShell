#Script conferência de máquinas duplicadas
#===========================================
#Variaveis
$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$ETU_ETI = @()

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
        $ETU_ETI += [PsCustomObject] @{
            CN = $Computador.CN
        }
    } ElseIf ($Computador.CN -match "ETI") {
        Add-Content -Path 

    } Else {
        continue
    
    }
}

#FimAlgoritimo
#=============================================