function New-AZSOnboarding {

param(
        
      [string]$AZSRegionName,
      [string]$AZSAdminSubscrUserName,
      [string]$AZSAdminSubscrPwd,
      [string]$CustomerAzureSubscrID,
      [string]$TenantName,
      [string]$SubscriptionName,
      [string]$AzureTenantCstmrCloudAdminPwd,
      [string]$AzureTenantCstmrAdmin,
      [string]$AzureTenantCstmrAdminPwd,
      [string]$IaaS_CQ_AvailSetCount,
      [string]$IaaS_CQ_CoresCount,
      [string]$IaaS_CQ_VMScaleSetCount,
      [string]$IaaS_CQ_VMMachineCount,
      [string]$IaaS_CQ_STDStorageSize,
      [string]$IaaS_CQ_PREMStorageSize,
      [string]$IaaS_NQ_VNetCount,
      [string]$IaaS_NQ_NicsCount,
      [string]$IaaS_NQ_PIPCount,
      [string]$IaaS_NQ_VNGCount,
      [string]$IaaS_NQ_VNGConCount,
      [string]$IaaS_NQ_LBCount,
      [string]$IaaS_NQ_SGCount,
      [string]$IaaS_SQ_Capacity,
      [string]$IaaS_SQ_SACount,
      [string]$SQLQuotaName,
      [string]$WebQuotaName
    )
write-host "ПАРАМЕТРЫ ПОЛУЧЕНЫ"

write-host "AZSRegionName: $AZSRegionName"
write-host "AZSAdminSubscrUserName: $AZSAdminSubscrUserName"
write-host "AZSAdminSubscrPwd: $AZSAdminSubscrPwd"
write-host "CustomerAzureSubscrID: $CustomerAzureSubscrID"
write-host "TenantName: $TenantName"
write-host "SubscriptionName: $SubscriptionName"
write-host "AzureTenantCstmrCloudAdminPwd: $AzureTenantCstmrCloudAdminPwd"
write-host "AzureTenantCstmrAdmin: $AzureTenantCstmrAdmin"
write-host "AzureTenantCstmrAdminPwd: $AzureTenantCstmrAdminPwd"
write-host "IaaS_CQ_AvailSetCount: $IaaS_CQ_AvailSetCount"
write-host "IaaS_CQ_CoresCount: $IaaS_CQ_CoresCount"
write-host "IaaS_CQ_VMScaleSetCount: $IaaS_CQ_VMScaleSetCount"
write-host "IaaS_CQ_VMMachineCount: $IaaS_CQ_VMMachineCount"
write-host "IaaS_CQ_STDStorageSize: $IaaS_CQ_STDStorageSize"
write-host "IaaS_CQ_PREMStorageSize: $IaaS_CQ_PREMStorageSize"
write-host "IaaS_NQ_VNetCount: $IaaS_NQ_VNetCount"
write-host "IaaS_NQ_NicsCount: $IaaS_NQ_NicsCount"
write-host "IaaS_NQ_PIPCount: $IaaS_NQ_PIPCount"
write-host "IaaS_NQ_VNGCount: $IaaS_NQ_VNGCount"
write-host "IaaS_NQ_VNGConCount: $IaaS_NQ_VNGConCount"
write-host "IaaS_NQ_LBCount: $IaaS_NQ_LBCount"
write-host "IaaS_NQ_SGCount: $IaaS_NQ_SGCount"
write-host "IaaS_SQ_Capacity: $IaaS_SQ_Capacity"
write-host "IaaS_SQ_SACount: $IaaS_SQ_SACount"
write-host "SQLQuotaName: $SQLQuotaName"
write-host "WebQuotaName: $WebQuotaName"

#
##############################################################################################################################################
#region Step-1) Connect to Azure Stack default provider subscription and Retrieving billing subscription account password from Azure Stack Key Vault

write-host "Step-1: Connect to Azure Stack default provider subscription and Retrieving billing subscription account password" -ForegroundColor Yellow
#
# Register an Azure Resource Manager environment that targets your Azure Stack instance. 
    
# Create Capability Profile template
$global:CapabilityProfile = new-object psobject
$global:CapabilityProfile | add-member -membertype NoteProperty -name IaaS -value NotSet
$global:CapabilityProfile | add-member -membertype NoteProperty -name KeyVault -value NotSet
$global:CapabilityProfile | add-member -membertype NoteProperty -name WebApps -value NotSet
$global:CapabilityProfile | add-member -membertype NoteProperty -name SQL -value NotSet
$global:CapabilityProfile | add-member -membertype NoteProperty -name EventsHub -value NotSet
$global:CapabilityProfile | add-member -membertype NoteProperty -name IoT -value NotSet
$global:CapabilityProfile | add-member -membertype NoteProperty -name AKS -value NotSet

#Setting Azure Resource Manager environment  depending of Azure Stack region choosed
write-host -ForegroundColor Cyan "Setting Azure Resource Manager environment parameters depending of Azure Stack region choosed"
    if ($AZSRegionName -eq "azuremsk") {

        Write-Host "$AZSRegionName region choosed" -ForegroundColor Cyan

        #$AzureStackEnvName  = "ASHAdminAzureMSK"
        $adminARMEndpoint   = "https://adminmanagement.azuremsk.ec.mts.ru"
        $AuthEndpoint       = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
        $AADTenantNameAZS   = "iurnvgru.onmicrosoft.com"
        $KeyVaultEndpoint   = "https://adminvault.azuremsk.ec.mts.ru"
        $KeyVaultDnsSuffix  = 'adminvault.azuremsk.ec.mts.ru'
        $VaultName = 'ProvKeyVault1'
        $KeyVaultBillPWDSecretName = 'stackbilling'
        $BillUserName   = 'stack_billing@iurmtspjsc.onmicrosoft.com'
        $ResourceGroupName = "tenantdirs-rg" #region 4) Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription
        $Location = "azuremsk"               #region 4)
        $DefProvSubscriptionID = "e09253ef-400a-4d06-bab5-4c494353c362"
        $BillRG       = "azsReg-azuremsk"
        $RegProv      = "providers/Microsoft.AzureStack/registrations"
        $AZSRegID     = "AzureStack-ed2f4ae8-4eff-499a-8316-e3dda4bf8a7f"

        $tenantARMEndpoint = "https://management.azuremsk.ec.mts.ru" 
      
     
        #setting cloud capabilities:

        $global:CapabilityProfile.IaaS = "Enabled"
        $global:CapabilityProfile.KeyVault = "Enabled"
        $global:CapabilityProfile.WebApps = "Enabled"
        $global:CapabilityProfile.SQL = "Enabled"
        $global:CapabilityProfile.EventsHub = "Disabled"
        $global:CapabilityProfile.IoT = "Disabled"
        $global:CapabilityProfile.AKS = "Disabled"
        
        
    }

    if ($AZSRegionName -eq "msknorth"){

        Write-Host "$AZSRegionName region choosed" -ForegroundColor Cyan
        #$AzureStackEnvName  = "ASHAdminMSKNorth"
        $adminARMEndpoint   = "https://adminmanagement.msknorth.azs.cloud.mts.ru"
        $AuthEndpoint       = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
        $AADTenantNameAZS   = "iurnvgru.onmicrosoft.com"
        $KeyVaultEndpoint   = "https://adminvault.msknorth.azs.cloud.mts.ru"
        $KeyVaultDnsSuffix  = 'adminvault.msknorth.azs.cloud.mts.ru'
        $VaultName = 'ProvKeyVault1'
        $KeyVaultBillPWDSecretName = 'msknorthstackbilling'
        $BillUserName  = 'azsmsk_stamp03_billing@iurmtspjsc.onmicrosoft.com'
        $ResourceGroupName = "tenantdirs-rg" #region 4) Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription
        $Location = "msknorth"               #region 4)
        $DefProvSubscriptionID = "40a42cfd-11a1-45f8-a0d7-4ed1b87855a8"
        $BillRG       = "azsReg-MskNorth"
        $RegProv      = "providers/Microsoft.AzureStack/registrations"
        $AZSRegID     = "MskNorth-e72acbb1-a45e-431e-995b-9d0c25b4a9f4"

        $tenantARMEndpoint = "https://management.msknorth.azs.cloud.mts.ru" 
  
        #setting cloud capabilities:
        
        $global:CapabilityProfile.IaaS      = "Enabled"
        $global:CapabilityProfile.KeyVault  = "Enabled"
        $global:CapabilityProfile.WebApps   = "Disabled"
        $global:CapabilityProfile.SQL       = "Disabled"
        $global:CapabilityProfile.EventsHub = "Disabled"
        $global:CapabilityProfile.IoT       = "Disabled"
        $global:CapabilityProfile.AKS       = "Disabled"
    }
    write-host "new-azsonboarding - outside if"
    write-host "CapabilityProfile: $global:CapabilityProfile"
    write-host "AZSRegID: $AZSRegID "
    $global:CapabilityProfile
    $TenantId           = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantNameAZS)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    #new version for Az modules
    Add-AzEnvironment -Name "AzureStackAdmin" `
                      -ArmEndpoint $adminARMEndpoint `
                      -AzureKeyVaultDnsSuffix $KeyVaultDnsSuffix `
                      -AzureKeyVaultServiceEndpointResourceId $KeyVaultEndpoint

    # Set your tenant name
    
    $AZSAdminSubscrUserName  =  "$AZSAdminSubscrUserName@$AADTenantNameAZS"                           
    $AZSAdminSubscrPwdSec    =  ConvertTo-SecureString $AZSAdminSubscrPwd -AsPlainText -Force
                                                          
    $AZSAdminCredential      =  New-Object System.Management.Automation.PSCredential($AZSAdminSubscrUserName, $AZSAdminSubscrPwdSec)
    write-host "AZSAdminCredential: $AZSAdminCredential"
    Connect-AzAccount -EnvironmentName "AzureStackAdmin" `
                      -TenantId $TenantId `
                      -Credential $AZSAdminCredential `
                      -ErrorAction Stop `
                      -Verbose

write-host "Current AZS context:"
Get-AzContext | fl
#Retrieving billing subscription account password from Azure Stack Key Vault---#################################
#    we can do this only after we have logged in Azure Stack Default Provider Subscription
    #$AzureBillSubscrPwd =  (Get-AzureKeyVaultSecret -VaultName 'ProvKeyVault1' -Name stackbilling).SecretValue
    write-host "Retrieving billing subscription account password from Azure Stack Key Vault"
    write-host "VaultName: $VaultName"
    write-host "KeyVaultBillPWDSecretName: $KeyVaultBillPWDSecretName"
    $AzureBillSubscrPwd =  (Get-AzKeyVaultSecret -VaultName $VaultName -Name $KeyVaultBillPWDSecretName).SecretValue
    
#endregion

#region Step-2) Add Azure Environment for Billing Subscription-and define contexts------------------------------#################################
write-host "Step-2: Add Azure Environment for Billing Subscription-and define contexts" -ForegroundColor Yellow

    $AuthEndpointBill  = (Get-AzEnvironment -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameBill = "iurmtspjsc.onmicrosoft.com"
    $AzureTenantId     = (invoke-restmethod "$($AuthEndpointBill)/$($AADTenantNameBill)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    $AzureBillCredential = New-Object System.Management.Automation.PSCredential($BillUserName , $AzureBillSubscrPwd)

    $AZConnectResult = connect-AzAccount -Environment "AzureCloud" `
                        -Credential $AzureBillCredential
                        -verbose
    write-host "Step-2 Billing Credential AZConnectResult: $AZConnectResult"

    #Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureStackadminLnv5" -and $_.Subscription -like "NameOftheSub"}
    #$env = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }

    #$AzureContext      = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }
    #$AzureStackAdminContext = Get-AzureRmContext -ListAvailable | ?{$_.Environment -match "AzureStackAdmin" }
    $AzureContext = Get-AzContext -ListAvailable | ?{$_.Environment -like "AzureCloud" } #!!! -to check!
    write-host "Step-2 AzureContext: $($AzureContext[0].name )"
    $AzureStackAdminContext = Get-AzContext -ListAvailable | ?{($_.Environment -like "AzureStackAdmin") -and ($_.name -match "$DefProvSubscriptionID")}#!!! - to check!
    write-host "Step-2 AzureStackAdminContext: $($AzureStackAdminContext[0].name )"
