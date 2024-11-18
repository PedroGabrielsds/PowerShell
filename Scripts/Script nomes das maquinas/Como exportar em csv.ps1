# Definir o nome do arquivo CSV
$arquivoCsv = '\\Arquivos\bds\TEMP\Test.csv'

# Criar uma lista para armazenar os dados
$dados = @()

# Loop para coletar dados
do {
    # Solicitar nome
    $nome = Read-Host "Digite o nome (ou 'sair' para terminar)"
    
    # Se o usuário digitar 'sair', interrompe o loop
    if ($nome -eq "sair") {
        break
    }

    # Solicitar idade
    $idade = Read-Host "Digite a idade de $nome"
    
    # Verificar se a idade é maior que 18
    $maiorDeIdade = if ($idade -gt 18) { "Sim" } else { "Não" }

    # Criar um objeto com os dados e adicionar à lista
    $dados += [PSCustomObject]@{
        Nome           = $nome
        Idade          = $idade
        MaiorDeIdade   = $maiorDeIdade
    }
} while ($true)

# Exportar os dados para o arquivo CSV com delimitador ";"
$dados | Export-Csv -Path $arquivoCsv -NoTypeInformation -Delimiter ";"

# Exibir mensagem de confirmação
Write-Host "Dados salvos com sucesso em $arquivoCsv"