
#-------------------------------------------------------------------------------
#Inicio do algoritmo 

clear-host


ForEach ($computador in $Computadores) {


    ForEach ($padrao in $PadraoSTF){

        Write-host "Nome   = $($computador.cn)"
        Write-host "Filtro = $($padrao.Filtro)"

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
                
            Write-host "OU        = $($computador.OU)"
            Write-host "OU padrao = $($padrao.OUPadrao)"
            If($computador.OU -eq $padrao.OUPadrao) {

                $mensagem = $computador.OU + " OU CORRETA!"
                # Add-Content -Path $Arquivo -Value $OUFpadrao
                Write-Host $mensagem


            } Else {

                $Saida = " Nome [$($computador.cn)] CORRETO e OU [$($computador.OU)] ERRADA!"
                Add-Content -Path $Arquivo -Value  $Saida
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