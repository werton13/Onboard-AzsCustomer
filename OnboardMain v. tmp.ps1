#import modules
Import-Module C:\AzureStack\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1
Import-Module C:\AzureStack\AzureStack-Tools-master\Identity\AzureStack.Identity.psm1 
# Register an Azure Resource Manager environment that targets your Azure Stack instance. Get your Azure       Resource Manager endpoint value from your service provider.
    Add-AzureRMEnvironment -Name "AzureStackAdmin" -ArmEndpoint "https://adminmanagement.azuremsk.ec.mts.ru" `
      -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
      -AzureKeyVaultServiceEndpointResourceId https://adminvault.azuremsk.ec.mts.ru
# Set your tenant name
    $AuthEndpoint = (Get-AzureRmEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantName = "iurnvgru.onmicrosoft.com"
    $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
# After signing in to your environment, Azure Stack cmdlets
    # can be easily targeted at your Azure Stack instance.
    Add-AzureRmAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantId
#######################################################################################################################################################
#                ВВЕДИТЕ ПАРАМЕТРЫ ДЛЯ СОЗДАНИЯ НОВОГО ПОДПИСЧИКА НИЖЕ
$TenantName        = "tumocenter"                               # -> имя тенанта Azure Active Directory (до .onmicrosoft.com), которое было выбрано  при создании заказчика на сайте partner.microsoft.com
$SubscriptionName  = "ООО «Платформа креативного обучения»"     # -> наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com


#ВВЕДИТЕ ЗНАЧЕНИЯ ИЗ ЗАЯВКИ НА СОЗДАНИЕ ТЕНАНТА AZURE STACK
   
$IaaSCQAvailSetCount   =   1 #
$IaaSCQCoresCount      =   8 #
$IaaSCQVMScaleSetCount =   2 #
$IaaSCQVMMachineCount  =   4 #
$IaaSCQSTDStorageSize  =   1024 #
$IaaSCQPREMStorageSize =   1024 #
$IaaS_NQ_VNetCount     = 1     #
$IaaS_NQ_NicsCount     = 4     #
$IaaS_NQ_PIPCount      = 1     #
$IaaS_NQ_VNGCount      = 1     #
$IaaS_NQ_VNGConCount   = 1     #
$IaaS_NQ_LBCount       = 2     #
$IaaS_NQ_SGCount       = 5     #
$IaaS_SQ_Capacity      = 512   #
$IaaS_SQ_SACount       = 2     #
$SQLQuotaName = "10GB5DB"
$WebQuotaName = "ext-3AppSP-web"
#Also Available:
# "10GB10DB"
#
#
#                                 КОНЕЦ БЛОКА ВВОДА ПАРАМЕТРОВ
##################################################################################################################
$CustomerAzureTenantID = "$TenantName.onmicrosoft.com"
$CustomerSubscriptionOwner ="cloudadmin@$CustomerAzureTenantID"
$Location          = "azuremsk"
$ProvSubID         = (Get-AzureRmSubscription | Where-Object { $_.Name -eq "Default Provider Subscription" }).id
$RGName            = "ext-$TenantName-rg"
#create ResourceGroup
New-AzureRmResourceGroup -Location $Location -Name $RGName 
#set quotas

New-AzsComputeQuota -Name "ext-$TenantName-cq" `
                    -AvailabilitySetCount $IaaSAvailSetCount `
                    -CoresCount $IaaSCoresCount `
                    -VmScaleSetCount $IaaSVMScaleSetCount `
                    -VirtualMachineCount $IaaSVMMachineCount `
                    -StandardManagedDiskAndSnapshotSize $IaaSSTDStorageSize `
                    -PremiumManagedDiskAndSnapshotSize $IaaSPREMStorageSize `
                    -location $Location
