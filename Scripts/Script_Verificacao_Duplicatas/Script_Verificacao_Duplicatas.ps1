#Script conferência de máquinas duplicadas
#===========================================
#Variaveis
$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$End = '\\Arquivos\bds\TEMP\Duplicadas.txt'

$ETU = @()

$ETI = @()

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
           CN = $($Computador)
        }
    } ElseIf ($Computador.CN -match "ETI") {
        $ETI += [PsCustomObject] @{
           CN = $($Computador)
        }

    } Else {
        continue
    
    }
}

ForEach($Estacao_ETU in $ETU){
    ForEach($Estacao_ETI in $ETI){

        If($Estacao_ETU -match $Estacao_ETI){
            $Mensagem = "$($Estacao_ETU), $($Estacao_ETI)"
            Add-Content -Path $End -Value $Mensagem
    
        }
    }
}

#FimAlgoritimo
#=============================================