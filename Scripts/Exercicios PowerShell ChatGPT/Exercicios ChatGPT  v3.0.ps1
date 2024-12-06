#Exercicios ChatGPT v 3.0: 
#=================================================================
#Exercico 17: 
#Criando CSV

Function Coleta {
    Param($Nome, $Email)
    $Nome = Read-Host "Seu nome: "

    $Email = Read-Host "Seu E-mail: "

}

Write-Host "|========================|" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "|    Banco de Dados      |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "|========================|" -ForegroundColor Yellow -BackgroundColor Black

cls

$arquivoCsv = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Exercicios PowerShell ChatGPT\'

New-Item -Path $arquivoCsv -Name "Banco_Dados.csv"

$Dados = @()

$Dados += [PSCustomObject]@{
    Nome = $Nome
    Email = $Email
    
}

$Bem_Vindo = "Seja bem vindo, $Nome!"
ForEach ($Letra in $Bem_Vindo.ToCharArray()) {
    Write-Host $Letra -NoNewline -ForegroundColor Red
    Start-Sleep -Milliseconds 100

}

$Resposta = Read-Host "Para exportar em um csv digite (Sim) e (Não) para cancelar!"

Try {
    $Banco_Dados | Export-Csv -Path $arquivoCsv -NoTypeInformation -Delimiter ";"

} Catch {
    Write-Host "Erro ao exportar para o arquivo.csv"

}







#=================================================================