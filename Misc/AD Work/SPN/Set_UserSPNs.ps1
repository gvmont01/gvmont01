 
$acct = '!STSQLSRV01'
$NewSPNs = 'MSSQLSvc/STVSQLD01.Morganlewis.net:1433' # 'MSSQLSvc/DVVSQLD01.Morganlewis.net:1433','MSSQLSvc/DVVSQLD02.Morganlewis.net:1433', 
#'MSSQLSvc/DVVSQLQ01.Morganlewis.net:1433', 'MSSQLSvc/DVVSQLQ02.Morganlewis.net:1433'


#use when contacting CLMLB domain
#$acct = 'clmlb\!STDSCLSQLSRV'
#Set-QADUser -Service clmlb.loc -Identity $acct -objectAttributes @{servicePrincipalName=@{Append=@($NewSPNs)}}

Set-QADUser -Identity $acct -objectAttributes @{servicePrincipalName=@{Append=@($NewSPNs)}}


#sample to search for the addition and send report to requestor
Get-QADObject -SearchRoot 'dc=morganlewis,dc=net' -ldapFilter '(servicePrincipalname=MSSQLSvc*)' -IncludedProperties servicePrincipalName -sizeLimit 0 | Where-Object name -eq $acct |
      Select-Object name,@{name='SPN';Expression={$_.servicePrincipalName -join "`n"} } | Out-GridView