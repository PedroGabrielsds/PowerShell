#Script verificação de nomes das impressoras!

$ListaDeImpressoras = Get-Content "C:\temp\Nomes_Impressoras.txt"

$Padrao = "^IMP\d{6}$"

$Padrao2 = "^ETIQ\d{6}$"

#"^IMP\d{6}(-[A-Za-z0-9])$"


ForEach ($Impressoras in $ListaDeImpressoras){
    If($Impressoras -match $Padrao -or $Impressoras -match $Padrao2){

       $Script = "`n $Impressoras (Impressora dentro do Padrão!!)"
       Add-Content -Path "C:\Temp\Script.txt" -value $Script

    }Else{
       $Script2 = "`n $Impressoras (Impressora fora do Padrão!!)" 
       Add-Content -Path "C:\Temp\Script2.txt" -value $Script2
    }
}


