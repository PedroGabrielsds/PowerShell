#Exercicios ChatGPT
#========================================================================================================
#Exercicio 8: 

#$Endereço = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Exercicios PowerShell ChatGPT\Resultado_Ex1.txt'

#Get-Process

#Function Pesquisa_Processo {
 #   Param(
  #      [String]$Msg = "Qual processo deseja saber? "
   # )  
    #$Palavra = Read-Host -Prompt $Msg
    #return $Palavra
    
#}

#$Palavra = Pesquisa_Processo
#$Resultado = Get-Process | Where-Object{$_.Name -like "*$Palavra*"}

#If ($Resultado) {
    
 #   Add-Content -Path $Endereço -Value $Resultado
  #  Write-Host "Processo registrado com sucesso!!"

#} Else {
   
 #   Write-Host "O processo digitado não existe!!"
  #  Pesquisa_Processo
#}

#========================================================================================================
#Exercicio 9: 

#$Info_Computador = Get-ComputerInfo |Select-Object CsName, WindowsProductName, WindowsVersion

#$Espaco = (Get-Volume -DriveLetter C | Select-Object @{Name="Espaco_Disponivel"; Expression={[Math]::Round($_.SizeRemaining / 1GB, 2)}}).Espaco_Disponivel

#$Resultado = @{

 #   "Nome do computador: "             = $Info_Computador.CsName

  #  "Versão do S.O: "  = $Info_Computador.WindowsVersion

   # "Espaço disponivel em C: "         = "$Espaco GB"

#}

#$Resultado

#=========================================================================================================
#Exercicio 10:
#Par ou Impar

#cls
#Write-Host "|======================================|" -ForegroundColor Blue
#Write-Host "|Desculbra se o número é Par ou Ímpar! |"
#Write-Host "|======================================|" -ForegroundColor Blue

#$Resposta = "Sim"

#While($Resposta -eq "Sim") {
 #   $Numero = Read-Host "Digite um número: "

 #   If ($Numero % 2 -eq 0) {
        
 #       Cls
 #       Write-Host "|======================================|" -ForegroundColor Green
  #      Write-Host "|      O número $Numero é Par!         |" -ForegroundColor Yellow
  #      Write-Host "|======================================|" -ForegroundColor Green

   # } Else {
        
   #     cls
    #    Write-Host "|======================================|" -ForegroundColor Green
    #    Write-Host "|      O número $Numero é Ímpar!       |" -ForegroundColor Red
    #    Write-Host "|======================================|" -ForegroundColor Green

   # }

   # $Resposta = Read-Host "Deseja testar novamente? "
#}


#Sleep -Seconds 3
#cls
#Write-Host "|======================================|" -ForegroundColor Green
#Write-Host "|  Obrigado por usar o Par ou Ímpar!   |" -ForegroundColor Magenta
#Write-Host "|======================================|" -ForegroundColor Green



#=========================================================================================================
#Exercicio 10:
#Criando Arquivo

#$Nome = Read-Host "Qual é o seu nome? "

#$Nome_Arquivo = Read-Host "Qual deseja que seja o nome do arquivo? "

#$Caminho = 'C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Exercicios PowerShell ChatGPT\Exercicio 10 - criando arquivos'

#$Endereco = $Caminho + "\$Nome_Arquivo.txt"


#If( $Nome_Arquivo -eq $null ) {

  #  Write-Host "O nome do arquivo está vazio ou nulo!" -ForegroundColor Black -BackgroundColor Red

#} Else {
 #   If(Test-Path $Endereco){

 #       Write-Host "O arquivo já existe" -ForegroundColor Black -BackgroundColor Red
    
  #  } Else {
  #      Write-Host "O arquivo está sendo criado...."
  #      Sleep -Seconds 2 
   #     New-Item -Path $Endereco -ItemType File
   #     Write-Host "O arquivo $Nome_Arquivo foi criado por $Nome!" -ForegroundColor White -BackgroundColor Green
   #     Start-Process $Endereco
    
   # }   
#}

