$domain = gwmi win32_computersystem | select Domain
$path = "c:\test\$domain.txt"

#Fjerner filen slik at vi kan skrive til en tom fil
if (Test-Path "$path") {
	Remove-Item "$path"
	Write-Host "Fjerner filen $path"
}

#Skriver inn domenenavn for enkel identifikasjon av fil
$domain >> $path

#Skriver en tom linje for syns skyld
"" >> $path
#Henter nettverkskort basert på om "DHCPEnabled" er av eller på. Mistenker at denne bør byttes før man kjører på en server, evt se om man finner en annen fellesnevner som går igjen i hele løsningen.
$s = "C:\TEKSTFIL.TXT"
foreach ($server in $s) {
    $g = gwmi Win32_NetworkAdapterConfiguration | where{$_.DHCPEnabled -match "False"}
        foreach ($i in $g) {
            $i.DnsHostName >> $path
                foreach ($y in $i.DNSServerSearchOrder) {
                    $y >> $path
                                                        }
                           }
                         }