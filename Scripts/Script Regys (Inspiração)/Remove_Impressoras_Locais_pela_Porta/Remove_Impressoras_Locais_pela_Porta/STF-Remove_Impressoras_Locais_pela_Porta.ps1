<#
.SYNOPSIS

STF-Remove_Impressoras_Locais_pela_Porta - Este script remove da máquinas impressoras Locais instaladas de forma errada. 
O Script utiliza um array com nome de portas errados para saber quais impressoras remover. 

.DESCRIPTION

Descreva aqui o que o script faz. pode descre ver os passos e tudo que for importante saber.
Abaixo segue um exemplo de descrição:

- Este script serve como um modelo de scripts para ser utilizado na criação denovos scripts.
- O modelo utiliza uma biblioteca de funções para facilitar a criação de novos scripts. A biblioteca fica na pasta FUNCOES.
- O modelo é separado em partes, de forma a deixar o código organizado. 

O Modelo adiicona o arquivo de funcões STF-FuncoesComuns.ps1 que contém diversas funções comuns e úteis.

Este Modelo foi criado pela INMIC para utilização dentro do STF.

.AUTHORS

Regis Proença Picanço (regis.picanco)

.INPUTS

Se o script utilizar algum arquivo de ENTRADA, especifique aqui no comentário

.OUTPUTS

Se o script utilizar algum arquivo de SAÍDA, especifique aqui no comentário

.NOTES

Toda e qualquer alteração em PRODUÇÃO que o Script faça, deverá salvar o LOG das alterações no local apropriado na rede, para ficar disponível para auditoria.
Para Scripts que só fazem consulta e não fazem alteração, os Logs podem ser salvos localmente.
Em alguns casos, os Erros obtidos podem ser colocados em um log específico de erros e salvo na rede. 

.LINK

https://portal.stf.jus.br/
#>

