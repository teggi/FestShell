$pakker = gwmi -query "Select * from SMS_Package" -namespace root\sms\site_XXX -computername FJES
#$dps = gwmi -query "Select SiteCode, PackageID from SMS_DistributionPoint" -namespace root\sms\site_XXX -computername FJES
#$i = 0
#$k = 0
#[int]$teller1 = 0
#[int]$teller2 = 1

foreach ($pakke in $pakker) {
            #$i = "$pakke.PackageID"
            $p = $pakke.PackageID.Trim().TrimEnd(".PackageId")
            $s = gwmi -query "Select * from SMS_PackageStatusDistPointsSummarizer WHERE PackageID like ""$p"" AND SiteCode like XXX" -namespace root\sms\site_XXX -computername FJES
            $y = gwmi -query "Select * from SMS_PackageStatusDistPointsSummarizer WHERE PackageID like ""$p"" AND SiteCode like XXX" -namespace root\sms\site_XXX -computername FJES
            Write-Host $s.SourceVersion $s.PackageID $s.SiteCode 
            Write-Host $y.SourceVersion $y.PackageID $y.SiteCode
            #$r = $s
            #$s | format-table -property PackageID, SiteCode, SourceVersion
            
            
           
            #write-host $i #Kun for debug <-
            #Write-Host $s[$i].SourceVersion $s[$i].SiteCode $s[$i].PackageID
            #$i = $i + 1
            #$i = $i +1
               #Write-Host $i #Kun for debug <-
            
        }
        