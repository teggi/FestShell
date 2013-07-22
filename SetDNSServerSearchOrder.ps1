#################################################################################
### Opprettet av Marius Koch, Steria
### SetDNSServerSearchOrder
### Benyttes for å sette DNSServerSearchOrder (DNS-servere) remote via WMI.
### Scriptet er skrevet med følgende antakelser: Server er medlem av domenet, kjørende bruker har administratorrettigheter, og har ikke tilgang på Active Directory-modul for kjøring av Get-ADComputer (evt kjøres dette på annen server for å produsere *:\servers.txt)
#################################################################################

$dnsArray = @("127.0.0.1","127.0.0.1") # Array med DNS-servere, satt i ønsket rekkefølge
$computers = "Get-Content c:\servers.txt"

foreach ($computer in $computers) {
$wmiPath = Get-WmiObject -namespace root\cimv2 -class Win32_NetworkAdapterConfiguration -computer $computer | where{$_.IPAddress -like "10*"} # Henter nettverkskort basert på om IP-adressen begynner på 10.
$wmiPath.SetDNSServerSearchOrder($dnsArray) # Setter ønskede DNS-servere i ønsket rekkefølge på angitt nettverkskort.
Write-Output "$wmiPath.DNSHostName $wmiPath.SetDNSServerSearchOrder($dnsArray).ReturnValue"
}