#endregion

#region Step-3) -Register Customer AAD Subscription ID in Azure Stack billing subscription using 
# set-azurermcontext -Context $AzureContext # actions below are performing in context 'stack_billing@iurmtspjsc.onmicrosoft.com' 
write-host "Step-3: Register Customer AAD Subscription ID in Azure Stack billing subscription" -ForegroundColor Yellow
write-host "working in AZ Context $($AzureContext[0].name)"
Set-AzContext -Context $AzureContext[0]

#    
    $BillSubscrID = (Get-AzSubscription).id
    write-host "Step-3 BillSubscrID: $BillSubscrID"
    write-host "Step-3 RegProv: $RegProv "
    write-host "Step-3 AZSRegID: $AZSRegID "

    $ApiVersion   = "2017-06-01"
    $RegResourceID = "/subscriptions/$BillSubscrID/resourceGroups/$BillRG/$RegProv/$AZSRegID/customerSubscriptions/$CustomerAzureSubscrID"
    write-host "Step-3 RegResourceID: $RegResourceID"
    
    New-AzResource -ResourceId $RegResourceID `
                   -ApiVersion $ApiVersion `
                   -Force
#  Here we have to Logout from billing subscription
     #Disconnect-AzureRmAccount -Username stack_billing@iurmtspjsc.onmicrosoft.com
    write-host "Logout from billing subscription"
    Disconnect-AzAccount  -Username $BillUserName
