#Exemplo do While

#Variaveis:
$i = 0
While($True){
    $i++
    Write-Host "Vou contar até $i"
    If($i -eq 1000){
        Write-Host "Contei até mil"
        break
   }
}