#Exercicios ChatGPT
#==============================================================
#Exercicio 1: 

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

#==============================================================
#Exercicio 2: 
Get-ComputerInfo | Select-Object CsName, WindowsVersion, WindowsProductName





#==============================================================
