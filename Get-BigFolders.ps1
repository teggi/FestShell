$DebugPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

#ThereIFixedIt
#Remove-Variable i | Out-Null # For testing/dev purposes.
#Remove-Variable numberOfFolders | Out-Null # For testing/dev purposes.

while (($numberOfFolders -is [int]) -eq $False) {
    [int]$numberOfFolders = Read-Host ("Input a number of folders to show (must be a number, e.g 1)")
    }


[int]$numberOfFolders = $numberOfFolders -1 # Normalizing the number because the array actually starts at 0. E.g the number 5 will be cut back to 4, but it will still count to 5.

$disks = Get-WmiObject -Query "Select * from Win32_LogicalDisk WHERE MediaType like '12'"

foreach ($disk in $disks) {
    Write-Verbose "Disk found: $($disk.DeviceID)"
    }

    foreach ($disk in $disks) {
		[int]$i = 0
		if (Get-Variable folderTbl | Out-Null) {$folderTbl.Clear() | Out-Null}
		if (Get-Variable folderSizeTbl | Out-Null) {$folderSizeTbl.Clear() | Out-Null}
		$folderTbl = @{}
		$folderSizeTbl = @{}
        Write-Debug "Attempting to retrieve folder-structure from partition labeled $($disk.VolumeName) with driveletter $($disk.DeviceID)"
        $tmpDeviceID = $disk.DeviceID + "\"
		Write-Host -ForegroundColor Yellow "Checking partition $($tmpDeviceID) for big folders!"
		Write-Host ""
        $tmpFolders = Get-ChildItem -Path $tmpDeviceID -Recurse -Force -ErrorAction SilentlyContinue | ?{$_.PSIsContainer} -ErrorAction SilentlyContinue
        $folderTbl.Add($disk.DeviceID,$tmpFolders)
        
        
            foreach ($folders in $folderTbl.Values) { # ENDRET Values[0]
                foreach ($folder in $folders) { # EXTRA LOOP TO HANDLE PS2 HASHTABLE. $folderTbl.Values[0].FullName was replaced in the foreach above with $folderTbl.Values, and then this line was added so it would work on earlier versions.
                    Write-Debug "Checking folder $($folder.FullName)"
                    $tmpFolder = Get-ChildItem -Path $folder.FullName -Force -ErrorAction SilentlyContinue| Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue # Fjernet -Recurse for "riktige resultater": ingen konsolidering av mapper (e.g C:\Windows er ikke nødvendigvis størst, men mappen c:\windows\system32 er kanskje størst.)
                    $tmpFolderMB = "{0:N2}" -f ($tmpFolder.Sum / 1MB)
                    $folderMB = [System.Convert]::ToDouble($tmpFolderMB) # Converts to double to be able to sort it later.
					Write-Debug "Adding folder $($folder.FullName)"
                    $folderSizeTbl.Add($folder.FullName,$folderMB)
                }
            }

                        $folderSizeTbl = $folderSizeTbl.GetEnumerator() | Sort-Object Value -Descending # Sorts the hashtable in order to retrieve the N largest items in the hasthtable.

                        while ($i -le $numberOfFolders) {
                            $tmpOutSize = $folderSizeTbl.GetValue($i)
                            Write-Host $tmpOutSize.Key $tmpOutSize.Value MB
                            $i++
                        }
	}