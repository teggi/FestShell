$a = gwmi -query "Select * from SMS_Package" -namespace root\sms\site_XXX -computername FJES | gu | format-list -property SourceVersion | out-file "E:\Pakker.txt"
$s = gwmi -query "Select * from SMS_Package" -namespace root\sms\site_XXX -computername FJES | format-list -property Name, SourceSite, SourceVersion | out-file "E:\Package.txt"

#Alle dp's
$distdps = gwmi -query "Select * From SMS_SystemResourceList WHERE RoleName='SMS Distribution Point'" -namespace root\sms\site_XXX -computername FJES
$pakker = gwmi -query "Select PackageID, SiteCode, SourceVersion from SMS_PackageStatusDistPointsSummarizer" -namespace root\sms\site_XXX -computername FJES | format-list -property SourceVersion, PackageID, SiteCode | out-file "E:\testfil.txt"

foreach ($pakke in $pakker) {
    foreach ($distdp in $distdps) {
        
    