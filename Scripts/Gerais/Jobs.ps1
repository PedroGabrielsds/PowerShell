WorkFlow WorkFlowDemorado
{
    While(1){
        (Get-Date).ToString() + "Script Demoradinho"
        Start-Sleep -Seconds 2
    }
}

$WFJob = WorkFlowDemorado -AsJob
$WFJob

Start-Job $WFJob
Receive-Job $WFJob
Suspend-Job $WFJob -Force
Stop-Job $WFJob
Resume-Job $WFJob