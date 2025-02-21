#Script nome das máquinas

$Nomes = Get-Content "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script nomes das maquinas\Dados para teste.txt"

$EstacoesSTF = @(
[PSCustomObject]@{ 
	Nome = "Estacoes ETU"
	Filtro = "ETU[01][0-9][0-9][0-9][0-9][0-9]"
	OU = "OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Estacoes ETI" 
	Filtro = "ETI[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=STI,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Estacoes Especiais" 
	Filtro = "VM-MTT-DEV[01][01]" 
	OU = "OU=Especiais,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Estacoes TV Justica" 
	Filtro = "ETV[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=TV-Justica,OU=Estacoes,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Estacoes Virtuais" 
	Filtro = "EV[IU][01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=Virtuais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Notebooks" 
	Filtro = "NOT[01][0-9][0-9][0-9][0-9][0-9]" 
	OU = "OU=Notebooks,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Terminais Xibo" 
	Filtro = "TER-XIBO-[01][0-9]" 
	"OU=XIBO,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Terminais Biblioteca"
	Filtro = "TER-BIBLIO-[01][0-9]" 
	OU = "OU=Terminal_Consulta_Biblioteca,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
},
[PSCustomObject]@{ 
	Nome = "Terminais Transportes" 
	Filtro = "TER-FROTA-[01][0-9]" 
	OU = "Transporte_STF-Frota,OU=Terminais,OU=Microinformatica,OU=Maquinas,DC=rede,DC=stf,DC=gov,DC=br" 
})

#---------------------------------------------------------
#Inicio Script

ForEach($Maquina in $Nomes){
    ForEach($Estacao in $EstacoesSTF){
        If($Maquina -match $Estacao){
            
        }Else{
            Add-Content -Path "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Script nomes das maquinas\Novo(a) Documento de Texto.txt" -Value $Maquina
        }
    }
}