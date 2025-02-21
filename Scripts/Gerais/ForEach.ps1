#Exemplo FOREACH
cls
#foreach ($numeros in 1,2,3,4,5,6,7,8){
 #   echo $numeros
#}
foreach ($Arquivos in Get-ChildItem){
    If ($Arquivos.FullName){
        Write-Host $Arquivos.FullName
    }
}