#==========================================================================================================
#Exercicio 11: 
#Contando
#cls

#$Numero_Inicial = Read-Host "Deseja contar de quanto? "

#$Numero_Final = Read-Host "Até quanto? "

#If($Numero_Inicial -eq $Numero_Final ) {
 #   Write-Host "Não dá pra contar assim :( " -ForegroundColor Black -BackgroundColor Red

#} Else {

 #   If($Numero_Inicial -LT $Numero_Final ){

 #       [int]$Contador = $Numero_Inicial
 #       While($Contador -LE $Numero_Final){
 #           Sleep -Seconds 1
 #           Write-Host $Contador -ForegroundColor White
 #           $Contador = $Contador + 1
        
  #      }
  #      Write-Host "Terminei de contar :)" -ForegroundColor Green -BackgroundColor Black

  #  } Else {

  #      [int]$Contador = $Numero_Inicial
  #      While ($Contador -GE $Numero_Final) {
  #          Sleep -Seconds 1
  #          Write-Host $Contador -ForegroundColor White
  #          $Contador = $Contador - 1
        
  #      }
  #      Write-Host "Terminei de contar :)" -ForegroundColor Green -BackgroundColor Black
  #  }
#}

#==========================================================================================================
#Exercicio 12:
#Procurando arquivos
#cls
#Write-Host "|=========================|" -ForegroundColor Yellow -BackgroundColor Black
#Write-Host "|  Bem vindo ao Get-File! |" -ForegroundColor Yellow -BackgroundColor Black
#Write-Host "|=========================|" -ForegroundColor Yellow -BackgroundColor Black

#cls

#$Arquivo = Read-Host "Qual arquivo deseja consultar? "

#$Tipo_Arquivo = Read-Host "De qual tipo é o arquivo? Ex:(.txt .pdf .csv)"

#$Diretorio = Read-Host "Onde procuro por este arquivo? "

#$Endereco = $Diretorio + "\" + $Arquivo + $Tipo_Arquivo

#If(Test-Path $Endereco){
#    Write-Host "O arquivo $Arquivo foi localizado com sucesso!" -ForegroundColor Green -BackgroundColor DarkGreen
#    $Resp = Read-Host "Deseja executa-lo? Sim/Não"
#    If($Resp -eq "Sim"){
 #       cls
  #      Write-Host "Inicializando" -ForegroundColor Green -BackgroundColor Black -NoNewline
  #      $Ponto = 1
  #      While($Ponto -Lt 5){
  #          Sleep -Seconds 1
  #          Write-Host "." -ForegroundColor Green -BackgroundColor Black -NoNewline 
  #          $Ponto = $Ponto + 1
  #      }
  #      Start-Process $Endereco

  #  }Else {

  #      Write-Host "O arquivo foi localizado com sucesso e está a sua disposição! " -ForegroundColor White -BackgroundColor Green
    
  #  }

#} Else {

#    Write-Host "O DIRETORIO NÃO EXISTE!" -ForegroundColor Red -BackgroundColor DarkRed

#}

#==========================================================================================================
#Exercicio 13
#Movendo arquivos

#cls

#$Diretorio_Antigo = Read-Host "Em qual diretorio está o arquivo? "

#$Arquivo = Read-Host "Qual arquivo deseja copiar? "

#$Tipo_Arquivo = Read-Host "Qual é o tipo do arquivo? (Ex: .txt, .csv...)"

#$Diretorio_Novo = Read-Host "Para qual diretorio deseja coloca-lo? "

#$Nome_Arquivo = $Arquivo + $Tipo_Arquivo

#$Endereco_Copia = $Diretorio_Antigo + "\" + $Nome_Arquivo

#$Endereco_Cola = $Diretorio_Novo

#If (Test-Path $Endereco_Copia ) {

    #Write-Host "O endereço digitado existe!" -ForegroundColor White -BackgroundColor Black
   # Write-Host "Copiando arquivo" -NoNewline -ForegroundColor Green -BackgroundColor DarkGreen
   # [int]$Contador = 1
   # While ($Contador -LE 4) {
    #    Write-Host "." -NoNewline -ForegroundColor Green -BackgroundColor DarkGreen
    #    $Contador = $Contador + 1
    #    Sleep -Seconds 1
   # }

