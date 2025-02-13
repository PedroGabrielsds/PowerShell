#Script Nomes dos Patrimonios
#=============================================================
#Variaveis
$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

$Saida = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Identificadas.txt"

$Patrimonios = Get-Content $Entrada

$Computadores = @()

#==============================================================
#Importando Modulo AD

Try{
    Import-Module ActiveDirectory
    Write-Host "Módulo AD foi importado com sucesso!" -ForegroundColor Green -BackgroundColor Black

}Catch{
    Write-Host "Erro ao importar o módulo Active Directory $_" -ForegroundColor Red -BackgroundColor Black

}

$MaquinasAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN

    ForEach($Maquina in $MaquinasAD){
        $Computadores += [PSCustomObject] @{
            CN = $($Maquina.CN)
            #-Split ',',1)[0]
        
        }
    }

#===============================================================
#InicioAlgoritmo

ForEach($Computador in $ComputadoresAD){
        
    ForEach($Patrimonio in $Patrimonios){
            
        #Write-Host "$($Patrimonio) X $($Computador)"
        If($Computador -match $Patrimonio){
                
            If($Computador -like "*VM"){
                
                Write-Host "Maquina $($Computador) não pode ser excluido do Active Directory"
                
            }Else{

                #Add-Content -path $saida -Value "$($Computador)"
                Write-Host "$($Computador)" -ForegroundColor Green -BackgroundColor Black
                
            }
        }
    }
}

