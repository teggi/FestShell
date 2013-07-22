#  Get-Reports
#  Laget av Mikkel Kristiansen
#  Henter ut objekter fra ett domene, og er laget for rapporter.
#  Activeuser vil liste alle brukere med homefolder definert
#  Det er mulig å definere path til annet domene, f.eks. $Root = 'LDAP://DC=PS,DC=LAB,DC=no'

function get-search ($filter)
{
if (! $root) {
Write-debug "Variablen root ikke spesifisert, vil søke i lokalt tilgjengelig domene."
$root = New-Object DirectoryServices.DirectoryEntry
}
else {
$dom = New-Object DirectoryServices.DirectoryEntry $root
$root = $dom
}
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher($root)
$objSearcher.SearchScope = "Subtree"
$objSearcher.PageSize = 10000 # Antall objekter som hentes ut av gangen. Om denne ikke er definert blir maks 1000 hentet ut, om den er definert vil den hente ut X per "side", men vil til slutt vise alle.
if ($filter -like "activeuser") {
$objSearcher.Filter = "(&(&(|(&(objectCategory=person)(objectSid=*)(!samAccountType:1.2.840.113556.1.4.804:=3))(&(objectCategory=person)(!objectSid=*))(&(objectCategory=group)(groupType:1.2.840.113556.1.4.804:=14)))(objectCategory=user)(homeDirectory=*)))"
}
else  {
$objSearcher.Filter = "(objectCategory=$filter)"
}
$colResults = $objSearcher.FindAll()
Write-Debug "Objekter hentet ut, kjører count."
$counts = $colresults|Measure-Object -property Path
write-host "Det er $($counts.Count) objekter av typen $filter."

}

get-search computer
get-search user
get-search activeuser