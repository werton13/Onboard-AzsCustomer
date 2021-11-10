version 2.1
  rewrited for PowerShell Az module
  require to install Az Powershell module
  https://docs.microsoft.com/en-us/azure-stack/operator/powershell-install-az-module?view=azs-2102
  and download Azure Stack tools for Az module: https://github.com/Azure/AzureStack-Tools/archive/az.zip
  Test-PSConfig function have to be rewrited - still on AzureRM version
version 2.0

this script is intended to automate a bundle of procedures, used to onboard a new customer to Multitenant Azure Stack
Those procedures are:
    0) Gather all required parameters and credential via Windows Form 
    1) Add a new tenant to your CSP registration
    2) Register Guest Directory AAD Tenant to Azure Stack
    3) Registering Azure Stack with the guest directory
    4) Create new user account in Customer Azure AD to make it subscription owner and assign Global Admin role to this account
    5) Create Quotas, Plans, Offer and Azure Stack subscription

In the next versions:
1) !Found an error in sql and web apps quotes - urgent correct (done)
 - generate some kind of report (-)
 - add logging (-)
 - add choosing capability for  resource providers required ( add SQL,WebApp Sections enabler)(-)
 - add powershell modules check Модули проверки пререквизитов (need rewrite for Az modules)
 - download icons from URL (-)
 - add show password button (-)
2) 
   New features:
 - add CSP tenant creation function
 - Make main form to not dissapear on push button
 - add an ability to modify subscription quota
 - add password generation function
 - add ability to choose azurestack region
 - add ability to preview monthly estimate for a tenant
 - add account password age verification
 - add ALL accounts age verification
 - Write operation details as JSON & pack it to zip file
 - add new subscription for a new user of existing tenant
 - add autosave for thr default Azure Stack tools path in local folder, keeping in ccomputername - path pair, checking
  Fixes:
  Get new CSP customer Azure SubscriptionID - have to be fixed



  


 add dependency in between comboboxs (for example: Managed Disks Space --depends from-->VM Quantity) (done) (not all)
 virtual networks gateways and connections default quantity should be eq 0 (done)
 increase max Quantity vCPU, VMs,vNIC (done)
####

