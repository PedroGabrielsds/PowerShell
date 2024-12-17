#Exercicios ChatGPT v 3.0: 
#=================================================================
#Exercicio 15:
#Uso do processador

#cls

#$Continuidade = $true

#while ($Continuidade -eq $true) {
 #   $UsoCPU = (Get-WmiObject -Class Win32_Processor).LoadPercentage
  #  If($UsoCPU -lt 2){
   #     Write-Host "Uso do processador: $UsoCPU%" -ForegroundColor Red -BackgroundColor Black
    #} Else {
     #   Write-Host "Uso do processador: $UsoCPU%" -ForegroundColor Green -BackgroundColor Black
    #}
    #Start-Sleep -Seconds 5
    #$Resposta = Read-Host "Deseja continuar verificando o uso do processador? Sim/Não"
    #If ($Resposta -eq "Sim") {
     #   $Continuidade = $true
    
    #} Else {
     #   $Continuidade = $false
      #  cls
       # Write-Host "Verificação de uso da CPU concluída com sucesso!" -ForegroundColor Yellow -BackgroundColor Black
    #}
#}

#===================================================================
#Exercicio 16:
#Renomeando


#===================================================================
#Exercico 17:
#Criando CSV

#$LocalCsv = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Exercicios PowerShell ChatGPT'

#New-Item -Path $LocalCsv -Name "Banco_Dados.csv"

#$ArquivoCsv = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Exercicios PowerShell ChatGPT' + "\Banco_Dados.csv"

#cls

#Write-Host "|========================|" -ForegroundColor Yellow -BackgroundColor Black
#Write-Host "|    Banco de Dados      |" -ForegroundColor Yellow -BackgroundColor Black
#Write-Host "|========================|" -ForegroundColor Yellow -BackgroundColor Black

#$Resposta_2 = "Sim"

#While ($Resposta_2 -eq "Sim") {

#    $Resposta_2 = "Esperando"

#    $Email_Correto = '^[a-z0-9+]+@[a-z0-9.-]+\.[a-z]{2,}$'

#    $Dados = @()

 #   $Nome = Read-Host "Seu nome: "

 #   $Email = Read-Host "Seu E-mail: "

 #   If ($Email -match $Email_Correto) {

  #      $Dados += [PSCustomObject] @{
  #      Nome = $Nome 
  #      Email = $Email
   #     }
   #     Clear-Host
   # } Else {
    #    Write-Host "O e-mail digitado está incorreto! " -ForegroundColor Red -BackgroundColor Black

    #}

    #$Bem_Vindo = "Seja bem vindo, $Nome!"
   # ForEach ($Letra in $Bem_Vindo.ToCharArray()) {
     #   Write-Host $Letra -NoNewline -ForegroundColor Green
     #   Start-Sleep -Milliseconds 100

    #}

    #Write-Host
   # $Resposta = Read-Host "Exportar em um csv? Sim/Não"

    #If(($Resposta -eq "Sim") -or ($Resposta -eq "S")){
    
    #    Try {
        
    #        $Dados | Export-Csv -Path $ArquivoCsv -NoTypeInformation -Delimiter ";"
    #        Write-Host "Os dados foram exportados com sucesso! " -ForegroundColor Green -BackgroundColor Black

    #    } Catch {
    #        Write-Host "Erro ao exportar para o arquivo.csv" -ForegroundColor Red -BackgroundColor Black

     #   }

   # } Else {

    #    Write-Host "A operação foi cancelada!" -ForeGroundColor Red -BackGroundColor DarkBlue

    #}

   # $Resposta_2 = Read-Host "Deseja adicionar mais? Sim/Não"

#}

#$Agradecimento = "Operação finalizada com sucesso, obrigado por utilizar nosso script!"
#ForEach($Letrinha in $Agradecimento.ToCharArray()){
#    Write-Host $Letrinha -NoNewline -ForegroundColor White -BackgroundColor Black 
#    Start-Sleep -Milliseconds 25
#}


#=================================================================