#endregion

#region Step-4) Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription
write-host "Step-4: Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription" -ForegroundColor Yellow

write-host "set-azurermcontext -Context AzureStackAdminContext: $($AzureStackAdminContext[0])"
write-host "working in AZ Context $($AzureStackAdminContext[0].name)"
Set-AzContext -Context $AzureStackAdminContext[0]
$guestDirectoryTenantToBeOnboarded = $TenantName #"<Tenant_Name>.onmicrosoft.com" 

write-host "Register AzSGuestDirectory Tenant "     
Register-AzSGuestDirectoryTenant -AdminResourceManagerEndpoint $adminARMEndpoint  `
                                 -DirectoryTenantName $AADTenantNameAZS  `
                                 -GuestDirectoryTenantName $guestDirectoryTenantToBeOnboarded `
                                 -Location $Location  `
                                 -ResourceGroupName $ResourceGroupName `
                                 -AutomationCredential $AZSAdminCredential
                            
#endregion

#region Step-5) Register Azure Stack Provider AAD Subscription ID to Customer AAD subscription
# Here we dont use context, because this cmdlet use implicit credential
write-host "Step-5: Register Azure Stack Provider AAD Subscription ID to Customer AAD subscription" -ForegroundColor Yellow
    $AzureTenantCstmrAdminPwdSec = ConvertTo-SecureString -String $AzureTenantCstmrAdminPwd -AsPlainText -Force
    $AzureTenantCstmrCredential  = New-Object System.Management.Automation.PSCredential($AzureTenantCstmrAdmin, $AzureTenantCstmrAdminPwdSec)
    #$tenantARMEndpoint = "https://management.azuremsk.ec.mts.ru" 
Register-AzSWithMyDirectoryTenant `
    -TenantResourceManagerEndpoint $tenantARMEndpoint `
    -DirectoryTenantName $TenantName `
    -AutomationCredential $AzureTenantCstmrCredential  `
    -verbose
    #Disconnect-AzureRmAccount -Username $AzureTenantCstmrAdmin
Disconnect-AzAccount -Username $AzureTenantCstmrAdmin
#endregion

#region Step-6) Add Azure Environment for  Customer AAD Subscription to work with Customer Azure AD objects
write-host "Step-6: Add Azure Environment for Customer AAD Subscription to work with Customer Azure AD objects" -ForegroundColor Yellow
   
    $AuthEndpointCstmr    = (Get-AzEnvironment -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameCstmr   = $TenantName
    $AzureTenantId        = (invoke-restmethod "$($AuthEndpointCstmr)/$($AADTenantNameCstmr)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
    Login-AzAccount -Environment "AzureCloud" -Credential $AzureTenantCstmrCredential

    $AzureContext      = Get-AzContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }
#endregion

#region Step-7) Create 'cloudadmin' account in Customer AAD subscription and assign 'Global Admins' role to this account
write-host "Step-7: Create 'cloudadmin' account in Customer AAD subscription and assign 'Global Admins' role to this account" -ForegroundColor Yellow
#set-azurermcontext -Context $AzureContext # actions below are performing in context of admin@%customertenantname%.onmicrosoft.com 
set-azcontext -Context $AzureContext[0] #!!!
write-host "working in AZ Context $($AzureContext[0].name)"
    
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $AzureTenantCstmrCloudAdminPwd
    Connect-AzureAD -Credential $AzureTenantCstmrCredential
    $CloudadminUser = New-AzureADUser -DisplayName "cloudadmin" -PasswordProfile $PasswordProfile -UserPrincipalName "cloudadmin@$tenantname" -AccountEnabled $true -MailNickName "cloudadmin"
    #  Add 'cloudadmin' user as  member to an Active Directory role 'Company Administrator'  - it is a PowerShell alias of  'Global Administrator'
    $GlobalAdminRole = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Global Administrator'}
    Add-AzureADDirectoryRoleMember -ObjectId $GlobalAdminRole.ObjectId -RefObjectId $CloudadminUser.ObjectId
    
    #Disconnect-AzureRmAccount -Username $AzureTenantCstmrAdmin
    Disconnect-AzAccount  -Username $AzureTenantCstmrAdmin
#endregion

#region Step-8) Create Azure Stack  Resource Group, Quotas, Plans and Offer
write-host "Step-8: Create Azure Stack  Resource Group, Quotas, Plans and Offer" -ForegroundColor Yellow
$AZContextDebug = Get-AzContext -ListAvailable
write-host "Step-8 AZ Context Available: $AZContextDebug "
write-host "working in AZ Context $($AzureStackAdminContext[0].name)"
set-azcontext -Context $AzureStackAdminContext[0]

#set-azcontext -Context $AzureStackAdminContext
write-host "CapabilityProfile before profile creation: "


$IaaS = "$($global:CapabilityProfile.IaaS)"
$WebApps = "$($global:CapabilityProfile.WebApps)"
$SQL = "$($global:CapabilityProfile.SQL)"
$EventsHub = "$($global:CapabilityProfile.EventsHub)"
$IoT = "$($global:CapabilityProfile.IoT)"
$AKS = "$($global:CapabilityProfile.AKS)" 
write-host "New-AZSOnboarding Step-8 AKS: $AKS"
write-host "New-AZSOnboarding Step-8 TenantName: $TenantName"
write-host "New-AZSOnboarding Step-8 get-type: $($TenantName.GetType())"
$OnboardTenantName = $TenantName #just to ttest

New-AzSCustomerResourceProfile -location $AZSRegionName `
                               -TenantName $OnboardTenantName `
                               -AZSSubscriptionName $SubscriptionName `
                               -IaaS_CQ_AvailSetCount $IaaS_CQ_AvailSetCount `
                               -IaaS_CQ_CoresCount $IaaS_CQ_CoresCount `
                               -IaaS_CQ_VMScaleSetCount $IaaS_CQ_VMScaleSetCount `
                               -IaaS_CQ_VMMachineCount $IaaS_CQ_VMMachineCount `
                               -IaaS_CQ_STDStorageSize $IaaS_CQ_STDStorageSize `
                               -IaaS_CQ_PREMStorageSize $IaaS_CQ_PREMStorageSize `
                               -IaaS_NQ_VNetCount $IaaS_NQ_VNetCount `
                               -IaaS_NQ_NicsCount $IaaS_NQ_NicsCount `
                               -IaaS_NQ_PIPCount $IaaS_NQ_PIPCount `
                               -IaaS_NQ_VNGCount $IaaS_NQ_VNGCount `
                               -IaaS_NQ_VNGConCount $IaaS_NQ_VNGConCount `
                               -IaaS_NQ_LBCount $IaaS_NQ_LBCount `
                               -IaaS_NQ_SGCount $IaaS_NQ_SGCount `
                               -IaaS_SQ_Capacity $IaaS_SQ_Capacity `
                               -IaaS_SQ_SACount $IaaS_SQ_SACount `
                               -SQLQuotaName $SQLQuotaName `
                               -WebQuotaName $WebQuotaName `
                               -AzureTenantId $AzureTenantId `
                               -IaaS $IaaS `
                               -WebApps $WebApps `
                               -SQL $SQL `
                               -EventsHub $EventsHub `
                               -IoT $IoT `
                               -AKS $AKS
#endregion
# need to add condition to success completion notification 
write-host -ForegroundColor Green -BackgroundColor White "Creation of Azure Stack Subscription for customer $SubscriptionName is complete."
}

