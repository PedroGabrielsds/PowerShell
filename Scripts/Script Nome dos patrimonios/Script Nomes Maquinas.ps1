#Script Nomes dos Patrimonios
#=============================================================
#Variaveis
$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Identificação dos patrimonios\Planilha_Caseiro.txt"

$Saida = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Identificação dos patrimonios\Maquinas_Identificadas.txt"

$AD = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Identificação dos patrimonios\Patrimonios_AD.txt"

$Computadores = @()

Add-Content -Path $AD -Value $Computadores
 
$Patrimonios = Get-Content $Entrada

#==============================================================
#Importando Modulo AD

Import-Module ActiveDirectory

$MaquinasAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN

ForEach($Maquina in $MaquinasAD){
    $Computadores += [PSCustomObject] @{
        CN = ($Maquina.CN -Split ',',1)[0]
    
    }
}

#===============================================================
#InicioAlgoritmo

ForEach($Computador in $Computadores){

    ForEach($Patrimonio in $Patrimonios){

        Write-Host "$($Patrimonio) X $($Computador.cn)"
        If($Computador -match $Patrimonio){
            #Add-Content -path $saida -Value "$($Computador.CN)"
            #Write-Host $Computador.CN
        }
    }
}

