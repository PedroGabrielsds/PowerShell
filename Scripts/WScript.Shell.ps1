#WScript.Shell

$wshell = New-Object -ComObject WScript.shell

$wshell | Get-Member

$Wshell.Popup("Esse curso eh muito legal")

$wshell.Run("Notepad")
$wshell.AppActivate("Notepad")
Start-Sleep 1
$wshell.SendKeys("Esse curso é muito legal")