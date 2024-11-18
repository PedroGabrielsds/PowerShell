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