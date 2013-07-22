#Remove-Variable *
$max = 200
[int]$counter = Read-Host ("Skriv inn første episode du ønsker å laste ned, eks 123")
$userAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)"
$dir = Read-Host ("Skriv inn dir, må ha en trailende slash som f.eks x:\myon\ eller c:\balle\")
$counter += 5

do {
    $url = "http://ms54.com/podcast-episode/?id=$counter"
    $url = "http://www.myonandshane54.com/id/download.php"
    $url = "http://www.myonandshane54.com/id/myon*"
    write-host $url

    if (Get-Process iexplore) {
        Stop-Process -Name iexplore
        Write-Host "Stopped instance of iexplore to avoid script-crash due to too many iexplores (or some such)"
        }

        $ie = New-Object -ComObject InternetExplorer.Application
        $ie.visible = $false
        $ie.silent = $true
        #$ie.Headers.Add("user-agent", $userAgent)
        $ie.Navigate( $url )
        while($ie.busy) {Start-Sleep 1}
        $tempLink = $ie.Document.Links | Select-Object outerText, nameProp, href

    foreach ($linkage in $tempLink) {
	Write-Verbose $linkage.outerText
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