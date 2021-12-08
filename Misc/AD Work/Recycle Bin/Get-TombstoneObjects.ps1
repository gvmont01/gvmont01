$adspath = "LDAP://DC=morganlewis,DC=net"
$root = [System.DirectoryServices.DirectoryEntry]$adsPath

$search = [System.DirectoryServices.DirectorySearcher]$root
$search.Filter = "(&(isDeleted=TRUE)(objectclass=group))"
$search.tombstone = $true
$result = $search.Findall()
$result |  where{ 	$_.properties.lastknownparent -like "*OU=Groups,DC=morganlewis,DC=net*"} | foreach{$_.properties.samaccountname; Write-host ""	}

