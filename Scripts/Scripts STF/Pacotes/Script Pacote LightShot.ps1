#Script que exclui a tarefa agendada do LightShot!
#===========================================================
#Variaveis: 

#|-------------------------------------Passos-Script------------------------------------------|
#|                                                                                            |
#|  1º Passo: Verificar se a tarefa "Updater" do lightShot existe, se exister, remove-la;     |
#|  2º Passo: (Pós desinstalação) excluir os registros referentes à tarefa agendada;          |
#|                                                                                            |
#|--------------------------------------------------------------------------------------------| 

#===========================================================
#InicioScript

#Passo 01 - Verificando a existência da tarefa agendada:

$Tarefas_Agendadas = Get-ScheduledTaskInfo

If ($Tarefas_Agendadas.Count -gt 0) {
    
    $Tarefa_LightShot = $Tarefas_Agendadas | Where-Object {$_.Command -like "*Skillbrains*"}

    If ($Tarefa_LightShot.Count -gt 0) {

        Write-Host "Tarefas agendadas do LightShot encontradas!" -BackgroundColor Black -ForegroundColor Green

        Try {

            Unregister-scheduledtask -taskname $Tarefa_LightShot.name -Confirm:$false 
            Write-Host "Tarefas agendadas do LightShot excluida com sucesso!" -BackgroundColor Black -ForegroundColor Green
         
        } Catch {

            Write-Host "Não foi possivel excluir a tarefa agendada do LightShot" -BackgroundColor Black -ForegroundColor Red

        }
    }

} Else {

    Write-Host "Não foi possivel coletar as informações de tarefas agendadas" -BackgroundColor Black -ForegroundColor Red

}

#Passo 02 - Excluindo registros e arquivos da tarefa agendada (Pós desinstalação): 

$Caminho_Regedit_LightShot = "HKLM:HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Skillbrains"

If (test-path $Caminho_Regedit_LightShot) {
    
    Write-Host "Registros encontrados com sucesso!" -BackgroundColor Black -ForegroundColor Green
    Try {

        Remove-Item -Path $Caminho_Regedit_LightShot -Recurse -Confirm:$false  
        Write-Host "Registros do LightShot excluidos com sucesso!" -BackgroundColor Black -ForegroundColor Green

    } Catch {
        
        Write-Host "Não foi possivel excluir os registros do LightShot" -BackgroundColor Black -ForegroundColor Red   

    }
} Else {

    Write-Host "O caminho especificado não foi encontrado no Editor de registro!"

}


#FimScript
#===========================================================