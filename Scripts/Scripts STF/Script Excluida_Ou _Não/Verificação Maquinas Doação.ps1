#Script Verificação Maquinas Doação
#=============================================================
#Variaveis

$Endereço_Maquinas_Identificadas_AD = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Identificadas.txt"

$Endereço_Maquinas_Doadas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

$Maquinas_Encontrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Excluida_Ou _Não\Falta_Excluir.txt"

$Maquinas_Nao_Encontrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Excluida_Ou _Não\Excluidas.txt"

$Maquinas_Identificadas_AD = Get-Content -Path $Endereço_Maquinas_Identificadas_AD

$Maquinas_Doadas = Get-Content -Path $Endereço_Maquinas_Doadas

$Teste1 = Get-Content -Path "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Excluida_Ou _Não\Teste1.txt"

$Teste2 = Get-Content -Path "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Excluida_Ou _Não\Teste2.txt"

#==============================================================
#InicioAlgoritmo

ForEach($Teste in $Teste1){

    ForEach($Test in $Teste2){
        
        Write-Host "$($Teste) X $($Test)"
        If($Teste.Contains($Test)){
            
            #Add-Content -Path $Maquinas_Encontrada -Value "$Maquina_Doada = $Maquina_AD - Falta Excluir do AD"
            #[num]$Encontrou = 1
            Write-Host "A maquina $($Test) contém o Patrimonio $($Teste)" -ForegroundColor Green -BackgroundColor Black
            
        }Else{
           
           #Write-Host "A maquina $($Test) não contém o Patrimonio $($Teste)" -ForegroundColor Red -BackgroundColor Black
           #Write-Host "$Maquina_Doada = $Maquina_AD - Foi Excluida" -ForegroundColor Green -BackgroundColor Black
        }
    }
    Write-Host "=========================="
}











#==============================================================
#FimAlgoritmo
