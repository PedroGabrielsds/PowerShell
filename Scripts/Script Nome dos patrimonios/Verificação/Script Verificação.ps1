#Verificação Maquinas identificadas

$Computadores_Identificados = Get-Content -Path "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Verificação\Patrimonios_no_AD.txt"

$Maquinas_Doacao = Get-Content -Path "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Verificação\Maquinas_Doacao.txt"

$Saida = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script Nome dos patrimonios\Verificação\Maquinas_Identificadas.txt"


#=====================================
#InicioAlgoritmo: 


ForEach($Computador_Identificado in $Computadores_Identificados){
    ForEach($Maquina in $Maquinas_Doacao){

        Write-Host ""    
        If($Maquina -match $Computador_Identificado){
            #Add-Content -Path $Saida -Value ("$($Computador_Identificado) no AD")
            #Write-Host "$($Computador_Identificado) no AD" -ForegroundColor Red -BackgroundColor Black
        }Else{
            Write-Host "$($) Excluido do AD" -ForegroundColor Green -BackgroundColor Black
        }
    }
}