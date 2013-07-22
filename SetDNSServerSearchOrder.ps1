#################################################################################
### Opprettet av Marius Koch, Steria
### SetDNSServerSearchOrder
### Benyttes for � sette DNSServerSearchOrder (DNS-servere) remote via WMI.
### Scriptet er skrevet med f�lgende antakelser: Server er medlem av domenet, kj�rende bruker har administratorrettigheter, og har ikke tilgang p� Active Directory-modul for kj�ring av Get-ADComputer (evt kj�res dette p� annen server for � produsere *:\servers.txt)
#################################################################################

$dnsArray = @("127.0.0.1","127.0.0.1") # Array med DNS-servere, satt i �nsket rekkef�lge
$computers = "Get-Content c:\servers.txt"

foreach ($computer in $computers) {
$wmiPath = Get-WmiObject -namespace root\cimv2 -class Win32_NetworkAdapterConfiguration -computer $computer | where{$_.IPAddress -like "10*"} # Henter nettverkskort basert p� om IP-adressen begynner p� 10.
$wmiPath.SetDNSServerSearchOrder($dnsArray) # Setter �nskede DNS-servere i �nsket rekkef�lge p� angitt nettverkskort.
Write-Output "$wmiPath.DNSHostName $wmiPath.SetDNSServerSearchOrder($dnsArray).ReturnValue"
}