#} Else {
    
   # Write-Host "O endereço não existe!" -ForegroundColor DarkRed -BackgroundColor White

#}    

#$Erro = 0

#If (Test-Path $Endereco_Cola) {
    #$Resp = Read-Host ´n "O endereço em que deseja colar o arquivo existe, deseja colar agora mesmo? (Sim/Não)"
   # If ($Resp -eq "Sim") {
        
     #   Copy-Item -Path $Endereco_Copia -Destination $Endereco_Cola -Confirm
     #   Sleep -Seconds 1
    #    Start-Process -FilePath $Endereco_Cola

  #  } Else {
  #      [int]$Erro = 1
  #      Write-Host "Obrigado por usar o Scrip Cloning-Files!" -ForegroundColor Yellow -BackgroundColor Black
    
  #  }

#} Else {
 #   Write-Host "O endereço não existe!" -ForegroundColor Red -BackgroundColor DarkRed

#}

#If ($Erro -eq 1) { 
 #   $Erro = 0

#} Else {
   # cls
   # Write-Host "|==========================================|"  -ForegroundColor Yellow -BackgroundColor Black
   # Sleep -Seconds 1
   # $Frase =  "| Obrigado por usar o Scrip Cloning-Files! |"
   # ForEach ( $Letra in $Frase.ToCharArray() ) {
    #    Write-Host -NoNewline $Letra -ForegroundColor Yellow -BackgroundColor Black
    #    Start-Sleep -Milliseconds 50
   # }

  #  Write-Host
  #  Write-Host "|==========================================|" -ForegroundColor Yellow -BackgroundColor Black

#}

#==========================================================================================================
#Exercicio 14:

#cls

#$Recepcao = "Bem vindo aos Processos do seu computador!"
#ForEach ($Letra in $Recepcao.ToCharArray()) {
#    Write-Host $Letra -NoNewline -ForegroundColor Yellow -BackgroundColor Black
#    Start-Sleep -Milliseconds 100 
#} 

#Get-Process

#$Resposta = Read-Host "Deseja finalizar algum processo? Sim/Não "

#If ( $Resposta -eq "Sim" ){
#    [String]$Processo = Read-Host "Qual processo deseja finalizar? "
#  Try {

 #       Stop-Process -Name $($Processo)
 #       Write-Host "O processo foi finalizado com sucesso..." -ForegroundColor Green -BackgroundColor Black

 #   } Catch {
 #       Write-Host "Error $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor DarkRed
    
 #   }
    
#} Else {

 #   Write-Host "Não foi selecionado nenhum processo para finzalizar! " -ForegroundColor DarkRed -BackgroundColor White   

#}

#Write-Host "Obrigado por usar o script Finish-Process : ) " -ForegroundColor Blue -BackGroundColor Black


















#--------------------------------------------------------------------------------------------------------
#Comandos de buscar informações do computador:

#Get-ComputerInfo | Select-Object CsName, WindowsVersion, WindowsProductName

#Get-PSDrive

#Get-WmiObject -Class Win32_Processor

#--------------------------------------------------------------------------------------------------------
#Metodos de buscar informações de armazenamento:

#Get-PhysicalDisk

#Get-Partition

#Get-Disk |

#Get-Volume | Select-Object @{Name="Espaço_Livre"; Expression={[Math]::Round($_.SizeRemaining / 1GB, 2)}}, @{Name="Espaço"; Expression={[Math]::Round($_.Size / 1GB, 3)}}

#Get-Disk | Select-Object FriendlyName, @{Name="SizeGB"; Expression={[math]::round($_.Size / 1GB, 2)}}

#--------------------------------------------------------------------------------------------------------


#----------------------------------------
#Expressão de arredondamento
#[Math]::Round(1.4)
#----------------------------------------


