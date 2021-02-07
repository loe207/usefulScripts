#-Execute Pfad zu PowerShell
#-Argument Pfad zum Skript
$A = New-ScheduledTaskAction –Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe " -Argument "C:\pathToScript.ps1"

$T = New-ScheduledTaskTrigger -AtLogon
$P = New-ScheduledTaskPrincipal -UserId "xxx"
$S = New-ScheduledTaskSettingsSet
$D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
Register-ScheduledTask -TaskName "Suche in mehreren Ordnern"  -InputObject $D