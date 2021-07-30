function new-CSPCustomer {
    param (
        $CtmrDomain,
        $CtmrCompanyRegNum,
        $CtmrEmail,
        $CtmrCompanyName,
        $CtmrFirstName,
        $CtmrLastName,
        $CtmrPhoneNumber,
        $CtmrAddressLine,
        $CtmrCity,
        $CtmrPostalCode,
        $CtmrCountry,
        $headers 

    )
if($CtmrCompanyName -match '"'){$CtmrCompanyName = $CtmrCompanyName.Replace('"','\"')}
#region Create a new Customer account
$customerprofile = @"
{
    "CompanyProfile": {
        "Domain": "$CtmrDomain",
        "organizationRegistrationNumber": "$CtmrCompanyRegNum"
    },
    "BillingProfile": {
        "Culture": "ru-ru",
        "Email": "$CtmrEmail",
        "Language": "en",
        "CompanyName": "$CtmrCompanyName",
        "DefaultAddress": {
            "FirstName": "$CtmrFirstName",
            "LastName": "$CtmrLastName",
            "phoneNumber": "$CtmrPhoneNumber",
            "AddressLine1": "$CtmrAddressLine",
            "City": "$CtmrCity",
            "State": "$CtmrCity",
            "PostalCode": "$CtmrPostalCode",
            "Country": "$CtmrCountry"
            }
     }
}
"@    
####



try {
$NewCustomer = Invoke-RestMethod -Method 'Post' `
                 -Uri 'https://api.partnercenter.microsoft.com/v1/customers' `
                 -Headers $headers `
                 -Body $customerprofile  `
                 -ContentType 'application/json; charset=utf-8' 
$script:NewCustomerDBG = "trymessage: $NewCustomer"

     }

catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()
        $script:NewCustomerDBG = "catchmessage:$ErrResp"
    }
#$ErrResp
$CustomerTenantID        = "$($NewCustomer.id)"
$script:CustomerTenantIDDBG = $CustomerTenantID 
$CustomerDomainAdminName = $NewCustomer.userCredentials.userName
$CustomerDomainAdminPWD  = $NewCustomer.userCredentials.password
# (get-date).AddDays(-3)
#$AgreementDate           = "2021-07-10T00:00:00.000Z"
                            
$AgreementDate = "$((Get-Date).ToUniversalTime().AddDays(-3) | get-date -Format "yyyy-MM-ddTHH:mm:ss.000Z")"
$script:NewAgreemntDateDBG = $AgreementDate 
#Need put it to the output file!!!!

#endregion

#region Confirm customer acceptance of the Microsoft Customer Agreement ############ 

$agreementbody    = @"
{
    "primaryContact": {
        "firstName": "$CtmrFirstName",
        "lastName": "$CtmrLastName",
        "email": "$CtmrEmail",
        "phoneNumber": "$CtmrPhoneNumber"
    },
    "templateId": "117a77b0-9360-443b-8795-c6dedc750cf9",
    "dateAgreed": "$AgreementDate",
    "type": "MicrosoftCustomerAgreement"
}
"@
try{
$NewAgreement =  Invoke-RestMethod -Method 'Post' `
                    -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/agreements" `
                    -Headers $headers `
                    -Body $agreementbody   `
                    -ContentType 'application/json'
                  
                  $script:NewCtmrAgreementDBG = "trymessage: $NewAgreement"
}
catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()

        $script:NewCtmrAgreementDBG = "catchmessage:$ErrResp"
      }

#$ErrResp
#endregion

#### get customer subscriptions test ######
<#
try{
Invoke-RestMethod -Method 'Get' `
         -Uri "https://api.partnercenter.microsoft.com/v1/customers/$customertenantid/subscriptions" `
         -Headers $headers 
}
catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()
      }
#>
### Find the billing accounts that you have access to ###
<#

try{
Invoke-RestMethod -Method 'Get' `
         -Uri "https://management.azure.com/providers/Microsoft.Billing/billingaccounts/?api-version=2020-05-01" `
         -Credential get-credentials #-Headers $headers
    }
catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()

}
#>

#region create Azure Subscription ##########
# 1.	Get a list of products --Azure

$ProductList = (Invoke-RestMethod -Method 'Get' `
                 -Uri "https://api.partnercenter.microsoft.com/v1/products?country=RU&targetView=MicrosoftAzure" `
                 -Headers $headers `
                 -ContentType 'application/json').items

$script:ProductListDBG = "AzureProductList: $ProductList"

#$AzureGlobalID = ($ProductList | ?{$_.title -match "Azure Global"}).id
$AzurePlanID = ($ProductList | ?{$_.title -match "Azure Plan"}).id

#$script:AzureGlobalIDDBG = "AzureGlobalID: $AzureGlobalID "
$script:AzurePlanIDDBG = "AzurePlanID: $AzurePlanID "

# 2.	Get a list of SKUs for a product --Azure

$AzurePlanSKUList = (Invoke-RestMethod -Method 'Get' `
                       -Uri "https://api.partnercenter.microsoft.com/v1/products/$AzurePlanID/skus?country=RU&targetSegment=commercial" `
                       -Headers $headers `
                       -ContentType 'application/json').items[0]
#$script:AzureGlobalSKUListDBG = "AzureGlobalSKUList: $AzureGlobalSKUList"
$script:AzurePlanSKUListDBG = "AzurePlanSKUList: $AzurePlanSKUList"

$AzurePlanSKUID = $AzurePlanSKUList.id
#$script:AzureGlobalSKUIDDBG = "AzureGlobalSKUID: $AzureGlobalSKUID"
$script:AzurePlanSKUIDDBG = "AzurePlanSKUID: $AzurePlanSKUID"

