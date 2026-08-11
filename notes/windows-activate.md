from powershell (pwsh) taken from: https://gist.github.com/aravindnc/170a569ac305912dd43252f64307902e

```powershell
PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /dlv
Software licensing service version: 10.0.26100.8737

Name: Windows(R), Professional edition
Description: Windows(R) Operating System, VOLUME_KMSCLIENT channel
Activation ID: 2de67392-b7a7-462a-b1ca-108dd189f588
Application ID: 55c92734-d682-4d71-983e-d6ec3f16059f
Extended PID: 03612-03311-000-000001-03-1033-26200.0000-2232026
Product Key Channel: Volume:GVLK
Installation ID: 489126343257012289105546522085205332958764158851011127139061121
Partial Product Key: T83GX
License Status: Notification
Notification Reason: 0xC004F056.
Remaining Windows rearm count: 1001
Remaining SKU rearm count: 1001
Trusted time: 8/11/2026 1:51:01 PM
Configured Activation Type: All
Please use slmgr.vbs /ato to activate and update KMS client information in order to update values.


PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /upk
Uninstalled product key successfully.

PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /cpky
Product key from registry cleared successfully.

PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /ckms
Key Management Service machine name cleared successfully.

PS C:\Users\user> DISM /online /Get-TargetEditions

Deployment Image Servicing and Management tool
Version: 10.0.26100.8737

Image Version: 10.0.26200.8875

Editions that can be upgraded to:

Target Edition : Education
Target Edition : ProfessionalCountrySpecific
Target Edition : ProfessionalEducation
Target Edition : ProfessionalSingleLanguage
Target Edition : ProfessionalWorkstation
Target Edition : Enterprise
Target Edition : IoTEnterprise
Target Edition : IoTEnterpriseK
Target Edition : ServerRdsh
Target Edition : CloudEdition

The operation completed successfully.
PS C:\Users\user> sc config LicenseManager start= auto & net start LicenseManager

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
4      Job4            BackgroundJob   Running       True            localhost            sc config LicenseManager…
The requested service has already been started.

More help is available by typing NET HELPMSG 2182.


PS C:\Users\user> sc config wuauserv start= auto & net start wuauserv

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
6      Job6            BackgroundJob   Running       True            localhost            sc config wuauserv start…
The Windows Update service is starting.
The Windows Update service was started successfully.


PS C:\Users\user> changepk.exe /productkey VK7JG-NPHTM-C97JM-9MPGT-3V66T
PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
Installed product key W269N-WFGWX-YVC9B-4J6C9-T83GX successfully.

PS C:\Users\user> slmgr /skms kms8.msguides.com
PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /skms kms8.msguides.com
Key Management Service machine name set to kms8.msguides.com successfully.

PS C:\Users\user> cscript //nologo C:\Windows\System32\slmgr.vbs /ato
Activating Windows(R), Professional edition (2de67392-b7a7-462a-b1ca-108dd189f588) ...
Product activated successfully.
```
