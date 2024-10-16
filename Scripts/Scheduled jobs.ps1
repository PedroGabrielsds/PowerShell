#Scheduled-Jobs

Clear-Host

Get-Command - Module PSScheduledjob | Sort-Object Noun

$Diario = New-JobTrigger -Daily -At 2pm
$Umavez = New-JobTrigger -Once -At (Get-Date).AddHours(1)
$Semanal = New-JobTrigger -Weekly -DaysOfWeek Monday -At 6pm

Register-ScheduledJob -Name Backup -Trigger $Diario -ScriptBlock{
    Copy-Item C:\Scripts -Recurse -Force
}

Get-ScheduledJob