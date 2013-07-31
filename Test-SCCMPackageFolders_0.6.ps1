#skrive inn noe hax for å sjekke om det er en "central/standalone" site
# does not support software updates packages at the moment. to be added.
# Should write a logging-scriptmodulefunctiongatheringofsorts. should be able to log to file and at the very least write to console as it goes.
# also planning to add a goddamn progressbar at a later time.
# at the moment does not support both shortname and FQDN-version of sharenames - which as i write this i realize is not even possible. you can only create shortname-UNCpaths in SCCM. good riddance - i'll just leave it in for the heck ofit!
# Remember to remove the manual input and requirement of the "siteCode"-variable - finish the Get-SCCMSiteInformation-function instead. #yolo.
# Usage = . .\Test-SCCMPackageFolders.ps1
#	= Test-SCCMPackageVSFolder "sitecode" "computername"
# Prerequisites: PS 2.0
# 			   : Reading the fucking manual.
#
# 				Versions
#				0.5
#				Starting point.
#				0.6
#				Added functionality to replace "+" with "_" so that the -match operator actually works.

$VerbosePreference = 'Continue'
$DebugPreference = 'SilentlyContinue'

Function Test-SCCMPackageVSFolder {
	Param(
		$siteCode,
		$centralSiteServer
		)
		# Get all the information we require for the comparison.
		$foldersNotLinkedToPackage = @() # Array for output for laters! This is to be replaced by directly writing to console and logfile.
		$softwarePackages = Get-SCCMSoftwarePackages $siteCode $centralSiteServer
		$softwareUpdatePackages = Get-SCCMSoftwareUpdatePackages $siteCode $centralSiteServer
		$localSourceDirectory = Get-SCCMPackageLocation $siteCode $centralSiteServer
		$shareSourceDirectory = Get-WindowsShareName $localSourceDirectory $centralSiteServer
		$foldersToCompare = Get-ChildItem -Path $localSourceDirectory -ErrorAction SilentlyContinue | ?{$_.PSIsContainer} -ErrorAction SilentlyContinue # Should write this into a function. This is part of our data for the comparison.
		$shareNameString = "\\$($centralSiteServer)\$($shareSourceDirectory.Name)" # Preparing a variable for replacement so that we can easily attempt to match for a shared folder in case one isn't found using local - this should be added to the Get-WindowsShareName function instead.
							foreach ($folder in $foldersToCompare) {					
								$folderLinkedToPackage = $FALSE
								$tempFolder = $folder.FullName.Replace("+","_") # Replacing because the -match operator can't check for pluses. Yay.
								foreach ($softwarePackage in $softwarePackages) {
									$tempPkgSourcePath = $softwarePackage.PkgSourcePath.Replace("\","\\") # Adding another backslash because -match also escapes with backslash.
									$tempPkgSourcePath = $tempPkgSourcePath.Replace("+","_") # Replacing + with _ because the -match operator can't check for pluses. Yay.
									if ($softwarePackage.PkgSourcePath.Split("\")[0] -match "[A-z]") { # This checks to see if we're dealing with a local package or not - shares will be handled seperately. Example: "C:\ProdSource\" is split into "C:" "ProdSource" whereas "C:" is [0]. If [0] matches for a letter this is treated as a local drive.
										Write-Debug $folder.FullName # Nice to have for further development.
										Write-Debug $tempPkgSourcePath # Nice to have for further development.
										if ($tempFolder -match $tempPkgSourcePath) {
											$folderLinkedToPackage = $TRUE
										}
									}
										else { # This automatically assumes that we are dealing with a UNC-sourcedirectory.
											 $tempFolderShareName = $tempFolder.Replace("$($localSourceDirectory)","$($shareNameString)")
											 	if ($tempFolderShareName -match $tempPkgSourcePath) {
													$folderLinkedToPackage = $TRUE
												}
										}
								}
									if ($folderLinkedToPackage -eq $FALSE) { # This takes care of writing to console and logfile. No need for a duplicate of this bit.
										$foldersNotLinkedToPackage += $folder.FullName # Adding to dev-array for testing! OH YEAH!
										Write-Verbose "Added $($folder.FullName) to array...."
									}
							}
		Echo "The following folders are not linked to a package."
		return $foldersNotLinkedToPackage
}
Function Get-WindowsShareName {
	Param(
		$localFolderName,
		$centralSiteServer
		)
			$localFolderName = $localFolderName.Replace("\","\\") # Escaping the backslash because WQL uses this as its escape-character.
			$windowsShareName = Get-WmiObject -Query "Select Name from Win32_Share WHERE Path like ""$localFolderName""" -Namespace root\cimv2 -ComputerName $centralSiteServer
			
			return $windowsShareName
}

Function Get-SCCMSoftwarePackages {
    Param(
        $siteCode,
        $centralSiteServer
        )
        
        $softwarePackages = Get-WMIObject -Query "Select * from SMS_Package" -NameSpace root\sms\site_$siteCode -ComputerName $centralSiteServer
        return $softwarePackages
}
        
Function Get-SCCMSoftwareUpdatePackages {
    Param(
        $siteCode,
        $centralSiteServer
        )
        
        $softwareUpdatePackages = Get-WMIObject -Query "Select * from SMS_SoftwareUpdatesPackage" -NameSpace root\sms\site_$siteCode -ComputerName $centralSiteServer
        return $softwareUpdatePackages
}
        
Function Get-SCCMSiteInformation {}
	#<noe om å finne lokal sitekode - scriptet må jo tross alt kjøres på sentral boks!>

Function Get-SCCMPackageLocation { # Uses WMI to enumerate package location, thereafter we will use Win32_Share to enumerate the share-name which is also applicable in some cases.
	Param( # 
		[string]$siteCode,
		[string]$centralSiteServer
	) # 
        $foudnPackageSourcePath = $FALSE # Just declaring for good measure.
        $tempPackages = Get-SCCMSoftwarePackages $siteCode $centralSiteServer # Only utilizes the "normal packages" to determine the source directory for packages as it should all be in one place.
	
		do { # 
			foreach ($tempPackage in $tempPackages) { # 
                if ($tempPackage.PkgSourcePath -ne "") { # Skips any package that might not have a package location. These packages are therefore not applicable for the tests beneath.
					$tempPackageLocation = $tempPackage.PkgSourcePath.Split("\")
    					if ($tempPackageLocation[1] -match "[A-z]") { # 
							$packageLocation = $tempPackageLocation[0] + "\" + $tempPackageLocation[1]
							$foundPackageSourcePath = $TRUE
                            #Write-Debug "Matched for text. wee."
						} # 
							else { # 
								$packageLocation = $tempPackageLocation[3]
								$foundPackageSourcePath = $TRUE
                                #Write-Debug "Matches for share (more or less), did not match for local drive!"
							} # 
				}
			}
					return $packageLocation # Might have to rewrite this a bit - not tested at all.
		}# 
			while ($foundPackageSourcePath -eq $FALSE)

} # End function