# Caminho do arquivo de entrada com os patrimonios
$arquivoPatrimonios = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Maquinas Doação\Maquinas_Doacao.txt"

# Caminho dos arquivos de saída
$arquivoMaquinasEncontradas = "C:\caminho\para\maquinas_encontradas.txt"
$arquivoPatrimoniosNaoEncontrados = "C:\caminho\para\patrimonios_nao_encontrados.txt"

# Ler o arquivo de patrimonios
$patrimonios = Get-Content -Path $arquivoPatrimonios

# Inicializar listas para armazenar resultados
$maquinasEncontradas = @()
$patrimoniosNaoEncontrados = @()

# Loop pelos patrimonios
foreach ($patrimonio in $patrimonios) {
    # Buscar no AD as máquinas com o nome que contém o número do patrimônio
    $maquinas = Get-ADComputer -Filter "Name -like '*$patrimonio*'" -Properties Name

    if ($maquinas.Count -gt 0) {
        # Se encontrar máquinas, adicionar os nomes delas à lista de máquinas encontradas
        foreach ($maquina in $maquinas) {
            $maquinasEncontradas += $maquina.Name
            
        }
    } else {
        #Se não encontrar nenhuma máquina, adicionar o patrimônio à lista de patrimonios não encontrados
        $patrimoniosNaoEncontrados += $patrimonio
        
        
    }
}

# Salvar as máquinas encontradas em um arquivo de texto
$maquinasEncontradas | Out-File -FilePath $arquivoMaquinasEncontradas

# Salvar os patrimonios não encontrados em um arquivo de texto
$patrimoniosNaoEncontrados | Out-File -FilePath $arquivoPatrimoniosNaoEncontrados

Write-Host "Processo concluído."
Write-Host "Máquinas encontradas foram salvas em: $arquivoMaquinasEncontradas"
Write-Host "Patrimonios não encontrados foram salvos em: $arquivoPatrimoniosNaoEncontrados"
