#Script de teste verificação maquinas
#===================================================================
#Seletores

$Caminho = '\\Arquivos\bds\TEMP\Test.csv'

$EstacoesSTF = @(
[PSCustomObject]@{  
	Filtro = "ETU[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"
},
[PSCustomObject]@{ 
	Filtro = "ETI[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=STI,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{  
	Filtro = "VM-MTT-DEV[01][01]" 
	OU = "OU=Especiais,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Filtro = "ETV[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=TV-Justica,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{  
    Filtro = "EV[IU][01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=Virtuais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{  
	Filtro = "NOT[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=Notebooks,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{  
	Filtro = "TER-XIBO-[01][0-9]"
	OU = "OU=Xibo,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"
},
[PSCustomObject]@{ 
	Filtro = "TER-BIBLIO-[01][0-9]" 
	OU = "OU=Terminal_Consulta_Biblioteca,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Filtro = "TER-FROTA-[01][0-9]"
	OU = "Transporte_STF-Frota,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"
})

$Dados_Saidas = @()

#----------------------------------------------------------------------
#Buscar dados AD ->

#Importando o modulo do AD
Import-Module ActiveDirectory

#Variavel que mostra onde o script vai procurar no AD
$OU = "OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"

$Computadores = @()

$ComputadoresAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN, DistinguishedName

ForEach ($Computador in $ComputadoresAD) {
    $OuPath = ($Computador.DistinguishedName -Split ',',2)[1]

    $Computadores += [PScustomObject] @{
        CN = $Computador.CN
        OU = $OuPath.Trim()
    
    }
}

#-------------------------------------------------------------------------------
#Inicio algoritmo

ForEach ($Maquina in $Computadores) {
    $Dentro_Padrao = $false
    $OUErrada = 0
   ForEach ($Padrao in $EstacoesSTF){  

        If($($Maquina.CN) -match $($Padrao.Filtro) -and ($($Maquina.OU) -eq $($Padrao.OU))){
            $NoPadrao = "$($Maquina.CN) - No padrão STF!"
            $Dentro_Padrao = $true
            #Write-Host $NoPadrao
            #Write-Host "=============================================="
            break
            
            #Add-content -Path $Caminho -Value $NomeCerto_OUErrada
            #Add-Content -Path $Caminho -value "-------------------------------"
             
        } Else{
            
            $Dentro_Padrao = $false

        }
   
        If ($($Maquina.CN) -match $($Padrao.Filtro) -and ($($Maquina.OU) -ne $($Padrao.OU))){
            $OUErrada = 1
            $NomeCerto_OUErrada = "$($Maquina.CN);$($Maquina.OU);Somente OU Incorreta"
            Add-Content -Path $Caminho -value $NomeCerto_OUErrada
            break  
        }           
    }
    If($Dentro_Padrao -eq $true){
        #Write-host $NoPadrao
        #Write-Host "=============================================="

    } ElseIf($OUErrada -eq 0) {
        Add-Content -Path $Caminho -Value "$($Maquina.CN);$($Maquina.OU);Fora Do Padrão"
       
    }
}

$Dados_Saidas | Export-Csv -Path $Caminho -NoTypeInformation -Delimiter ";"


#FimAlgoritmo
#==========================================================================================

#Condiçoes que foram testadas:

#------------------------------------------------------------------------------------
#Condição do Fora do padrao:
            #While($Erro -le 9){
             #   If($Erro -eq "9"){
              #      $ForaDoPadrao = "$($Maquina.CN) - Fora do padrão!"
               #     Write-Host $ForaDoPadrao
                #    Write-Host "=============================================="
                #}
            #}
#------------------------------------------------------------------------------------

                #$NomeCerto_OUErrada = "$($Maquina.cn) Somente OU Incorreta!"
                #Add-Content -Path $Caminho -Value $NomeCerto_OUErrada
                #Add-Content -Path $Caminho -value "-------------------------------"


                #$PadraoSTF = "$($Maquina.CN) No padrão STF!"
                #Add-Content -Path $Caminho -Value $PadraoSTF
                #Add-Content -Path $Caminho -value "----------------------------------"

#If ($($Maquina.CN) -notmatch $($Padrao.Filtro)){
             #$ForaDoPadrao = "$($Maquina.CN) - Fora do padrão!"
             #Add-content -path $Caminho -value $ForaDoPadrao
             #$PadraoEncontrado = $true
             
        #}


    #If ($($Maquina.CN) -match $($Padrao.Filtro) -and $($Maquina.OU) -ne $($Padrao.OU)) {
     #           $NomeCerto_OUErrada = "$($Maquina.cn) Somente OU Incorreta!"
      #          Add-Content -Path $Caminho -Value $NomeCerto_OUErrada
       #        $PadraoEncontrado = $true

       #$PadraoSTF = "$($Maquina.CN) No padrão STF!"
            #Add-Content -Path $Caminho -Value $PadraoSTF
            #Add-Content -Path $Caminho -value "----------------------------------"
            #$PadraoEncontrado = $true
            #break

            #If($($Maquina.CN) -notmatch $($Padrao.Filtro)) {
            #$ForaDoPadrao = "$($Maquina.CN) - Fora do padrão!"
            #Add-content -path $Caminho -value $ForaDoPadrao
            #Add-Content -Path $Caminho -value "-------------------------------"
            #$PadraoEncontrado = $true
            #break

        #}

        #If ($($Maquina.CN) -notmatch $($Padrao.Filtro)) {
         #   $ForaDoPadrao = "$($Maquina.CN) - Fora do padrão!"
          #  Write-Host $ForaDoPadrao
            #Add-content -path $Caminho -value $ForaDoPadrao
            #Add-Content -Path $Caminho -value "-------------------------------"
           
        #}
#==========================================================================================