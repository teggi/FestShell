#	wmiPermissionsLocal
#	Laget av Marius Koch
#	Vil definere nødvendige rettigheter for å aksessere WMI fra en annen klient/server.

#Funksjon for å hente ut SID som benyttes av SDDL.
function get-sid
{
Param (
$DSIdentity
)
$ID = new-object System.Security.Principal.NTAccount($DSIdentity)
return $ID.Translate( [System.Security.Principal.SecurityIdentifier] ).toString()
}


$d = gwmi Win32_ComputerSystem  			# Henter informasjon om domenenavn
$temp = $d.domain + "\GRUPPENAVN"	# for å gjøre scriptet så generisk som mulig. Krever input, bytt ut "test" med ønsket gruppenavn.

$sid = get-sid $temp 					# Henter SID basert på input

$SDDL = "A;;CCDCWP;;;$sid" # Definerer rettighetene som skal oversettes binært.
$computer = "."

    $Reg = [WMIClass]"\\$computer\root\default:StdRegProv"
    $security = Get-WmiObject -ComputerName $computer -Namespace root/cimv2 -Class __SystemSecurity
    $converter = new-object system.management.ManagementClass Win32_SecurityDescriptorHelper
    $binarySD = @($null)
    $result = $security.PsBase.InvokeMethod("GetSD",$binarySD) # Henter ut nåværende rettigheter.
    $outsddl = $converter.BinarySDToSDDL($binarySD[0]) # Konverterer nåværende rettigheter til SDDL.
    $newSDDL = $outsddl.SDDL += "(" + $SDDL + ")" # Legger til nye rettigheter ved siden av de gamle.
    $WMIbinarySD = $converter.SDDLToBinarySD($newSDDL)
    $WMIconvertedPermissions = ,$WMIbinarySD.BinarySD
    $result = $security.PsBase.InvokeMethod("SetSD",$WMIconvertedPermissions) # Setter rettighetene i WMI-security.