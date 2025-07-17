#Script para desinstalar versões a mais do 7.zip

#Passos do script
#1º Passo: Busca por aplicações instaladas com o nome de 7-Zip
#2º Passo: Adiciona o nome, versão e o product code dos aplicativos selecionados anteriormente em um objeto
#3º Passo: Desinstala o 7-Zip com a versão mais antiga e mantém a versão atual

$qtd_7zip = @()

#Passo 1:
$7zips = (Get-ADTApplication -name '7-zip')

If(-not $7zips) {
    Write-host "Não foi possível localizar nenhum programa 7-zip! Erro: $_"
    
} Else {
    #Passo 2:
    ForEach($7zip in $7zips){
	    $qtd_7zip += [PSCustomObject] @{
            Name =  $7zip.DisplayName
            versao = $7zip.DisplayVersion
		    codigo_produto = $7zip.ProductCode
	    }
    }
     
    #Passo 3:
    If ($qtd_7zip.Count -ge 2) {
	    ForEach($7zip in $qtd_7zip){
            If ($($7zip.versao) -lt '24.09.00.0') {
                $7zip_Uninstall = $7zip.codigo_produto
                try{
                    Uninstall-ADTApplication -Name "7-zip" -ProductCode $7zip_Uninstall
                    write-host "Desinstalado com sucesso"
                }Catch{
                    write-host "Erro ao desinstalar, saide de erro $_"                
                }
            }
        }
    }
}
