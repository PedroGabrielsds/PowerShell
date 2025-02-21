#Script verificação de nomes das impressoras!

$ListaDeImpressoras = Get-Content 'C:\Temp\Nomes_Impressoras.txt'

$Padrao = '^(IMP|ETIQ)\d{6}(-\w+)?$'

WorkFlow Iniciar-Notas {

  Start-Process 'C:\Temp\Impressoras_Corretas.txt'
  Sleep 2
  Start-Process 'C:\Temp\Impressoras_Incorretas.txt'
}

ForEach ($Impressoras in $ListaDeImpressoras){
    Foreach ($teste in $Padrao){
        If($Impressoras -match $teste){
            $Script = "`n $Impressoras"
            Add-Content -Path "C:\Temp\Impressoras_Corretas.txt" -value $Script   
        }Else{
            $Script2 = "`n $Impressoras" 
            Add-Content -Path "C:\Temp\Impressoras_Incorretas.txt" -value $Script2
        }
    }
}
Iniciar-Notas



