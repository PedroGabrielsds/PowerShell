#Script de teste verificação maquinas
#===================================================================
#Seletores

$DadosTeste = @(
[PSCustomObject] @{ 
	CN = "ETU012345"
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "NOT012345" 
	OU = "OU=STI,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ET223344" 
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ET09876" 
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ETU0098145"
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ETI098132" 
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "NOT098765" 
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "NOTE98123" 
	OU = "OU=Notebooks,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "TER-BIBLIO-12" 
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "TER-BIBLIO-08" 
	OU = "OU=Terminal_Consulta_Biblioteca,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "EVU00a234" 
	OU = "OU=Virtuais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "EVU000123" 
	OU = "OU=Virtuais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "EVI000342" 
	OU = "OU=Virtuais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ETV012312"
	OU = "OU=TV-Justica,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ETU076352" 
	OU = "OU=TV-Justica,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject] @{ 
	CN = "ETI000" 
	OU = "OU=Notebooks,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
})

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
	Filtro = 'TER-FROTA-[01][0-9]'
	OU = "Transporte_STF-Frota,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
})

$Caminho = '\\Arquivos\bds\TEMP\Maquinas incorretas.txt'

#===================================================================
#Inicio Script

ForEach ($Maquina in $DadosTeste) { 
   ForEach ($Padrao in $EstacoesSTF){  

        If($($Maquina.CN) -match $($Padrao.Filtro) -and ($($Maquina.OU) -eq $($Padrao.OU))){
            $NoPadrao = "$($Maquina.CN) - No padrão STF!"
            Write-Host $NoPadrao
            Write-Host "=============================================="
            break
            
            #Add-content -Path $Caminho -Value $NomeCerto_OUErrada
            #Add-Content -Path $Caminho -value "-------------------------------"
             
        } Else{
            Write-Host "Fora do Padrão!"
  
        }
   
        If ($($Maquina.CN) -match $($Padrao.Filtro) -and ($($Maquina.OU) -ne $($Padrao.OU))){ 
            $NomeCerto_OUErrada = "$($Maquina.cn) - Somente OU Incorreta!"
            Write-Host $NomeCerto_OUErrada
            #Add-Content -Path $Caminho -Value $NomeCerto_OUErrada
            #Add-Content -Path $Caminho -value "-------------------------------"
            Write-Host "=============================================="
            break 
            
        }
                    
    }
            
}
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