$compname = $args[0]
$scriptname = $args[1]
if (! $compname) {
$compname = read-host "Vennligst skriv inn full FQDN til maskin."
}
if (! $scriptname) {
$scriptname = read-host "Vennligst skriv inn path til script med filendelse."
}
write-debug "Script: $scriptname Maskin: $compname"
If (Test-Connection $compname -count 1 -ea SilentlyContinue) {
    write-debug "Kjører $scriptname på $compname"
    Invoke-Command -computername $compname -filepath $scriptname
    write-debug Ferdig!
    }
    else {
        Write-Host "Oppnår ikke kontakt med $compname, vennligst prøv igjen med riktig navn eller full FQDN."
        Write-Host "Feilkilder kan være manglende remoting enablet (kjør isåfall 'winrm quickconfig -q' på $compname), eller problemer med link."
        }