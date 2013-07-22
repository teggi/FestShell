remove-variable *
$files = Get-ChildItem x:\myon\

$debugPreference = 'Continue'
$verbosePreference = 'Continue'
$filer = Get-ChildItem 'x:\myon\'

foreach ($fil in $files) {
    $media = [TagLib.File]::Create("x:\myon\" + $fil.ToString())
    #$newTitleDigits = $media.Name.TrimStart("x:\myon\myon_and_shane_54_-_international_departures_").SubString(0,3)
    #$newTitleDigits
    $media.Name
    $media.Tag.Title
    write-host ""
    #$newTitle = "Episode $($newTitleDigits)"
    #$media.Tag.Title = $newTitle
    #$media.Save()

        
 
}


