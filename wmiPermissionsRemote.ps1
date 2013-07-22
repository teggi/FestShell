function get-sid
{
Param (
$DSIdentity
)
$ID = new-object System.Security.Principal.NTAccount($DSIdentity)
return $ID.Translate( [System.Security.Principal.SecurityIdentifier] ).toString()
}
$d = gwmi Win32_ComputerSystem  # Henter informasjon om domenenavn

$temp = $d.domain + "\GRUPPENAVN" # for å gjøre scriptet så generisk som mulig.

$sid = get-sid $temp # Henter SID basert på input

$SDDL = "A;;CCDCWP;;;$sid"
$computers = Get-Content "C:\servers.txt" # Henter og legger servernavn i variabelen.
foreach ($strcomputer in $computers)
{
    $Reg = [WMIClass]"\\$strcomputer\root\default:StdRegProv"
    $security = Get-WmiObject -ComputerName $strcomputer -Namespace root/cimv2 -Class __SystemSecurity
    $converter = new-object system.management.ManagementClass Win32_SecurityDescriptorHelper
    $binarySD = @($null)
    $result = $security.PsBase.InvokeMethod("GetSD",$binarySD)
    $outsddl = $converter.BinarySDToSDDL($binarySD[0])
    $newSDDL = $outsddl.SDDL += "(" + $SDDL + ")"
    $WMIbinarySD = $converter.SDDLToBinarySD($newSDDL)
    $WMIconvertedPermissions = ,$WMIbinarySD.BinarySD
    $result = $security.PsBase.InvokeMethod("SetSD",$WMIconvertedPermissions)
}