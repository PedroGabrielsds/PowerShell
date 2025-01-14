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