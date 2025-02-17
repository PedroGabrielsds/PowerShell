#Script Excluir Maquinas AD v2.0
#=======================================================
#Variaveis

$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Computadores = @()

$Entrada = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Maquinas_Doacao.txt"

$Patrimonios = Get-Content $Entrada

$File_MaquinasAD = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Deletar_Maquinas_AD v2.0\MaquinasAD.txt"


#|----------------------------------------------------------------------|
#|                         Passos do Script                             |
#|  1º Passo: Importa o Módulo do Active Directory                      |               
#|  2º Passo: Adiciona todas máquinas do AD em um TXT                   |
#|  3º Passo: 
#|  4º Passo: Tenta identificar máquinas com os patrimônios da planilha |
#|  º Passo: Verifica se existem máquinas VM na lista                   |                       
#|  º Passo: Exclui as maquinas identificadas do Active Directory       |
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

#2º Passo - Adiciona todas máquinas do AD em um txt: 
Try {
    $MaquinasAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN
    ForEach ($Maquina in $MaquinasAD) {

        Add-content -Path $File_MaquinasAD -Value $($Maquina.CN)
        
    }

} Catch {
    Write-Host "Não foi possível adicionar a máquina na variável Computadores!" -ForegroundColor Red -BackgroundColor Black

}




#3º Passo - Identificar máquinas com os patrimônios da planilha:
ForEach ($Patrimonio in $Patrimonios) {

    Get-Content $File_MaquinasAD | Where-Object {$_ -like "*$Patrimonio*"}

}


ForEach ($Computador in $Computadores) {

    ForEach ($Patrimonio in $Patrimonios) {

        If ($Computador -match $Patrimonio){
            Write-Host $Computador -ForegroundColor Green -BackgroundColor Black
    
        }Else {
            Write-Host $Patrimonio -ForegroundColor Red -BackgroundColor Black
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