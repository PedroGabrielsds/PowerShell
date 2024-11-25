#Exercicios ChatGPT

#Exercicio 1:
#clear 
#$Comprimento = New-Object -ComObject WScript.shell

#$Comprimento.Popup("Olá PowerShell!")

"------------------------------------------------------"

#Exercicio 2:
#cls

#$Nome = Read-Host("Qual seu nome?")

#$BemVindo = ("Bem vindo ao PowerShell, $Nome!")

#$BemVindo 

#======================================================
#Exercicio 3:

#----------------------------------------------
#Inicio Algoritmo:

#$N1 = [Float](Read-Host "Digite o 1º número: ")
#$Operador = Read-Host "Qual operação deseja fazer: "
#$N2 = [Float](Read-Host "Digite o 2º número: ")
#If($Operador -eq "+"){
 #       $Resultado = $N1 + $N2
  #      $Msg = "$N1 + $N2 = $Resultado"
   #     Write-Host $Msg
    
    #} ElseIf($Operador -eq "-"){
     #   $Resultado = $N1 - $N2
      #  $Msg = "$N1 - $N2 = $Resultado"
       # Write-Host $Msg

    #} ElseIf(($Operador -eq "x") -or ($Operador -eq "*")){
     #   $Resultado = $N1 * $N2
      #  $Msg = "$N1 * $N2 = $Resultado"
       # Write-Host $Msg

    #} ElseIf($Operador -eq "%"){
     #   If($N2 -eq 0){
      #      Write-Host "Erro!"
       #     break

        #} Else{

        #$Resultado = $N1 / $N2
        #$Msg = "$N1 / $N2 = $Resultado"
        #Write-Host $Msg
        
        #}
   # }

#======================================================
#Exercicio 4:


  #Write-Host "Olá, seja bem vindo ao script da maior idade!"
  #[String]$Nome = Read-Host "Qual é o seu nome? "
  #Clear-Host
  #Write-Host "Seja muito bem vindo $($Nome)!"
  #Clear-Host
  #$Idade = Read-Host "Quantos anos você tem $($Nome)? "

  #If( $Idade -ge 18 ){

   # Write-Host "Parabéns $($Nome), você é maior de idade! 😎"

  #} Else {

   # Write-Host "Infelizmente você ainda não é maior de idade! 😢"

  #}
    

#========================================================
#Exercicio 5 (Contador):
#cls
#Write-Host "|=====================================|"
#Write-Host "|  Seja bem vindo ao contador Posh!   |"
#Write-Host "|=====================================|"

#[String]$Nome = Read-Host "Qual é o seu nome? "
#Clear-Host
#[int]$Numero_Usuario = Read-Host "Deseja contar até quanto $($Nome)? "
    
#[int]$Contador = 0 

#While($Contador -le $Numero_Usuario){
 #   Write-Host $Contador
  #  $Contador = $Contador + 1
   # Sleep -Seconds 1
#} 

#Sleep -Seconds 7
#cls

#Write-Host "|=====================================|"
#Write-Host "|  Obrigado por usar o contador Posh! |"
#Write-Host "|=====================================|"

#========================================================
#Exercicio 6 (Get-ChildItem): 

#$Caminho = Read-Host "Digite o caminho que desejar: "

#Try{
 #   Get-ChildItem -Path $Caminho -Recurse -Name

#}Catch {
 #   Write-Host "Erro: $($_.Exception.Message)"
#}

#========================================================
#Exercicio 7:
#$Caminho = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Teste exercicio 7"

#Write-Host "Seja bem vindo ao script de criação de arquivos!"

#Try{
 #   New-Item -Path $Caminho -Name "Exercicio 7 ChatGPT.txt" -ItemType File  -Value "Olá mundo... Estou fazendo os exercicios que chat GPT me passou para aprender PowerShell!"
 #}Catch{
  #  Write-Host "Erro ao criar o arquivo desejado!"
#}

#Start-Process -FilePath $Caminho 

#Sleep -Seconds 3

#Stop-Process -FilePath $Caminho 

#Sleep -Seconds 3

#Remove-Item -Path $Caminho 




 

    

    