begin {
  # Essa variável é usado no LOG pra ideintificar em que fase do Script foi gerado o Log
  [String]$FaseDoScript = 'Inicialização'

Clear-Host

$startScriptTime = (Get-Date).timeofday

## Define a política de execução do script para este processo
Try { Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop' } Catch {}

<#
╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   DECLARAÇÃO DE VARIÁVEIS  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧════════════════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 
- Todas as variáveis do script devem ser declaradas aqui.Dessa forma, 
  caso seja necessário alterar alguma variável, todas estarão juntas aqui.
- Como boa prática, declare o tipo da variável.                       #>
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▼                                                         ▼

[String]$envProgramFiles = [Environment]::GetFolderPath('ProgramFiles')
[String]$envComputerName = [Environment]::MachineName.ToUpper()

# Variáveis utilizadas pela função Write-Log para criar um arquivo de LOG
# compatível com o CMTRACE e salvar o logo na rede
$global:DataLog = (Get-Date).ToString("yyyy.MM.dd")
$global:configLogDir = "$envProgramFiles\STF_LOG"
$global:configLogName = "STF-$($envComputerName)-Remove_Impressoras_Locais_pela_Porta($($DataLog)).log"
#$global:configLogName = "STF-Remove_Impressoras_Locais_pela_Porta.log"
$global:configLogAppend = $true
$global:configLogMaxSize = 10
$global:configLogMaxHistory = 10
$global:configLogWriteToHost = $True
$global:configLogDebugMessage = $False
$global:configLogStyle = 'CMTrace'

## Variáveis de Ambiente 
# Nome do Script
$global:mainScript = $MyInvocation.MyCommand.Name
$global:mainScriptPath = $MyInvocation.MyCommand.Definition
$global:mainScriptRoot = Split-Path -Path $mainScriptPath -Parent
$global:mainScriptParent = Split-Path -Path $mainScriptRoot -Parent


# Variáveis específicas do script
$global:CaminhoLogRede = "\\arquivos\bds\ESTACOES\LOGS\Impressoras\Impressoras_Locais_Removidas"
$global:ArquivoLogRede = "STF-Impressoras_Locais_Removidas.log"
$global:CaminhoLogErro = "\\arquivos\bds\ESTACOES\LOGS\Impressoras\Impressoras_Locais_Removidas"
$global:ArquivoLogErro = "STF-Impressoras_Locais_ERRO.log"
$global:CaminhoLogAltRede = "\\ETI098145\STF_LOG"
# Array com os prefixos de portas de imrpessoras a serem removidas.
# Ex: "WSD-4" -> todas as impressoras locais cuja porta comece com "WSD-4" seráo removidas.
$PrefixosdePortas = @("WSD","imp","\\ETU0","//10.112.20.142","10..112.","10.8.","10.11","10.12","IP_10.10","IP_10.11","IP_10.12","X_10_122_41")
$ArquivodeControle = "STF-Remove_Impressoras_Locais_pela_Porta-v1.06.txt"

# ▲                                                         ▲ 
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

<#
╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤  ARQUIVO DE FUNÇÕES COMUNS  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═════════════════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 
- Todas as variáveis do script devem ser declaradas aqui.Dessa forma, 
  caso seja necessário alterar alguma variável, todas estarão juntas aqui.
- Como boa prática, declare o tipo da variável.                       #>
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▼                                                         ▼

# $ Arquivo de Funções que o Script usa
$global:functionsFile = "STF-Funcoes_20241108.ps1"

# Carrega o arquivo de Funções Comuns.
  If (Test-Path "$mainScriptRoot\$functionsFile") {
    . "$mainScriptRoot\$functionsFile"
  } 
# ▲                                                         ▲ 
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

<#
╔╤╤╤╤╤╤╤╤╤╤╤╤════════════════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
╟┼┼┼┼┼┼┼┼┼┼┼┤      FUNÇÕES ESPECÍFICAS DO SCRIPT     ├┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╚╧╧╧╧╧╧╧╧╧╧╧╧════════════════════════════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 
- Todas as funções específicas do script devem ser colocadas aqui.
- Crie funções PEQUENAS, que façam uma única coisa. 
- Funções devem ter entradas e saídas bem definidas.
- Registre em LOG as ações e erros nas funções
- Como boa prática, coloque sempre tratamento de erro nas funções (TRY-CATCH)   #>
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▼                                                         ▼

# Função para remover impressoras com portas que correspondem ao nome fornecido
function Remove-PrintersWithSpecificPort {
param (
    [string]$portNamePrefix  # Nome da porta ou prefixo a ser removido, como "WSD"
)

# Obtenha a lista de impressoras instaladas no sistema
$printers = Get-Printer

foreach ($printer in $printers) {
    # Verifique se o nome da porta da impressora começa com o prefixo especificado
    if ($printer.PortName -like "$portNamePrefix*") {
        # Caminho do Registro para a impressora
        $printerRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers\$($printer.Name)"
        
        # Remova a impressora do Registro
        if (Test-Path -Path $printerRegistryPath) {
           
          try {
            Remove-Item -Path $printerRegistryPath -Recurse -Force  
            Write-log -Message "Impressora [$($printer.Name)] | Porta [$($printer.PortName)] | Impressora Removida" -Severity 0
            Write-log -Message "$envComputerName | Impressora [$($printer.Name)] | Porta [$($printer.PortName)] | Impressora Removida" -LogFileDirectory $CaminhoLogRede -LogFileName $ArquivoLogRede -Severity 0
            Write-log -Message "$envComputerName | Impressora [$($printer.Name)] | Porta [$($printer.PortName)] | Impressora Removida" -LogFileDirectory $CaminhoLogAltRede -LogFileName $ArquivoLogRede -Severity 0
          }
          catch {
            <#Do this if a terminating exception happens#>
            Write-log -Message "Impressora [$($printer.Name)] | Porta [$($printer.PortName)] | ERRO ao tentar remover a impressora" -Severity 3
            Write-log -Message "$envComputerName | Impressora [$($printer.Name)] | Porta [$($printer.PortName)] | ERRO ao tentar remover a impressora" -LogFileDirectory $CaminhoLogErro -LogFileName $ArquivoLogErro -Severity 3
          }
          
        } else {
            Write-log -Message "Impressora [$($printer.Name)] | Impressora não encontrada no Registro." -Severity 2
        }
    } else {
        Write-log -Message "Impressora [$($printer.Name)] não utiliza porta com prefixo [$portNamePrefix]"
    }
}
}


# ▲                                                         ▲ 
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

Write-Log -Message "▼▼▼▼▼ ----------------  Inicio da Execução do Script  ---------------- ▼▼▼▼▼" -Severity 1
    
# Função para colocar no Log algumas informações úteis.
Inicializa-Log

[String]$FaseDoScript = 'Variáveis'
Write-Log -Message "Caminho [$ConfigLogDir]"
Write-Log -Message "Arquivo [$configLogName]"
Write-Log -Message "Caminho do Log [$CaminhoLogRede]"
Write-Log -Message "Arquivo de Log [$ArquivoLogRede]"
Write-Log -Message "Caminho do Log de Erro [$CaminhoLogErro]"
Write-Log -Message "Arquivo de Log de Erro [$ArquivoLogErro]"
ForEach ($prefixo in $PrefixosdePortas) {
    Write-Log -Message "Prefixo de Porta de impressora para remover [$($prefixo)*]"
}  





} # Fim do Begin

process {
  # Essa variável é usada no LOG pra ideintificar em que fase do Script foi gerado o Log
  [String]$FaseDoScript = 'Principal'

<#
╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤      CORPO DO SCRIPT       ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧════════════════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 
- Crie o corpo do script na forma de passos, de forma que a saída
  de um passo seja a entrada do próximo passo. 
- Documente os passos e informações importantes
- Registre em LOG as ações e erros nas funções
- Como boa prática, coloque sempre tratamento de erro nas funções (TRY-CATCH)   #>
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▼                                                         ▼

# Você pode usar a vairável $FaseDoScript para identificar no LOG a Fase ou ETAPA do seu Script. 
# Isso ajuda na hora de verificar o LOG pra entender o que o script fez. 
# Sempre que iniciar uma nota Fase ou Etapa no seu Script, configure essa variável.
# Exemplos: 
#           [String]$FaseDoScript = 'Etapa 01'
#           [String]$FaseDoScript = 'Etapa 02'
#           [String]$FaseDoScript = 'Consulta AD'
#           [String]$FaseDoScript = 'Compara Dados'
#           [String]$FaseDoScript = 'Correção AD'
#           [String]$FaseDoScript = 'Consulta Servidor'

# Apaga o arquivo de controle caso ele exista
$filePattern = "STF-Remove_Impressoras_Locais_pela_Porta-v*.txt"
# Verifica se existe algum arquivo que corresponde ao padrão
if (Test-Path -Path (Join-Path -Path $configLogDir -ChildPath $filePattern)) {
    Remove-File -Path "$configLogDir\$filePattern"
} 

ForEach ($prefixo in $PrefixosdePortas) {

# Chamada da função para remover impressoras com portas que começam com $prefixo
Remove-PrintersWithSpecificPort -portNamePrefix $prefixo

}  

# Reinicie o serviço de Spooler de Impressão para aplicar as mudanças
try {
  Restart-Service -Name "Spooler" -Force
  Write-Log -Message "Serviço de Spooler de Impressão reiniciado." -Severity 0
  
}
catch {
  Write-Log -Message "$envComputerName | ERRO - Não foi possível reiniciar o Serviço de Spooler de Impressão" -Severity 3
  Write-Log -Message "$envComputerName | $($_.Exception.Message) " -Severity 3
  Write-Log -Message "$envComputerName | ERRO - Não foi possível reiniciar o Serviço de Spooler de Impressão" -LogFileDirectory $CaminhoLogErro -LogFileName $ArquivoLogErro -Severity 3
  Write-Log -Message "$envComputerName | $($_.Exception.Message) " -LogFileDirectory $CaminhoLogErro -LogFileName $ArquivoLogErro -Severity 3
}

# Copia para o computador o arquivo de controle que serve para identificar os computadores em que o script já rodou.
Copy-File -Path "$mainScriptRoot\$ArquivodeControle" -Destination "$configLogDir"



# ▲                                                         ▲ 
# █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

} # Fim do Process (Corpo do Script)

end {
  # Essa variável é usada no LOG pra ideintificar em que fase do Script foi gerado o Log
  [String]$FaseDoScript = 'Finalização'

  $endScriptTime = (Get-Date).timeofday
    $duracao = $endScriptTime - $startScriptTime
    Write-Log -Message "Duração da Execução do Script: $($duracao.totalSeconds) segundo(s)" -Severity 1
    Write-Log -Message "▲▲▲▲▲ ----------------  Fim da Execução do Script  ---------------- ▲▲▲▲▲" -Severity 1
} # Fim do End

