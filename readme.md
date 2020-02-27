version 1.0

this script is inttended to automate a bundle of procedures, used to onboard a new customer to Multitenant Azure Stack
Those procedures are:
    0) Gather all required parameters and credential via Windows Form 
    1) Add a new tenant to your CSP registration
    2) Register Guest Directory AAD Tenant to Azure Stack
    3) Registering Azure Stack with the guest directory
    4) Create new user acccount in Customer Azure AD to make it subscription owner and assign Global Admin role to this account
    5) Create Quotas, Plans, Offer and Azure Stack subscription