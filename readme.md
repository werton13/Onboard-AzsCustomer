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
 generate some kind of report (-)
 add logging (-)
 add choosing capability for  resource providers required ( add SQL,WebApp Sections enabler)(-)
 add powershell modules check Модули проверки пререквизитов (done)
 download icons from URL (-)
 add show password button (-)

 add dependency in between comboboxs (for example: Managed Disks Space --depends from-->VM Quantity) (done) (not all)
 virtual networks gateways and connections default quantity should be eq 0 (done)
 increase max Quantity vCPU, VMs,vNIC (done)
####

