﻿#lookup of the tomb stone lifetime setting for AD Recycle Bin
(Get-QADObject 'CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=Firm,DC=root' -properties 'tombstonelifetime' -dudip).tombstonelifetime