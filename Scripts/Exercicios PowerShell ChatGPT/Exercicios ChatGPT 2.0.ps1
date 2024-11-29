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


