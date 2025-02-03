#Script Nomes dos Patrimonios
#=============================================================
#Variaveis
$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

$Saida = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Identificadas.txt"

$Computadores = @()

Add-Content -Path "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Patrimonios_AD.txt" -Value $($Computadores.CN)

$ComputadoresAD = Get-Content "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Patrimonios_AD.txt"

$Patrimonios = Get-Content $Entrada

#==============================================================
#Importando Modulo AD

Import-Module ActiveDirectory

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
                Write-Host "Maquina $($Computador) não poder ser excluido do Active Directory"
                
            }Else{
                #Add-Content -path $saida -Value "$($Computador)"
                Write-Host "$($Computador)" -ForegroundColor Green -BackgroundColor Black
            
            }
        }
    }
}

