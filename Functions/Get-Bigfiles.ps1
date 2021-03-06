#   Get-Bigfiles
#   Laget av Mikkel Kristiansen
#   Vil hente ut lokale disker, og liste ut de X største filene per funnet partisjon.


function get-bigfiles ($antall = 5)   {

write-verbose "$antall filer per partisjon blir hentet ut."
$a = [System.IO.DriveInfo]::getdrives() | where {$_.DriveType -match "Fixed"} #Henter ut lokale disker, og ignorerer USB,CDROM,Nettverksshare.
Write-Verbose "Partisjoner:"
foreach ($i in $a) {
    write-verbose $i.Name }
$a | foreach-object {dir $_.Name -recurse -force -ea SilentlyContinue| #Looper gjennom drives, ignorerer access denied-meldinger.
    sort-object Length -desc -ea SilentlyContinue|select-object -first $antall| #Sorterer
    select @{Name="Filnavn"; Expression = {$_.FullName}},@{Name="MB"; Expression = {[math]::truncate($_.Length /1MB)}},@{Name="Sist skrevet"; Expression = {$_.LastWriteTime}}}| #Formatering
    ft -autosize
    }