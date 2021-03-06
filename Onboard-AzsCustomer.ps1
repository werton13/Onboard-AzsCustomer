#Helper functions##
. .\functions\Test-AzsCredentials.ps1
. .\functions\Get-InputFromForm.ps1
. .\functions\Test-IsEmptyTrim.ps1
. .\functions\New-AzSCustomerResourceProfile.ps1
. .\functions\Test-PSConfig.ps1
#

#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
#import modules - here required dedicated function to check prerequisites

$AzureStackToolsPath = Test-PSConfig
#$AzureStackToolsPath.gettype()

import-module azuread
#Import-Module C:\AzureStack\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1  # here we need too use $path to 'AzureStack-Tools-master' modules
#Import-Module C:\AzureStack\AzureStack-Tools-master\Identity\AzureStack.Identity.psm1  # here we need too use $path to 'AzureStack-Tools-master' modules
Import-Module "$AzureStackToolsPath\Connect\AzureStack.Connect.psm1"  # here we need too use $path to 'AzureStack-Tools-master' modules
Import-Module "$AzureStackToolsPath\Identity\AzureStack.Identity.psm1"  # here we need too use $path to 'AzureStack-Tools-master' modules
#######################################################################################################################################################
# 0)  УСТАНОВКА ПЕРЕМЕННЫХ ИЗ ПАРАМЕТРОВ, ПОЛУЧЕННЫХ ЧЕРЕЗ ФОРМУ ОПЕРАТОРА 

$OperatorFormInputs =    Get-InputFromForm

$TenantName                      = $OperatorFormInputs.TenantName   # -> имя тенанта Azure Active Directory (TenantName@onmicrosoft.com), которое было выбрано  при создании заказчика на сайте partner.microsoft.com
$SubscriptionName                = $OperatorFormInputs.SubscriptionName    # -> наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com
$CustomerAzureSubscrID           = $OperatorFormInputs.CustomerAzureSubscrID#
$AzureTenantCstmrAdmin           = $OperatorFormInputs.AzureTenantCstmrAdmin
$AzureTenantCstmrAdminPwd        = $OperatorFormInputs.AzureTenantCstmrAdminPwd
$AzureTenantCstmrCredential      = New-Object System.Management.Automation.PSCredential($AzureTenantCstmrAdmin, $AzureTenantCstmrAdminPwd)
$AzureTenantCstmrCloudAdminPwd   = $OperatorFormInputs.AzureTenantCstmrCloudAdminPwd #not defined yet # here converto secure  string not performed beause it passed as i to Microsoft.Open.AzureAD.Model.PasswordProfile

# ПАРАМЕТРЫ КВОТ НА ВЫЧИСЛИТЕЛЬНЫЕ РЕСУРСЫ ТЕНАНТА AZURE STACK
#----------------------------------------------------------------------
   
$IaaS_CQ_AvailSetCount   =   $OperatorFormInputs.IaaS_CQ_AvailSetCount  # 
$IaaS_CQ_CoresCount      =   $OperatorFormInputs.IaaS_CQ_CoresCount  #
$IaaS_CQ_VMScaleSetCount =   $OperatorFormInputs.IaaS_CQ_VMScaleSetCount   #
$IaaS_CQ_VMMachineCount  =   $OperatorFormInputs.IaaS_CQ_VMMachineCount  #
$IaaS_CQ_STDStorageSize  =   $OperatorFormInputs.IaaS_CQ_STDStorageSize  #
$IaaS_CQ_PREMStorageSize =   $OperatorFormInputs.IaaS_CQ_PREMStorageSize  #
$IaaS_NQ_VNetCount       =   $OperatorFormInputs.IaaS_NQ_VNetCount      #
$IaaS_NQ_NicsCount       =   $OperatorFormInputs.IaaS_NQ_NicsCount   #
$IaaS_NQ_PIPCount        =   $OperatorFormInputs.IaaS_NQ_PIPCount   #
$IaaS_NQ_VNGCount        =   $OperatorFormInputs.IaaS_NQ_VNGCount #
$IaaS_NQ_VNGConCount     =   $OperatorFormInputs.IaaS_NQ_VNGConCount   #
$IaaS_NQ_LBCount         =   $OperatorFormInputs.IaaS_NQ_LBCount   #
$IaaS_NQ_SGCount         =   $OperatorFormInputs.IaaS_NQ_SGCount    #
$IaaS_SQ_Capacity        =   $OperatorFormInputs.IaaS_SQ_Capacity   #
$IaaS_SQ_SACount         =   $OperatorFormInputs.IaaS_SQ_SACount    #
$SQLQuotaName            =   $OperatorFormInputs.SQLQuotaName 
$WebQuotaName            =   $OperatorFormInputs.WebQuotaName 
#
##############################################################################################################################################
#region 1) Connect to Azure Stack default provider subscription and Retrieving billing subscription account password from Azure Stack Key Vault
#
# Register an Azure Resource Manager environment that targets your Azure Stack instance. 

    $adminARMEndpoint  = "https://adminmanagement.azuremsk.ec.mts.ru"
    #$AuthEndpoint      = (Get-AzureRmEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
    $AuthEndpoint      = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameAZS  = "iurnvgru.onmicrosoft.com"
    $TenantId          = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantNameAZS)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    #Add-AzureRMEnvironment  -Name "AzureStackAdmin" `
    #                        -ArmEndpoint $adminARMEndpoint `
    #                        -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
    #                        -AzureKeyVaultServiceEndpointResourceId "https://adminvault.azuremsk.ec.mts.ru"
    
    #new version for Az modules
    Add-AzEnvironment -Name "AzureStackAdmin" `
                      -ArmEndpoint $adminARMEndpoint `
                      -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
                      -AzureKeyVaultServiceEndpointResourceId "https://adminvault.azuremsk.ec.mts.ru"

    # Set your tenant name
    
    $AZSAdminSubscrUserName  =  "$($OperatorFormInputs.AZSAdminSubscrUserName)@$AADTenantNameAZS"     #  добавить это в блок сбора параметров                               
    $AZSAdminSubscrPwd       =  $OperatorFormInputs.AZSAdminSubscrPwd
    $AZSAdminCredential      =  New-Object System.Management.Automation.PSCredential($AZSAdminSubscrUserName, $AZSAdminSubscrPwd)

    Connect-AzAccount -EnvironmentName "AzureStackAdmin" `
                      -TenantId $TenantId `
                      -Credential $AZSAdminCredential `
                      -ErrorAction Stop
    #Add-AzureRmAccount -EnvironmentName "AzureStackAdmin" `
    #                   -TenantId $TenantId `
    #                   -Credential $AZSAdminCredential `
    #                   -ErrorAction Stop 

