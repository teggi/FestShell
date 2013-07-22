#Dette scriptet legger til brukere i AD ved hjelp av en CSV  fil

#Setter domenet
$Domain = "DC=powershell,DC=hist,DC=no"

#Legger inn domene og sti til ou'en som brukeren skal ligge i
$dc ="ou=it,ou=ssm,dc=powershell,dc=hist,dc=no"
$userContainer = [adsi] "LDAP://$dc"
$csvSti = "d:\script\itusers.csv"
 

#Sjekker forbindelsen til AD. returnerer "Greide ikke å koble til" hvis det ikke er noen forbindelse
if(-not $userContainer.Name)
{
Write-Error "Greide ikke koble til: $container"
return
}
 
#Leser inn passord, dette passordet blir satt som standardpassord til alle brukere som blir lagt inn 
$password = Read-Host "Skriv inn passord"

 
#Laster CSV
$bruker = @(Import-Csv $csvSti)
if($bruker.Count -eq 0)
{
return
}
 
#Går igjennom brukerne i CSVen
foreach($user in $bruker)
{
 
#Henter navnet
$brukernavn = $user.CN
Write-host "$brukernavn"
$passord = $user.password
$newUser = $userContainer.Create("User","CN=$brukernavn")
$newUser.SetInfo()
$newUser.Put("sAMAccountName", "$brukernavn")
$newUser.SetInfo()
$newUser.psbase.Invoke("SetPassword", "$password")

#Enabler brukerkonto
$newUser.psbase.InvokeSet('AccountDisabled', $false)
$newUser.SetInfo()

#Setter at bruker må skifte passord ved førstagangs innlogging
$newUser.Put("pwdLastset",0)
$newUser.setinfo()

#Setter homefolder
$Share = "hjemmemapper"
$Computer = "\DOMENEKONTROLLER"
$navn = "%username%"
$HomeDrive = "H"
$HomeDirectory = "\" + $Computer + "\" + $Share + "\" + $navn

$newUser.Put("homeDirectory",$HomeDirectory)
$newUser.Put("homeDrive",$HomeDrive)
$newUser.SetInfo() 


#Henter de andre verdiene
foreach($property in $user.PsObject.Properties)
{
if($property.Name -eq "CN")
{
continue
}
if(-not $property.Value)
{
continue
}

$newUser.Put($property.Name, $property.Value)
}
 
#laster inn brukerene til AD.
$newUser.SetInfo()
}