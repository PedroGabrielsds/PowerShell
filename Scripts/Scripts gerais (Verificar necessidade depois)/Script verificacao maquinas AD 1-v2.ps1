#Script nome das maquinas
#============================================================================

# Variaveis

$Arquivo = 'D:\Temp\Maquinas_incorretas.txt'

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
},
[PSCustomObject]@{
    Filtro = @('ETU[01][0-9][0-9][0-9][0-9][0-9]' -or 'ETI[01][0-9][0-9][0-9][0-9][0-9]' -or 'NOT[01][0-9][0-9][0-9][0-9][0-9]')
    OU = "OU=WHfB,OU=STI,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"
})


#=============================================================================
#Puxar dados do Active Directory:

# Define a OU onde serão buscados os computadores
$OU = "OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br"


# Importa o módulo do Active Directory
Import-Module ActiveDirectory

# Cria um array vazio para armazenar os objetos PSCustomObject
$Computadores = @()

# Obtém todos os computadores do Active Directory dentro da OU especificada
$computadoresAD = Get-ADComputer -Filter * -SearchBase $OU -Properties CN, DistinguishedName

# Para cada computador obtido, cria um PSCustomObject com os atributos CN e OU e adiciona ao array
foreach ($computador in $computadoresAD) {

    # Remove o primeiro elemento (CN=...) e mantém o restante como a OU
    $ouPath = ($computador.DistinguishedName -split ',', 2)[1]

    $Computadores += [PSCustomObject]@{
        cn = $computador.CN
        OU = $ouPath.Trim()
    }
}

#==============================================================================
#Inicio do algoritmo 

clear-host


ForEach ($computador in $Computadores) {

    ForEach ($padrao in $EstacoesSTF){

        #Write-host "Nome   = $($computador.cn)"
        #Write-host "Filtro = $($padrao.Filtro)"

        If ($computador.cn -match $padrao.Filtro) {

            $mensagem = $computador.cn + " Nome CORRETO!"
            # Add-Content -Path $Arquivo -Value $Fpadrao
            Write-Host $mensagem
            $NomeErrado = 0

        } Else {
            $mensagem = $computador.cn + " Nome ERRADO!"
            # Add-Content -Path $Arquivo -Value $Fpadrao
            Write-Host $mensagem

            $NomeErrado = 1 
        }

        If ($NomeErrado -eq 0 ) {
                
            #Write-host "OU        = $($computador.OU)"
            #Write-host "OU padrao = $($padrao.OUPadrao)"
            If($computador.OU -eq $padrao.OU) {

                $mensagem = $computador.OU + " OU CORRETA!"
                #Add-Content -Path $Arquivo -Value $OUFpadrao
                Write-Host $mensagem


            } Else {

                $Saida = " Nome [$($computador.cn)] CORRETO e OU [$($computador.OU)] ERRADA!"
                #Add-Content -Path $Arquivo -Value  $Saida
                Write-Host $Saida
                
                
            }

        } #Fim do IF

        # Se Erro = 0 -> Nome e OU corretas
        # Se Erro = 1 -> Ou o Nome está errado ou a OU está errada (1 dos 2 está errado)
        # Se Erro = 2 -> Nome e OU errada.

        
        If ($NomeErrado -eq 0) { 
            break 
        } 
        Write-Host "........."
        
    }
    if ($NomeErrado -gt 0) {
        
            $Saida = "[$($computador.cn)] ou [$($computador.OU)] -> ERRADO(S)!"
            
            Add-Content -Path $Arquivo -Value  $Saida
        
    }
    Write-Host "----------------------------"


}


