#Script para Remover Máquinas do Active Direcroty:
#==================================================
#Variaveis: 

$OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Patrimonios = '\\Caminho para arquivo com patrimonios'

#|-------------------------------------------------------|
#|                   Passos do Script                    |
#|                                                       |
#| 1º Passo: Importar Módulo AD                          |
#| 2º Passo: Adicionar máquinas do AD em uma variavel    |
#| 3º Passo: Procurar por patrimonios nas maquinas AD    |
#| 4º Passo: Excluir Máquinas do AD                      |
#|                                                       |
#|-------------------------------------------------------|

#--------------------------------------------------
#Importando Módulo Active Directory 

[String]$FaseDoScript = 'Importando módulo AD'
#1º Passo - Importar Módulo AD 
Try {
    Import-Module Active-Directory 
    Write-Log -message "Módulo do AD importado com sucesso!"

} Catch {
    Write-Log -message "Não foi possível importar o módulo do AD! Error: $_" -Severity 3

}

#---------------------------------------------------
#Inicio Script 

#2º Passo - Adicionar máquinas do AD em uma variavel 
$Maquinas_AD += (Get-ADComputer -Filter * -SearchBase $OU -Properties CN).CN

#Verificando se os patrimônios existem! 
If ($Patrimonios.count -gt 0) {
    
    foreach ($Patrimonio in $Patrimonios) {
        #Remove os espaços de cada patrimonio
        $Patrimonio = $Patrimonio.Trim()

        #Verifica se a linha está em branco
        If (-not($Patrimonio)) {

            Write-Log -message "Foi encontrado um patrimonio em branco e o script vai ignora-lo!" -Severity 2
            Continue
    
        } Else {

            [String]$FaseDoScript = 'Localizando Máquina no AD'
            #3º Passo - Procurar por patrimonios nas maquinas AD
            Try {
                $Maquina_Encontrada = $Maquinas_AD | Where-Object {$_ -match $Patrimonio}
                $Maquina_Encontrada = $Maquina_Encontrada.Trim()
                Write-Log -message "Máquina $Maquina_Encontrada localizada!" 

            } Catch {
                Write-Log -message "A máquina $Maquina_Encontrada não foi localizada no AD!" -Severity 3

            }
            
            [String]$FaseDoScript = 'Excluíndo máquina do AD'
            #4º Passo - Excluir Máquinas do AD
            Try {
                Remove-AdComputer -Identity $Maquina_Encontrada
                Write-Log -message "Máquina $Maquina_Encontrada foi excluída com êxito!" 

            } Catch {
                Write-Log -message "Não foi possível excluir a máquina $Maquina_Encontrada do AD! Error: $_" -Severity 3

            }
        }
    }
    
} Else {
    Write-Log -message "Arquivos de patrimônios vazio!" -Severity 3
    Exit
    
}
















#======================================================

