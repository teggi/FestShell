$a = (Get-Host).UI.RawUI
$a.BackGroundColor = "darkcyan"
$a.ForeGroundColor = "gray"
$a.WindowTitle = "FestShell"
$b = $a.WindowSize
$b.Height = 94
$a.WindowSize = $b
Import-Module ActiveDirectory
Import-Module ServerManager
cls