New-AzsNetworkQuota -Name "ext-$TenantName-nq" `
                    -MaxVnetsPerSubscription $IaaS_NQ_VNetCount `
                    -MaxNicsPerSubscription $IaaS_NQ_NicsCount `
                    -MaxPublicIpsPerSubscription $IaaS_NQ_PIPCount `
                    -MaxVirtualNetworkGatewaysPerSubscription $IaaS_NQ_VNGCount `
                    -MaxVirtualNetworkGatewayConnectionsPerSubscription $IaaS_NQ_VNGConCount `
                    -MaxLoadBalancersPerSubscription $IaaS_NQ_LBCount `
                    -MaxSecurityGroupsPerSubscription $IaaS_NQ_SGCount `
                    -location $Location
New-AzsStorageQuota -Name "ext-$TenantName-sq" `
                    -CapacityInGb $IaaS_SQ_Capacity `
                    -NumberOfStorageAccounts $IaaS_SQ_SACount `
                    -Location $location                 


$KeyVaultQuotaID        = (Get-AzsKeyVaultQuota).id
$IaaSComputeQuotaID     = (Get-AzsComputeQuota -Name "ext-$TenantName-cq").id
$IaaSNetworkQuotaID     = (Get-AzsNetworkQuota -Name "ext-$TenantName-nq").id
$IaaSStorageQuotaID     = (Get-AzsStorageQuota -Name "ext-$TenantName-sq").id
$IaaS_Quotas = @()
$SQL_Quotas  = @()
$WEBL_Quotas = @()
$IaaS_Quotas += $KeyVaultQuotaID
$IaaS_Quotas += $IaaSComputeQuotaID
$IaaS_Quotas += $IaaSNetworkQuotaID
$IaaS_Quotas += $IaaSStorageQuotaID 
$sqlDatabaseAdapterNamespace = "Microsoft.SQLAdapter.Admin"
$sqlLocation = $Location
$sqlQuotaName = $SQLQuotaName
$sqlQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $sqlDatabaseAdapterNamespace, $sqlLocation, $sqlQuotaName
$SQL_Quotas += $SQLQuotaId
$appServiceNamespace = "Microsoft.Web.Admin"
$appServiceLocation = "$Location"
$appServiceQuotaName = $WebQuotaName
$appServiceQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $appServiceNamespace, $appServiceLocation, $appServiceQuotaName
$WEBL_Quotas += $appServiceQuotaId


#create Plans
New-AzsPlan -Name "ext-$TenantName-plan-iaas" `
    -ResourceGroupName $RGName `
    -QuotaIds  $IaaS_Quotas  `
    -Location $Location `
    -DisplayName "ext-$TenantName-plan-iaas" 
New-AzsPlan -Name "ext-$TenantName-plan-sql" `
    -ResourceGroupName $RGName `
    -QuotaIds  $SQL_Quotas  `
    -Location $Location `
    -DisplayName "ext-$TenantName-plan-sql" 
New-AzsPlan -Name "ext-$TenantName-plan-web" `
    -ResourceGroupName $RGName `
    -QuotaIds  $WEBL_Quotas  `
    -Location $Location `
    -DisplayName "ext-$TenantName-plan-web" 

$IaaS_PlanID     = (Get-AzsPlan -Name "ext-$TenantName-plan-iaas" -ResourceGroupName $RGName).id
$SQL_PlanID      = (Get-AzsPlan -Name "ext-$TenantName-plan-sql"  -ResourceGroupName $RGName).id
$WEB_PlanID      = (Get-AzsPlan -Name "ext-$TenantName-plan-web"  -ResourceGroupName $RGName).id
$Plans2Offer = @()
$Plans2Offer += $IaaS_PlanID
$Plans2Offer += $SQL_PlanID
$Plans2Offer += $WEB_PlanID 

#create Offer
New-AzsOffer -Name "ext-$TenantName-offer" `
             -DisplayName "ext-$TenantName-offer" `
             -State Private `
             -BasePlanIds $Plans2Offer `
             -ResourceGroupName $RGName `
             -Location $Location
$OfferID = (Get-AzsManagedOffer -Name "ext-$TenantName-offer" -ResourceGroupName $RGName).Id
              
#create CustomerSubscription
New-AzsUserSubscription -Owner $CustomerSubscriptionOwner `
                        -TenantId $CustomerAzureTenantID `
                        -OfferId $OfferID `
                        -DisplayName $SubscriptionName
