#Script Nomes dos Patrimonios
#=============================================================
#Variaveis

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

$Patrimonios = Get-Content $Entrada

$Endereco_Maquinas_Encontradas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Encontradas.txt"

$Endereco_Maquinas_Nao_Encontradas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Nao_Encontradas.txt"

$Endereco_Maquinas_VM = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_VM.txt"

#===============================================================
#InicioAlgoritmo

ForEach ($Patrimonio in $Patrimonios) {
 
    $Maquinas = Get-ADComputer -Filter "Name -like '*$Patrimonio*'" -Properties CN
    $Maquinas = ($($Maquinas) -split ',',2)[0]
    
    
    If ($Maquinas.Count -gt 0) {
        
        ForEach ($Maquina in $Maquinas) {
            
            If($Maquina -like "*VM"){
     
                #Write-Host "Maquina $($Computador) não pode ser excluido do Active Directory"
                Add-Content -Path $Endereco_Maquinas_VM -Value ($($Maquinas) -split '=',2)[1]
     
            }Else{

                Add-Content -path $Endereco_Maquinas_Encontradas -value ($($Maquinas) -split '=',2)[1]
                #Write-Host ($($Maquinas) -split '=',2)[1] -ForegroundColor Green -BackgroundColor Black   
    
            }
        }

    } Else {
        #Add-Content -Path $Endereco_Maquinas_Nao_Encontradas -Value $Patrimonio
        #Write-Host $Patrimonio -ForegroundColor Red -BackgroundColor Black
        
    }
}

               

       
    


