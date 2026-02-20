#-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=- Inicio Script -=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-

#=-=-=-=-=-=-=-=-=-=-=-=-=- Passo a Passo =-=-=-=-=-=-=-=-=-=-=-=-=-
# Passo 1.0: Coleta a data atual da máquina;
# Passo 1.1: Compara a data atual com a data registrada;

#=-=-=-=-=-=-=-=-=-=-=-= Inicio Script =-=-=-=-=-=-==-=-=-=-=-=-=-=-

#Variáveis:
$caminho_registro = "HKLM:\SOFTWARE\STF"
$name_value = "Script_Limpeza_Estacao"

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-

# Passo 1.0: Coleta a data atual da máquina:
Try {
    
    # Coleta a data atual da máquina e registra na variável:
    $actual_date = Get-Date -format "MM/yyyy"

    # Coleta dados do Registro especificado:

    $registry_date = Get-ItemPropertyvalue -Path $caminho_registro -Name $name_value
    
} Catch {

    Write-Host "Não foi possível capturar a data atual do computador devido ao erro: "
    write-Host "$_" -BackgroundColor Black -ForegroundColor Red

}

# Passo 1.1: Compara a data atual com a data registrada:
If ($actual_date -eq $registry_date.Script_Limpeza_Estacao) {
    
    Write-Host "O Script de limpeza já rodou este mês!!"

} Else {

    #O retorno sem conteúdo vai rodar o script de limpeza

}

#=-=-=-=-=-=-=-=-=-=-=-=-=-= FIM Script =-=-=-=-=-=-==-=-=-=-=-=-=-=-




# Passo 01: Verifica se o Registro já existe, se não existir, irá cria-lo: (PASSO PÓS-INSTALAÇÃO PARA O SCRIPT DE LIMPEZA VER COM O RICARDO)

try {

    $value = Get-ItemPropertyValue -Path $caminho_registro -Name $name_value

} Catch {
    
    Write-Host "Erro: $_"

}

If ( $value -ne $null ) {

    Write-host "O registro já existe!"

} Else {

    Try {

        #Coloca o valor no registro
        Set-ItemProperty -Path $caminho_registro -Name $name_value -Value "$actual_date"

        Write-Host "Registro criado com sucesso!!"
        
    } Catch {

        Write-Host "Não foi possível criar os registros devido ao erro $_"
    
    }  
}