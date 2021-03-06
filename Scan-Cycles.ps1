$target = $args[0]
if (! $target) {
$target = read-host "Vennligst skriv inn full FQDN til maskin."
}
If (Test-Connection $target -count 1 -ea SilentlyContinue) {
    write-debug "$target er oppe, fortsetter..."
    Write-Host "Kjører cycles mot $target..."
    $ms = New-Object system.management.managementscope
    $ms.path = "\\$target\root\ccm"
    $mc = New-Object System.Management.ManagementClass($ms,'sms_client',$null)
    $ErrorActionPreference = "Stop"
    Try {
    $mc.RequestMachinePolicy()|Out-Null
    Write-Host "Machine Policy Retrieval and Evaluation Cycle..... OK"
    $mc.TriggerSchedule("{00000000-0000-0000-0000-000000000113}")|Out-Null
    Write-Host "Software Updates Scan Cycle..... OK"
    Write-Host "Vennligst vent 5-10 min før cycles er ferdig kjørt og ny software/patcher vises på klient."
    }
    Catch {
    Write-Host "Noe gikk galt ved triggering av cycles, sjekk at du har nødvendige rettigheter mot $target"
    }
    }
    else {
        Write-Host "Oppnår ikke kontakt med $target, vennligst prøv igjen med riktig navn eller full FQDN."
        }