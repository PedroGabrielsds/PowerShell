#Script Chatgpt ensinando a fazer log

# Função para registrar mensagens com diferentes níveis
function Write-Log {
    param(
        [string]$message,
        [string]$logLevel = "INFO"  # Valor padrão é INFO
    )
    
    # Criando a mensagem com data, hora e nível de log
    $message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - [$logLevel] - $message"
    
    # Escreve a mensagem no arquivo de log
    $message | Out-File -Append -FilePath "C:\Caminho\Para\Seu\log.txt"
}

# Exemplo de uso
Write-Log "Início da execução do script." -logLevel "INFO"
Write-Log "Tentando excluir o arquivo X." -logLevel "DEBUG"

# Caso o arquivo não exista, gerar um aviso
if (-not (Test-Path "C:\Caminho\Para\Arquivo.txt")) {
    Write-Log "Arquivo X não encontrado, mas o script continuará." -logLevel "WARNING"
}

# Simulando um erro crítico
try {
    # Simulando um erro
    throw "Erro crítico: Acesso negado ao arquivo."
} catch {
    Write-Log "Erro ao tentar acessar o arquivo. Detalhes: $_" -logLevel "ERROR"
}
