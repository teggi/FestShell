$eventLogType = @("Application","System","Security")
$tekst = (Get-Content c:\hore.txt)
      foreach ($maskin in $tekst)
            {Write-Host $maskin
            Enter-PSSession -ComputerName Powershell
        foreach ($nummer in $eventLogType)
        {$regkey = "HKLM:\SYSTEM\CurrentControlSet\services\eventlog\$nummer"
        #$s = Get-ItemProperty -path $regkey -name Retention
        #Write-Host $s
        Set-ItemProperty -path $regkey -name Retention -value 0}}
        #$s = Get-ItemProperty -path $regkey -name Retention
        #Write-Host $s}}