#Script handles SPN creations
#Example of a request below:
#1. Create the following SPN for service account Morganlewis\!CODSSQLSRV01
#
#MSSQLSvc/COVSQLD11.Morganlewis.net:1433 
#
#2. Enable Kerberos delegation on server COVSQLD11
#
#3. Create the following SPN for service account Morganlewis\!CODSSQASRV01
#
#MSOLAPSvc.3/COVSQLA02.Morganlewis.net
#MSOLAPSvc.3/COVSQLA02.Morganlewis.net:TABULAR
#
#4.  Enable Kerberos delegation on server COVSQLA02
#
#5: Create SPN for the Browser Service on the Analysis Server COVSQLA02
#
#MSOLAPDisco.3/COVSQLA02.Morganlewis.net
#MSOLAPDisco.3/COVSQLA02

#load AD module if necessary
function LoadADModule {
  # Load AD Module (if not already)
  if ((Get-Module ActiveDirectory -ErrorAction SilentlyContinue) -eq $null){
    Import-Module ActiveDirectory
  }
}
 #region OPTION 1
LoadADModule

#$SPN = "MSSQLSvc/COVSQLD07.Morganlewis.net:1433","MSSQLSvc/CPVSQLD07.Morganlewis.net:1433" #array of values for Heat ticket on 5/8/2014
$SPN = 'MSSQLSvc/COVSQLD24.Morganlewis.net:1433'
$ServiceAccount = '!CODSSQLSRV01' 

Set-ADUser -Identity $ServiceAccount -ServicePrincipalNames @{Add=$SPN} -TrustedForDelegation $true
#endregion

#region OPTION 2
$ServiceAccount = 'clmlb\!STDSCLSQLSRV'
$NewSPNs = 'MSSQLSvc/STVSQLD51.CLMLB.LOC:1433','MSSQLSvc/STVSQLD52.CLMLB.LOC:1433'
Set-QADUser -Service clmlb.loc -Identity $ServiceAccount -objectAttributes @{servicePrincipalName=@{Append=@($NewSPNs)}}
#endregion

exit

#sample to search for the addition
$Account = $ServiceAccount.Split('\')[1]
Get-QADObject -SearchRoot 'dc=morganlewis,dc=net' -ldapFilter "(servicePrincipalname=MSOLAPSvc.3*)" -IncludedProperties servicePrincipalName -sizeLimit 0 | ?{$_.name -eq $Account} |
      select name,@{name='SPN';Expression={$_.servicePrincipalName -join "`n"} } | Out-GridView
			
#produces the report below
#****************
#Name : !STDSSQLSRV01
#SPN  : MSSQLSvc/STVSQLD04.Morganlewis.net:1433
#       MSSQLSvc/STVSQLD08.Morganlewis.net:1433
#       MSSQLSvc/STVSQLD02.Morganlewis.net
#       MSSQLSvc/STVSQLD07.Morganlewis.net
#       MSSQLSvc/STPSQLD01.Morganlewis.net:NS2
#       MSSQLSvc/STPSQLD01.Morganlewis.net:NS1