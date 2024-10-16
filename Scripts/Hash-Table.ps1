#Script que usa Hash-Table
clear-host
$Servidores = [ordered] @{Server1="127.0.0.1"; Server2="127.0.0.2"; Server3="127.0.0.3"}

$Servidores

#Adicionar
$Servidores["Server4"]="127.0.0.4"

#Remover
$Servidores.Remove("Server4")

Test-Connection $Servidores.Server1

#Exibir os valores
$Servidores.Values






