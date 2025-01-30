#Script Verificação Maquinas Doação
#=============================================================
#Variaveis

$Endereço_Maquinas_Identificadas_AD = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Identificadas.txt"

$Endereço_Maquinas_Doadas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

$Maquinas_Encontrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Excluida_Ou _Não\Falta_Excluir.txt"

$Maquinas_Nao_Encontrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Excluida_Ou _Não\Excluidas.txt"

$Maquinas_Identificadas_AD = Get-Content -Path $Endereço_Maquinas_Identificadas_AD

$Maquinas_Doadas = Get-Content -Path $Endereço_Maquinas_Doadas

$Teste1 = Get-Content -Path 

$Teste2 = 

#==============================================================
#InicioAlgoritmo

ForEach($Maquina_AD in $Maquinas_Identificadas_AD){

    ForEach($Maquina_Doada in $Maquinas_Doadas){

        #Write-Host "$Maquina_AD X $Maquina_Doada"
        If($Maquina_Doada - $Maquina_AD){

            #Add-Content -Path $Maquinas_Encontrada -Value "$Maquina_Doada = $Maquina_AD - Falta Excluir do AD"
            #[num]$Encontrou = 1
            Write-Host "$Maquina_Doada = $Maquina_AD - Falta Excluir do AD" -ForegroundColor Red -BackgroundColor Black
            Continue
        
        }Else{

           #Write-Host "$Maquina_Doada = $Maquina_AD - Foi Excluida" -ForegroundColor Green -BackgroundColor Black
        }
    }
    Write-Host "==================================="
}











#==============================================================
#FimAlgoritmo
