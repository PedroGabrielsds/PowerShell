<#
.SYNOPSIS

STF-Modelo_Script - Script para servir de modelopar a criação de outros scripts. 

ATENÇÃO: EDITE ESSES COMENTÁRIOS DE ACORDO COM O SEU SCRIPT

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
  
  ## Variáveis de Ambiente 
  # Nome do Script
  $global:mainScript = $MyInvocation.MyCommand.Name
  $global:mainScriptPath = $MyInvocation.MyCommand.Definition
  $global:mainScriptRoot = Split-Path -Path $mainScriptPath -Parent
  $global:mainScriptParent = Split-Path -Path $mainScriptRoot -Parent
  [String]$envProgramFiles = [Environment]::GetFolderPath('ProgramFiles')
  [String]$envComputerName = [Environment]::MachineName.ToUpper()

  # Variáveis utilizadas pela função Write-Log para criar um arquivo de LOG
  # compatível com o CMTRACE e salvar o logo na rede
  $global:DataLog = (Get-Date).ToString("yyyy.MM.dd-HH.mm.ss")
  $global:configLogDir = 'C:\Temp\LOGs'
  $global:configLogName = "STF-Modelo_Script-($DataLog).log"
  $global:configLogAppend = $true
  $global:configLogMaxSize = 10
  $global:configLogMaxHistory = 10
  $global:configLogWriteToHost = $True
  $global:configLogDebugMessage = $False
  $global:configLogStyle = 'CMTrace'
  
  
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
  
  
  
  # ▲                                                         ▲ 
  # █  . . . . . . . . . . . . . . . . . . . . . . . . . . .  █
  # ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
  
  Write-Log -Message "▼▼▼▼▼ ----------------  Inicio da Execução do Script  ---------------- ▼▼▼▼▼" -Severity 1
      
  # Função para colocar no Log algumas informações úteis.
  Inicializa-Log
  
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
  
  