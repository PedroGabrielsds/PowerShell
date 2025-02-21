#Script que usa Array
clear-Host
$GoogleDns = @("8.8.8.8", "8.8.4.4")
$TotalDns = $GoogleDns.Count
Write-Host Pingando todos os $TotalDns DNS do goolge
Test-Connection $GoogleDns -Count 1
sleep 3
Write-Host Fim!!