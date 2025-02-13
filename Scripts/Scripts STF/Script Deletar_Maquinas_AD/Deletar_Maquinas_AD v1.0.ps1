#Script Nomes dos Patrimonios
#=============================================================
#Variaveis

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Maquinas_Doacao.txt"

$Patrimonios = Get-Content $Entrada

$Endereco_Maquinas_Encontradas = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Maquinas_Encontradas.txt"

$Maquinas_Encontradas = Get-Content $Endereco_Maquinas_Encontradas

$LogFile = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Log\Log de Teste.log"

Function Write-Log {
    Param(
        [String]$Message
    )
    Try {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
        $Message | Out-File -Append -FilePath $LogFile -Encoding UTF8 -ErrorAction Stop
    }
    Catch {
        Write-Host "Erro ao gravar no log: $_"
    }
}

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
     
        Write-log -Message "Não foi possivel buscar as maquinas no AD"
    
    }

    $Maquinas = ($($Maquinas) -split ',',2)[0]
    
    If ($Maquinas.Count -gt 0) {
        
        ForEach ($Maquina in $Maquinas) {

            #2º Passo: Verifica se existem máquinas VM na lista
            If ($Maquina -like "*VM") {
     
                #Write-Host "Maquina $($Computador) não pode ser excluido do Active Directory"
                #Add-Content -Path $Endereco_Maquinas_VM -Value ($($Maquinas) -split '=',2)[1]
                Write-log -Message "Maquina $($Computador) não pode ser excluido do Active Directory"
     
            } Else {
                
                #Add-Content -path $Endereco_Maquinas_Encontradas -value ($($Maquinas) -split '=',2)[1]
                #Write-Host ($($Maquina) -split '=',2)[1] -ForegroundColor Green -BackgroundColor Black 
                Write-log -Message ($($Maquinas) -split '=',2)[1]
                
            }
        }
    } Else {
        #Add-Content -Path $Endereco_Maquinas_Nao_Encontradas -Value $Patrimonio
        #Write-Host $Patrimonio
        Write-log -Message "$Patrimonio"
        
    }
}

#3º Passo: Exclui as maquinas identificadas do Active Directory
ForEach ($Maquina_Encontrada in $Maquinas_Encontradas) {

    Try {

        Remove-ADComputer -Identity "$($Maquina_AD)"

    } Catch {

        Write-Log "Não foi possivel excluir a máquina $($Maquina_Encontrada) do Active Directory"
        
    }
}










               

       
    


