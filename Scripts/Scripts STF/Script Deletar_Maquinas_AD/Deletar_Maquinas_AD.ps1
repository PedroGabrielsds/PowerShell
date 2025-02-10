#Script Nomes dos Patrimonios
#=============================================================
#Variaveis

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

$Patrimonios = Get-Content $Entrada

$Endereco_Maquinas_Encontradas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Encontradas.txt"

$Maquinas_Encontradas = Get-Content $Endereco_Maquinas_Encontradas

$Endereco_Maquinas_Nao_Encontradas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Nao_Encontradas.txt"

$Endereco_Maquinas_VM = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_VM.txt"

#|----------------------------------------------------------------------|
#|                         Passos do Script                             |                     
#|  1º Passo: Tenta identificar máquinas com os patrimônios da planilha |                                                                    
#|  2º Passo: Verifica se existem máquinas VM na lista                  |
#|  3º Passo: Exclui as maquinas identificadas do Active Directory      |                                                               
#|                                                                      |
#|----------------------------------------------------------------------|

#===============================================================
#InicioAlgoritmo

#1º Passo: Identificar máquinas com os patrimônios da planilha
ForEach ($Patrimonio in $Patrimonios) {

    Try {
        
        $Maquinas = Get-ADComputer -Filter "Name -like '*$Patrimonio*'" -Properties CN
    
    } Catch {

        Write-Host "Não foi possivel buscar as maquinas no AD"
    
    }

    $Maquinas = ($($Maquinas) -split ',',2)[0]
    
    If ($Maquinas.Count -gt 0) {
        
        ForEach ($Maquina in $Maquinas) {

            #2º Passo: Verifica se existem máquinas VM na lista
            If($Maquina -like "*VM"){
     
                #Write-Host "Maquina $($Computador) não pode ser excluido do Active Directory"
                Add-Content -Path $Endereco_Maquinas_VM -Value ($($Maquinas) -split '=',2)[1]
     
            }Else{
                
                Add-Content -path $Endereco_Maquinas_Encontradas -value ($($Maquinas) -split '=',2)[1]
                #Write-Host ($($Maquinas) -split '=',2)[1] -ForegroundColor Green -BackgroundColor Black  
                
                #3º Passo: Exclui as maquinas identificadas do Active Directory 
                Try {

                    Remove-ADComputer -Identity "$($Maquina_AD)"

                } Catch {

                    Write-Host "Não foi possivel excluir $($Maquina_AD)"
    
                }
            }
        }
    } Else {
        Add-Content -Path $Endereco_Maquinas_Nao_Encontradas -Value $Patrimonio
        
    }
}








               

       
    