# 3.	Get a list of availabilities for a product --Azure

$ProductAvailbList = Invoke-RestMethod -Method 'Get' `
                       -Uri "https://api.partnercenter.microsoft.com/v1/products/$AzurePlanID/skus/$AzurePlanSKUID/availabilities?country=RU&targetSegment=commercial" `
                       -Headers $headers `
                       -ContentType 'application/json'

$script:AzureProductAvailbListDBG = "ProductAvailbList: $ProductAvailbList"

$AzureCatalogID = $ProductAvailbList.items.catalogItemId

$script:AzureCatalogIDDBG = "AzureCatalogID: $AzureCatalogID "
# 4.	Create shopping cart

$shoppingcart_tmpl = @"
{
  "lineItems": [
    {
      "id": 0,
      "catalogItemId": "$AzureCatalogID",
      "quantity": 1,
      "billingCycle": "monthly"
    }
  ]
}
"@
$script:shoppingcart_tmplDBG = "shoppingcart_tmpl: $shoppingcart_tmpl"

try{
$shoppingcart = Invoke-RestMethod -Method 'Post' `
         -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/carts" `
         -Headers $headers `
         -Body $shoppingcart_tmpl  `
         -ContentType 'application/json'

$script:NewShoppingCardDBG = "trymessage: $shoppingcart"        
}
catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()

        $script:NewShoppingCardDBG = "catchmessage: $ErrResp"  
      }

#$ErrResp
$ShoppingcartID = $shoppingcart.id

# 5.	Checkout cart

try{
$shoppingcartCheckOut = Invoke-RestMethod -Method 'Post' `
         -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/carts/$ShoppingcartID/checkout" `
         -Headers $headers `
         -ContentType 'application/json'
         # -Body $shoppingcart_tmpl  `

        $script:NewShoppingCardCheckOutDBG = "trymessage: $shoppingcartCheckOut" 

}
catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()

        $script:NewShoppingCardCheckOutDBG = "catchmessage: $ErrResp" 
      }


$AzureSubscriptionID = $shoppingcartCheckOut.orders.lineitems.subscriptionId
$script:AzureSubscriptionIDDBG = $AzureSubscriptionID 
#endregion

#region create a new tenant admin password and set it to not ask for change at logon
$CustomerDomainAdminName = "admin"
$AcceptedDomain = $CtmrDomain
$CustomerShortDomain = $AcceptedDomain.split('.')[0]
$TenantAdmin = "$CustomerDomainAdminName@$AcceptedDomain"

#generate new password for the admin user
# Import System.Web assembly
Add-Type -AssemblyName System.Web
# Generate random password
$NewAdminPWD = [System.Web.Security.Membership]::GeneratePassword(24,10)
$CloudAdminPWD = [System.Web.Security.Membership]::GeneratePassword(24,10)
#$secnewpwd = ConvertTo-SecureString  $pwd -AsPlainText -Force

# Set-AzureADUserPassword
# https://docs.microsoft.com/en-us/powershell/module/azuread/set-azureaduserpassword?view=azureadps-2.0
$NewPWDBody =@"
{
     "passwordProfile":{
        password: "$NewAdminPWD",
        forceChangePassword: false
      },

      "attributes": {
        "objectType": "CustomerUser"
      }
}

"@

# get userid
$tenantusers = Invoke-RestMethod -Method 'Get' `
                 -Uri "https://api.partnercenter.microsoft.com/v1/customers/116afbe0-3511-4faf-b724-9881a1d34cfb/users " `
                 -Headers $headers `
                 -ContentType 'application/json' 



$userid = ($tenantusers.items | ?{$_.userprincipalname -match "admin@*"}).id
try {
 $AdminPWDReset= Invoke-RestMethod -Method 'PATCH' `
                   -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/users/$userid" `
                   -Headers $headers `
                   -Body $NewPWDBody  `
                   -ContentType 'application/json' 
     }

catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()
    }


#endregion

#region WRITE OUTPUT TO A FILE
#return these properties
# $CustomerDomainAdminName
# $AcceptedDomain
# $newpwd
# $AzureSubscriptionID
# $AdminPWDReset

$Script:NewCSPCustomerProperties = new-object psobject
$Script:NewCSPCustomerProperties | add-member -membertype NoteProperty -name CustomerDomain -value NotSet
$Script:NewCSPCustomerProperties | add-member -membertype NoteProperty -name CustomerDomainAdminName -value NotSet
$Script:NewCSPCustomerProperties | add-member -membertype NoteProperty -name CustomerDomainAdminPWD -value NotSet
$Script:NewCSPCustomerProperties | add-member -membertype NoteProperty -name CustomerDomainCloudAdminPWD -value NotSet
$Script:NewCSPCustomerProperties | add-member -membertype NoteProperty -name CustomerAzureSubscriptionID -value NotSet
$Script:NewCSPCustomerProperties | add-member -membertype NoteProperty -name CustomerAdminPWDResetDetails -value NotSet

$Script:NewCSPCustomerProperties.CustomerDomain               = $CustomerShortDomain 
$Script:NewCSPCustomerProperties.CustomerDomainAdminName      = $CustomerDomainAdminName
$Script:NewCSPCustomerProperties.CustomerDomainAdminPWD       = $NewAdminPWD
$Script:NewCSPCustomerProperties.CustomerDomainCloudAdminPWD  = $CloudAdminPWD
$Script:NewCSPCustomerProperties.CustomerAzureSubscriptionID  = $AzureSubscriptionID
$Script:NewCSPCustomerProperties.CustomerAdminPWDResetDetails = $AdminPWDReset

#endregion

return $Script:NewCSPCustomerProperties 

}