#requires -version 2
 
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
 
#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"
$DebugPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

#----------------------------------------------------------[Declarations]----------------------------------------------------------
 
#Script Version
$sScriptVersion = "0.5"

#-----------------------------------------------------------[Functions]------------------------------------------------------------
 
Function Get-ExpiringCertificates { # Start function Get-ExpiringCertificates
    Param( # Start Param
    [string]$certificateIssuer,
    [int]$interval
    ) # End Param
    
<#
.SYNOPSIS
 Retrieves FriendlyName and number of days till expiration based on the certificateIssuer and interval variables.

.PARAMETER certificateIssuer
    We use the certificates issuer to determine if we actually want to check the certificates expirationdate.
 
.PARAMETER interval
    Days into the future which we want to use as the baseline for checking for expiring certificates. Example: 90 days, for 3 months into the future.
    
.OUTPUTS
    The script outputs number of days untill certificate expiration, and also the humanly readable FriendlyName of said certificate.
 
.NOTES
    Version:        0.5
    Author: Marius Koch
    Creation Date: 21.07.2013
    Purpose/Change: To check for expiring certificates using monitoring systems such as SCOM, or even on a manual basis.
 
.EXAMPLE
 Get-ExpiringCertificates "String" 90
#>

$willItExpire = $FALSE # Defines the variable as false just for good measure.

$certificateExpirationDate = Get-CertificateExpirationDate $certificateIssuer # Calls the function Get-CertificateExpirationDate to determine the certificates expirationdate.

$willItExpire = Test-CertificateExpiration $($certificateExpirationDate.NotAfter) $interval # Calls the function Test-CertificateExpiration to determine if the certificate will expire.

    if ($willItExpire) { # Start IF 1
        $daysTillExpiration = Get-DaysTillExpiration $certificateExpirationDate.NotAfter
        Write-Debug "There are $($daysTillExpiration) days left till the certificate expires!"
            return $daysTillExpiration, $certificateExpirationDate.FriendlyName # Returns both the number of days till certificate expiration, and also the FriendlyName of the certificate (readable for normal humans..)
    } # End IF 1

} # End function Get-ExpiringCertificates

Function Get-CertificateExpirationDate { # Start function
    Param( # Start Param
        $certificateIssuer
    ) # End Param
    
    $certificatesToCheck = Get-ChildItem cert:\LocalMachine\My # Getting all localmachine-certificates. They are the ones we would like to validate!
    
    Write-Debug $certificateIssuer # For development
        foreach ($certificateToCheck in $certificatesToCheck) { # Start foreach 1
            Write-Debug "We're about to check if the issuer is correct!"
            if ($certificateToCheck.Issuer -like $certificateIssuer) { # Start IF 1 HUSK Å ENDRE TIL ISSUER/ISSUERNAME FOR Å VALIDERE UTSTEDER OG IKKE FRIENDLYNAME SOM I LABB. Validates certificates to check if this is actually a certificate we would like to check the date on.
                $certificateExpirationDate = $certificateToCheck.NotAfter
                Write-Debug "We've figured out that this is one of the certificates we would like to check! That one is named $($certificateToCheck.FriendlyName)"
            } # End IF 1
                    if ($certificateExpirationDate -ne $NULL) { # Start IF 1
                        return $certificateToCheck # Returning the date, time and friendlyname of the certificates expiration
                         #$certificateToCheck.FriendlyName Gotta make something happen here, gotta bring the friendlyname of the certificate out. Perhaps its own function is in order?
                    } # End IF 1
                        else { # Start else 1
                            Write-Debug "No certificates found to validate! Bummer!" # Simply for development. Won't really do anything during production-use.  
                        } # End else 1
       } # End foreach 1
} # End function

Function Test-CertificateExpiration { # Start function
    Param( # Start Param
        $certificateExpirationDate,
        [int]$interval
    ) # End Param
        
        $comparisonTime = ((Get-Date).AddDays($interval)) # Gets current date and simultaneously adds the interval to make the comparison work. 
        Write-Debug "Printing comparisontime (interval added to currentdate) $($comparisonTime.ToString())" # Debugging
        Write-Debug "Printing expirationTime $($certificateExpirationDate.ToSTring())"
        if ($certificateExpirationDate -le $comparisonTime) { # Start IF 1
            Write-Debug "The certificate will expire within the defined timeperiod."
                return $TRUE
        } # End IF 1
            else { # Start else 1
                return $FALSE
            } # End else 1
} # End function
        
        #$daysTillExpiration = $certToCheck.NotAfter - $currentDate
        
Function Get-DaysTillExpiration { # Start function
    Param( # Start Param
        $certificateExpirationDate
    ) # End Param
    
    $currentDate = Get-Date # Gets current date
    $daysTillExpiration = $certificateExpirationDate - $currentDate # Subtracts the certificates expiration date from the current date to determine how many days are left till expiration.
        return $daysTillExpiration.Days # Returns the number of days left before the certificate expires.
} # End function
 
#-----------------------------------------------------------[Execution]------------------------------------------------------------
 