#Retrieving billing subscription account password from Azure Stack Key Vault---#################################
#    we can do this only after we have logged in Azure Stack Default Provider Subscription
    #$AzureBillSubscrPwd =  (Get-AzureKeyVaultSecret -VaultName 'ProvKeyVault1' -Name stackbilling).SecretValue
    $AzureBillSubscrPwd =  (Get-AzKeyVaultSecret -VaultName 'ProvKeyVault1' -Name stackbilling).SecretValue
    
 #endregion

#region 2) Add Azure Environment for Billing Subscription-and define contexts------------------------------#################################

    #$AuthEndpointBill  = (Get-AzureRmEnvironment -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AuthEndpointBill  = (Get-AzEnvironment  -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameBill = "iurmtspjsc.onmicrosoft.com"
    $AzureTenantId     = (invoke-restmethod "$($AuthEndpointBill)/$($AADTenantNameBill)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    $AzureBillCredential = New-Object System.Management.Automation.PSCredential('stack_billing@iurmtspjsc.onmicrosoft.com', $AzureBillSubscrPwd)
    #Add-AzureRmAccount -EnvironmentName "AzureCloud" -TenantId $AzureTenantId -Credential $AzureCredential
    
    #Login-AzAccount -Environment "AzureCloud" -Credential $AzureBillCredential
    connect-AzAccount -Environment "AzureCloud" `
                      -Credential $AzureBillCredential

    #Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureStackadminLnv5" -and $_.Subscription -like "NameOftheSub"}
    #$env = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }

    #$AzureContext      = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }
    #$AzureStackAdminContext = Get-AzureRmContext -ListAvailable | ?{$_.Environment -match "AzureStackAdmin" }
    $AzureContext = Get-AzContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }
    $AzureStackAdminContext = Get-AzContext -ListAvailable | ?{$_.Environment -like "AzureStackAdmin" }
#endregion

#region 3) -Register Customer AAD Subscription ID in Azure Stack billing subscription using 
#set-azurermcontext -Context $AzureContext # actions below are performing in context 'stack_billing@iurmtspjsc.onmicrosoft.com' 
Set-AzContext -Context $AzureContext

#    $BillSubscrID = (Get-AzureRmSubscription).Id
    $BillSubscrID = (Get-AzSubscription).id
    $BillRG       = "azsReg-azuremsk"
    $RegProv      = "providers/Microsoft.AzureStack/registrations"
    $AZSRegID     = "AzureStack-ed2f4ae8-4eff-499a-8316-e3dda4bf8a7f"

    $ApiVersion   = "2017-06-01"
    $RegResourceID = "/subscriptions/$BillSubscrID/resourceGroups/$BillRG/$RegProv/$AZSRegID/customerSubscriptions/$CustomerAzureSubscrID"
    #New-AzureRmResource -ResourceId $RegResourceID -ApiVersion $ApiVersion -Force
    New-AzResource -ResourceId $RegResourceID `
                   -ApiVersion $ApiVersion `
                   -Force
#  Here we have to Logout from billing subscription
     #Disconnect-AzureRmAccount -Username stack_billing@iurmtspjsc.onmicrosoft.com
    Disconnect-AzAccount  -Username stack_billing@iurmtspjsc.onmicrosoft.com
#endregion

#region 4) Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription

#set-azurermcontext -Context $AzureStackAdminContext 
 Set-AzContext -Context $AzureStackAdminContext 
    $guestDirectoryTenantToBeOnboarded = $TenantName #"<Tenant_Name>.onmicrosoft.com" 
    $ResourceGroupName = "tenantdirs-rg" 
    $Location = "azuremsk"
     
    Register-AzSGuestDirectoryTenant -AdminResourceManagerEndpoint $adminARMEndpoint  `
                                     -DirectoryTenantName $AADTenantNameAZS   `
                                     -GuestDirectoryTenantName $guestDirectoryTenantToBeOnboarded `
                                     -Location $Location  `
                                     -ResourceGroupName $ResourceGroupName `
                                     -AutomationCredential $AZSAdminCredential
                                
#endregion

#region 5) Register Azure Stack Provider AAD Subscription ID to Customer AAD subscription
# Here we dont use context, because this cmdlet use implicit credential 
    
    $tenantARMEndpoint = "https://management.azuremsk.ec.mts.ru" 
        Register-AzSWithMyDirectoryTenant `
        -TenantResourceManagerEndpoint $tenantARMEndpoint `
        -DirectoryTenantName $TenantName  `
        -AutomationCredential $AzureTenantCstmrCredential  `
        -verbose
    #Disconnect-AzureRmAccount -Username $AzureTenantCstmrAdmin
    Disconnect-AzAccount -Username $AzureTenantCstmrAdmin
#endregion

#region 6) Add Azure Environment for  Customer AAD Subscription to work with Customer Azure AD objects
    #$AuthEndpointCstmr    = (Get-AzureRmEnvironment -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AuthEndpointCstmr    = (Get-AzEnvironment  -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameCstmr   = $TenantName
    $AzureTenantId        = (invoke-restmethod "$($AuthEndpointCstmr)/$($AADTenantNameCstmr)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
    #Add-AzureRmAccount -EnvironmentName "AzureCloud" -TenantId $AzureTenantId -Credential $AzureCredential
    Login-AzAccount -Environment "AzureCloud" -Credential $AzureTenantCstmrCredential
#    $AzureContext      = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" } #!!! ТУТ ВЫДАЕТСЯ 2 КОНТЕКСТА - ЗАВТРА ПРОВЕРИТЬ!!!
    $AzureContext      = Get-AzContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }
#endregion

#region 7) Create 'cloudadmin' account in Customer AAD subscription and assign 'Global Admins' role to this account
#set-azurermcontext -Context $AzureContext # actions below are performing in context of admin@%customertenantname%.onmicrosoft.com 
set-azcontext -Context $AzureContext
    
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

#region 8) Create Resource Group Quotas Plans and Offers
#set-azurermcontext -Context $AzureStackAdminContext
set-azcontext -Context $AzureStackAdminContext  

New-AzSCustomerResourceProfile -TenantName $TenantName  `
                               -AZSSubscriptionName $SubscriptionName `
                               -IaaS_CQ_AvailSetCount $IaaS_CQ_AvailSetCount `
                               -IaaS_CQ_CoresCount $IaaS_CQ_CoresCount `
                               -IaaS_CQ_VMScaleSetCount $IaaS_CQ_VMScaleSetCount `
                               -IaaS_CQ_VMMachineCount $IaaS_CQ_VMMachineCount `
                               -IaaS_CQ_STDStorageSize $IaaS_CQ_STDStorageSize `
                               -IaaS_CQ_PREMStorageSize $IaaS_CQ_PREMStorageSize `
                               -IaaS_NQ_VNetCount  $IaaS_NQ_VNetCount `
                               -IaaS_NQ_NicsCount $IaaS_NQ_NicsCount `
                               -IaaS_NQ_PIPCount  $IaaS_NQ_PIPCount `
                               -IaaS_NQ_VNGCount  $IaaS_NQ_VNGCount `
                               -IaaS_NQ_VNGConCount $IaaS_NQ_VNGConCount `
                               -IaaS_NQ_LBCount $IaaS_NQ_LBCount `
                               -IaaS_NQ_SGCount $IaaS_NQ_SGCount `
                               -IaaS_SQ_Capacity $IaaS_SQ_Capacity `
                               -IaaS_SQ_SACount $IaaS_SQ_SACount `
                               -SQLQuotaName $SQLQuotaName `
                               -WebQuotaName $WebQuotaName `
                               -AzureTenantId $AzureTenantId 
#endregion