#Exercicios ChatGPT v 3.0: 
#=================================================================
#Exercico 17: 
#Criando CSV

$arquivoCsv = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Exercicios PowerShell ChatGPT'

New-Item -Path $arquivoCsv -Name "Banco_Dados.csv"

cls

Write-Host "|========================|" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "|    Banco de Dados      |" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "|========================|" -ForegroundColor Yellow -BackgroundColor Black

$Email_Correto = '^[a-z0-9+]+@[a-z0-9.-]+\.[a-z]{2,}$'

$Dados = @()

$Nome = Read-Host "Seu nome: "

$Email = Read-Host "Seu E-mail: "

If ($Email -match $Email_Correto) {

    $Dados += [PSCustomObject] @{
    Nome = $Nome
    Email = $Email
    }
    Clear-Host
} Else {
    Write-Host "O e-mail digitado está incorreto! " -ForegroundColor Red -BackgroundColor Black


}

$Bem_Vindo = "Seja bem vindo, $Nome!"
ForEach ($Letra in $Bem_Vindo.ToCharArray()) {
    Write-Host $Letra -NoNewline -ForegroundColor Green
    Start-Sleep -Milliseconds 100

}

Write-Host
$Resposta = Read-Host "Exportar em um csv? Sim/Não"

If(($Resposta -eq "Sim") -or ($Resposta -eq "S")){
    
    Try {
        
        $Dados | Export-Csv -Path $arquivoCsv -NoTypeInformation -Delimiter ";" 

    } Catch {
        Write-Host "Erro ao exportar para o arquivo.csv"

    }
} Else {

    Write-Host "A operação foi cancelada!" -ForeGroundColor Red -BackGroundColor DarkBlue

}

#=================================================================