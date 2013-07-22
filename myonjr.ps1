Remove-Variable *
$max = 164
$counter = 1
$userAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)"
$dir = Read-Host ("Skriv inn dir, må ha en trailende slash som f.eks x:\myon\ eller c:\balle\")

do {
    $url = "http://myonandshane54.com/radio.php?episode=$counter"
    write-host $url



        $ie = New-Object -ComObject InternetExplorer.Application
        $ie.visible = $false
        $ie.silent = $true
        #$ie.Headers.Add("user-agent", $userAgent)
        $ie.Navigate( $url )
        while($ie.busy) {Start-Sleep 1}
        $tempLink = $ie.Document.Links | Select-Object outerText, nameProp, href

    foreach ($linkage in $tempLink) {
        if ($linkage.outerText -like 'Download mp3*') {
            $tmpDest = $linkage.nameProp
            $link = $linkage.href
            $tmpDest = $link.Split("/")
            $dest = $dir + $tmpDest[4]
            if (!(Test-Path $dest)) {
                Write-Host "Trying to download " $link "to " $dest
                $dl = New-Object System.Net.WebClient
                $dl.Headers.Add("user-agent", $userAgent)
                $dl.downloadFile("$($link)","$($dest)")
            }
        }
            
                
    }
$counter++
}
while ($counter -le $max)