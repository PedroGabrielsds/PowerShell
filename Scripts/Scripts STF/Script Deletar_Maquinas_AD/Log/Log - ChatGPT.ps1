$LogFile = "C:\Users\g311011\Desktop\Pedro Gabriel Silva dos Santos\PowerShell\Scripts\Scripts STF\Script Deletar_Maquinas_AD\Log\Log-Teste.log"
 
Function Write-Log {
    Param(
        [String]$Message
    )
    Try {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
        $Message | Out-File -Append -FilePath $LogFile -Encoding UTF8 -ErrorAction Stop
    }
    Catch {
        Write-Host "Erro ao gravar no log: $_"
    }
}
 
Write-Log -Message "O script começou a rodar..."
Write-Log -Message "Finalizando execução."