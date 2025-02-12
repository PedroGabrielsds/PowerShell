#Script Excluir Maquinas AD v2.0
#=======================================================
#Variaveis

$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Computadores = @()

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Maquinas_Doacao.txt"

$Patrimonios = Get-Content $Entrada




#|----------------------------------------------------------------------|
#|                         Passos do Script                             |
#|  1º Passo: Importa o Módulo do Active Directory                      |               
#|  2º Passo: Tenta identificar máquinas com os patrimônios da planilha

 |            #Tenta identificar máquinas com os patrimônios da planilha
#|  3º Passo: Verifica se existem máquinas VM na lista                  |                       
#|  4º Passo: Exclui as maquinas identificadas do Active Directory      |
#|                                                                      |
#|----------------------------------------------------------------------|

#==============================================================
#1º Passo - Importando Módulo Active Directory:

Try {
    Import-Module ActiveDirectory 
    Write-Host "Módulo AD importado com sucesso!" -ForegroundColor Green -BackgroundColor Black

} Catch {
    Write-Error "Não foi possível importar o módulo AD - Error: $_"

}

#===============================================================
#InicioAlgoritmo

#2º Passo - Adiciona todas máquinas do AD em uma variável: 
Try {
    $MaquinasAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN
    ForEach ($Maquina in $MaquinasAD) {

        $Computadores += $($Maquina.CN)
    }

} Catch {
    Write-Host "Não foi possível adicionar a máquina na variável Computadores!" -ForegroundColor Red -BackgroundColor Black

}




#3º Passo - Identificar máquinas com os patrimônios da planilha:
ForEach ($Computador in $Computadores) {

    ForEach ($Patrimonio in $Patrimonios) {

        If ($Computador -match $Patrimonio){
            Write-Host $Computador
    
        }
    }
}



#º Passo: Exclui as maquinas identificadas do Active Directory 

ForEach ($Maquina_Encontrada in $Maquinas_Encontradas) {

    Try {

        Remove-ADComputer -Identity "$($Maquina_AD)"

    } Catch {

        Write-Log "Não foi possivel excluir $($Maquina_AD)"
        
    }
}