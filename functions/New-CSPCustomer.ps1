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
 Write-Host "CustomerTenantID:  $CustomerTenantID"                           
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
write-host "customer acceptance of the Microsoft Customer Agreement: $script:NewCtmrAgreementDBG "
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
write-host "Get a list of products --Azure"
$ProductList = (Invoke-RestMethod -Method 'Get' `
                 -Uri "https://api.partnercenter.microsoft.com/v1/products?country=RU&targetView=MicrosoftAzure" `
                 -Headers $headers `
                 -ContentType 'application/json').items

$script:ProductListDBG = "AzureProductList: $ProductList"

#$AzureGlobalID = ($ProductList | ?{$_.title -match "Azure Global"}).id
$AzurePlanID = ($ProductList | ?{$_.title -match "Azure Plan"}).id

#$script:AzureGlobalIDDBG = "AzureGlobalID: $AzureGlobalID "
$script:AzurePlanIDDBG = "AzurePlanID: $AzurePlanID "
write-host "AzurePlanProductID: $AzurePlanID "

# 2.	Get a list of SKUs for a product --Azure
write-host "Get a list of SKUs for a product --Azure"
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
write-host "Get a list of availabilities for a product --Azure"
$ProductAvailbList = Invoke-RestMethod -Method 'Get' `
                       -Uri "https://api.partnercenter.microsoft.com/v1/products/$AzurePlanID/skus/$AzurePlanSKUID/availabilities?country=RU&targetSegment=commercial" `
                       -Headers $headers `
                       -ContentType 'application/json'

$script:AzureProductAvailbListDBG = "ProductAvailbList: $ProductAvailbList"

$AzureCatalogID = $ProductAvailbList.items.catalogItemId

$script:AzureCatalogIDDBG = "AzureCatalogID: $AzureCatalogID "

# 4.	Create shopping cart
write-host "Start creating shopping cart"
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
write-host "shoppingcart_tmpl: $shoppingcart_tmpl"
<#  shopping cart creation
try {
        $shoppingcart = Invoke-RestMethod -Method 'Post' `
                 -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/carts" `
                 -Headers $headers `
                 -Body $shoppingcart_tmpl  `
                 -ContentType 'application/json'
        write-host "creating shopping cart $shoppingcart "

        $script:NewShoppingCardDBG = "trymessage: $shoppingcart"        
}
catch {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()

        $script:NewShoppingCardDBG = "catchmessage: $ErrResp" 
        write-host "shopping cart creation error: $ErrResp " 
        write-host "error data: $($ErrResp.data)" 

      }
#>

#$ErrResp
do{
  
  try {
    $shoppingcart = Invoke-RestMethod -Method 'Post' `
             -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/carts" `
             -Headers $headers `
             -Body $shoppingcart_tmpl  `
             -ContentType 'application/json'
    write-host "creating shopping cart $shoppingcart "

    $script:NewShoppingCardDBG = "trymessage: $shoppingcart"        
}
catch {
    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()

    $script:NewShoppingCardDBG = "catchmessage: $ErrResp" 
    write-host "shopping cart creation error: $ErrResp " 
    write-host "error data: $($ErrResp.data)" 

  }
  write-host "start wait 10 sec before shopping card will be ready "
  Start-Sleep -s 10 #wait for Shopping cart to be created
 }
 until($shoppingcart.status -match "active") 
 write-host "ShoppingCard: $script:NewShoppingCardDBG "


# 5.	Checkout cart

write-host "start checkout shopping cart"


 if($shoppingcart.status -match "active")
  {   
    $ShoppingcartID = $shoppingcart.id
    do {
        Write-Host "ShoppingCartIDValue: $ShoppingcartID "
        try{
          $shoppingcartCheckOut = Invoke-RestMethod -Method 'Post' `
           -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/carts/$ShoppingcartID/checkout" `
           -Headers $headers `
           -ContentType 'application/json'
           # -Body $shoppingcart_tmpl  `
        
          $script:NewShoppingCardCheckOutDBG = "trymessage: $shoppingcartCheckOut" 
          write-host "ShoppingCartCheckOutTry: $shoppingcartCheckOut"
        
        }
        catch {
            $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
            $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
            $streamReader.Close()
        
            $script:NewShoppingCardCheckOutDBG = "catchmessage: $ErrResp" 
            write-host "ShoppingCartCheckOutCatch: $shoppingcartCheckOut"
        }
        write-host "start wait 10 sec before  shopping cart Checkout will complete "
        Start-Sleep -s 10 #wait for Shopping cart to be created
    }
    until($shoppingcartCheckOut.orders.status -match "completed")
  }
  





  
 #until ($shoppingcartCheckOut.orders.lineitems.subscriptionId)

<#      
try{
      $AzurePlanSubscriptionID = (Invoke-RestMethod -Method 'Get' `
        -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/subscriptions" `
        -Headers $headers `
        -ContentType 'application/json').items.id

      $script:AzurePlanSubscriptionIDDBG = "trymessage: $AzurePlanSubscriptionID"
}
catch{
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
        $streamReader.Close()

        $script:AzurePlanSubscriptionIDDBG = "catchmessage: $ErrResp" 

}
#>


# Get "Azure Plan SubscriptionID" - it is not the same as "Azure Subscription ID" we have to get the Azure Subscription id through separate API request
# Get a list of Azure Entitlements for a subscription
# https://docs.microsoft.com/en-us/partner-center/develop/get-a-list-of-azure-entitlements-for-subscription

#do{
#  write-host "start wait 10 sec before  shopping cart Checkout will complete "
#  Start-Sleep -s 10 #wait for Shopping cart to be created
# }
# while(!$shoppingcartCheckOut) 

#write-host "start wait 60 sec before get AzurePlanSubscriptionID"
#Start-Sleep -s 60

if ($shoppingcartCheckOut.orders.status -match "completed"){
  #$AzurePlanSubscriptionID = $shoppingcartCheckOut.orders.lineitems.subscriptionId
  #$script:AzurePlanSubscriptionIDDBG  = $AzurePlanSubscriptionID
  #write-host "AzurePlanSubscriptionID: $AzurePlanSubscriptionID"
  write-host "ShoppingcartCheckOut: $($shoppingcartCheckOut.orders.Lineitems)"
  #start-sleep -s 60
  write-host "STEP-7 get AzurePlan SubscriptionID"

  $AzurePlanSubscriptionID = $shoppingcartCheckOut.orders.LineItems.subscriptionId

<#
  write-host "test2 try to get subscription"
  Invoke-RestMethod -Method Get `
                    -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/subscriptions" `
                    -Headers $headers `
                    -ContentType 'application/json'


  do {

    try{
        write-host "trying to get Azure Plan SubscriptionID "
        $AzurePlanSubscriptionID = (Invoke-RestMethod -Method 'Get' `
                        -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/subscriptions/" `
                        -Headers $headers `
                        -ContentType 'application/json').items[0].id
        $script:AzurePlanSubscriptionIDDBG = "trymessage: $AzurePlanSubscriptionID"
        write-host "AzurePlanSubscriptionID: $AzurePlanSubscriptionID"
 
    }
    catch{
          #$streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
          #$ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
          #$streamReader.Close()
         
          #$script:AzurePlanSubscriptionIDDBG = "catchmessage: $ErrResp" 
          #write-host "AzurePlanSubscriptionID was not received: $ErrResp"
          write-host "AzurePlanSubscriptionID was not received: $($_.Exception.Response)"
    }
    write-host "start wait 10 sec while AzurePlanSubscriptionID is not ready "
    start-sleep -s 10
  
  } until ($AzurePlanSubscriptionID)
#>
}

if($AzurePlanSubscriptionID) {
  write-host "AzurePlanSubscriptionID: $AzurePlanSubscriptionID"
  write-host "STEP-8 trying to get AzureSubscriptionID"
  do {

      try{
        write-host "trying to get Azure SubscriptionID from AzurePlan SubscriptionID: $AzurePlanSubscriptionID"

        $AzureSubscriptionID = (Invoke-RestMethod -Method Get `
                                                  -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/subscriptions/$AzurePlanSubscriptionID/azureEntitlements" `
                                                  -Headers $headers `
                                                  -ContentType 'application/json').items[0].id
        $script:AzureSubscriptionIDDBG = "trymessage: $AzureSubscriptionID"
        write-host "AzureSubscriptionID: $AzureSubscriptionID"

        }
      catch{
            #$streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
            #$ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
            #$streamReader.Close()
      
            #$script:AzureSubscriptionIDDBG = "catchmessage: $ErrResp" 
            #write-host "AzureSubscriptionID was not received: $ErrResp"
            write-host "AzureSubscriptionID was not received: $($_.Exception.Response)"
          }
          write-host "start wait 10 sec while AzureSubscriptionID is not ready "
          start-sleep -s 10

  } 
  until ($AzureSubscriptionID)
}
#write-host "start wait 120 sec before get AzureSubscriptionID"
#Start-Sleep -s 120 # Azure subscription can be unexisting yet 

  

 
 <#
    try {
   
 }

    catch {
                      $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                      $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                      $streamReader.Close()
    
                      $script:AzureSubscriptionIDDBG  = "catchmessage: $ErrResp" 
    
    }
#>






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
                 -Uri "https://api.partnercenter.microsoft.com/v1/customers/$CustomerTenantID/users " `
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