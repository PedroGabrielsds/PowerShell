# Script Metodo de Detecção Mensal
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Passo a Passo
#Passo 01: Verifica se o Registro já existe, se não existir, irá cria-lo;
#Passo 02: Coleta a data atual da máquina;
#Passo 03: Compara a data atual com a data registrada;
#Passo 04: Verifica a necessidade de rodar ou não o script de limpeza;

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

$caminho_registro = "HKLM:\SOFTWARE\Script_Limpeza_Mensal"
$name_value = "Date"

#Coloca o valor no caminho criado no regedit
Set-ItemProperty -Path $caminho_registro -Name "Date" -Value "$actual_date"

#Para criar a pasta do regedit
New-Item -Path "HKLM:\Software\Script_Limpeza_Mensal"

#Verifica se o Registro existe, se não existir cria ele e adiciona a data ao registro
$teste_path = Test-path "HKLM:\Software\Script_Limpeza_Mensal"
If ($teste_path -eq $false) {
    Try {
    #Coloca o valor no caminho criado no regedit
    Set-ItemProperty -Path $caminho_registro -Name "Date" -Value "$actual_date"

    #Para criar a pasta do regedit
    New-Item -Path "HKLM:\Software\Script_Limpeza_Mensal"
        
    } Catch {
    
    
    }

} Else {
   
    
}

Try {

    $actual_date = Get-Date -format "yyyy/MM"
    Write-Host "O mês e ano atual é: $actual_date"
    $registry_date = Get-ItemProperty $caminho_registro | Select -Property $name_value
    Write-Host "A data registrada no Regedit é $registry_date"
    
} Catch {

    Write-Host "Não foi possível capturar a data atual do computador devido ao erro: $_"

}

If ($actual_date -eq $registry_date.Date) {

    Write-Host "Não sera necessário rodar o Script de limpeza!!"

} Else {

    Write-Host "A data registrada é diferente da data atual e o Script ainda não rodou este mês!"

}