function New-AzSCustomerResourceProfile {
    param(
    [string]$TenantName,
    #[string]$CustomerAzureTenantID,
    [string]$AZSSubscriptionName,
    [int]$IaaS_CQ_AvailSetCount,
    [int]$IaaS_CQ_CoresCount,
    [int]$IaaS_CQ_VMScaleSetCount,
    [int]$IaaS_CQ_VMMachineCount,
    [int]$IaaS_CQ_STDStorageSize,
    [int]$IaaS_CQ_PREMStorageSize,
    [int]$IaaS_NQ_VNetCount,
    [int]$IaaS_NQ_NicsCount,
    [int]$IaaS_NQ_PIPCount,
    [int]$IaaS_NQ_VNGCount,
    [int]$IaaS_NQ_VNGConCount,
    [int]$IaaS_NQ_LBCount,
    [int]$IaaS_NQ_SGCount,
    [int]$IaaS_SQ_Capacity,
    [int]$IaaS_SQ_SACount,
    [string]$SQLQuotaName,
    [string]$WebQuotaName,
    [string]$AzureTenantId
)
    
    
    #$CustomerAzureTenantID = "$TenantName.onmicrosoft.com"
    $TenantShortName = $TenantName.split('.')[0] 
    $CustomerSubscriptionOwner ="cloudadmin@$TenantName"
    $Location = "azuremsk"
    $ProvSubID = (Get-AzureRmSubscription | Where-Object {$_.Name -eq "Default Provider Subscription"}).id
    $RGName = "ext-$TenantShortName-rg"
    #create ResourceGroup
    New-AzureRmResourceGroup -Location $Location -Name $RGName 
    #set quotas
    
    New-AzsComputeQuota  -Name "ext-$TenantShortName-cq" `
                         -AvailabilitySetCount $IaaS_CQ_AvailSetCount `
                         -CoresCount $IaaS_CQ_CoresCount `
                         -VmScaleSetCount $IaaS_CQ_VMScaleSetCount `
                         -VirtualMachineCount $IaaS_CQ_VMMachineCount `
                         -StandardManagedDiskAndSnapshotSize $IaaS_CQ_STDStorageSize `
                         -PremiumManagedDiskAndSnapshotSize $IaaS_CQ_PREMStorageSize `
                         -location $Location
    New-AzsNetworkQuota  -Name "ext-$TenantShortName-nq" `
                         -MaxVnetsPerSubscription $IaaS_NQ_VNetCount `
                         -MaxNicsPerSubscription $IaaS_NQ_NicsCount `
                         -MaxPublicIpsPerSubscription $IaaS_NQ_PIPCount `
                         -MaxVirtualNetworkGatewaysPerSubscription $IaaS_NQ_VNGCount `
                         -MaxVirtualNetworkGatewayConnectionsPerSubscription $IaaS_NQ_VNGConCount `
                         -MaxLoadBalancersPerSubscription $IaaS_NQ_LBCount `
                         -MaxSecurityGroupsPerSubscription $IaaS_NQ_SGCount `
                         -location $Location
    New-AzsStorageQuota -Name "ext-$TenantShortName-sq" `
                        -CapacityInGb $IaaS_SQ_Capacity `
                        -NumberOfStorageAccounts $IaaS_SQ_SACount `
                        -Location $location
    
    
    $KeyVaultQuotaID    = (Get-AzsKeyVaultQuota).id
    $IaaSComputeQuotaID = (Get-AzsComputeQuota -Name "ext-$TenantShortName-cq").id
    $IaaSNetworkQuotaID = (Get-AzsNetworkQuota -Name "ext-$TenantShortName-nq").id
    $IaaSStorageQuotaID = (Get-AzsStorageQuota -Name "ext-$TenantShortName-sq").id
    $IaaS_Quotas = @()
    $SQL_Quotas  = @()
    $WEB_Quotas  = @()
    $IaaS_Quotas += $KeyVaultQuotaID
    $IaaS_Quotas += $IaaSComputeQuotaID
    $IaaS_Quotas += $IaaSNetworkQuotaID
    $IaaS_Quotas += $IaaSStorageQuotaID
    $sqlDatabaseAdapterNamespace = "Microsoft.SQLAdapter.Admin"
    $sqlLocation= $Location
    #$sqlQuotaName = $SQLQuotaName
    $sqlQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $sqlDatabaseAdapterNamespace,$sqlLocation, $SQLQuotaName
    $SQL_Quotas += $SQLQuotaId
    $appServiceNamespace = "Microsoft.Web.Admin"
    $appServiceLocation = "$Location"
    #$appServiceQuotaNameВ =В $WebQuotaName
    $appServiceQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $appServiceNamespace, $appServiceLocation, $WebQuotaName
    $WEB_Quotas += $appServiceQuotaId
    
    
    #create Plans
    New-AzsPlan  -Name "ext-$TenantShortName-plan-iaas" `
                 -ResourceGroupName $RGName `
                 -QuotaIds  $IaaS_Quotas  `
                 -Location $Location `
                 -DisplayName "ext-$TenantShortName-plan-iaas" 
    New-AzsPlan  -Name "ext-$TenantShortName-plan-sql" `
                 -ResourceGroupName $RGName `
                 -QuotaIds  $SQL_Quotas  `
                 -Location $Location `
                 -DisplayName "ext-$TenantShortName-plan-sql" 
    New-AzsPlan  -Name "ext-$TenantShortName-plan-web" `
                 -ResourceGroupName $RGName `
                 -QuotaIds  $WEB_Quotas `
                 -Location $Location `
                 -DisplayName "ext-$TenantShortName-plan-web" 
    
    $IaaS_PlanID  = (Get-AzsPlan -Name "ext-$TenantShortName-plan-iaas"  -ResourceGroupName $RGName).id
    $SQL_PlanID   = (Get-AzsPlan -Name "ext-$TenantShortName-plan-sql"   -ResourceGroupName $RGName).id
    $WEB_PlanID   = (Get-AzsPlan -Name "ext-$TenantShortName-plan-web"   -ResourceGroupName $RGName).id
    $Plans2Offer = @()
    $Plans2Offer += $IaaS_PlanID
    $Plans2Offer += $SQL_PlanID
    $Plans2Offer += $WEB_PlanID 
    
    #create Offer
    New-AzsOffer  -Name "ext-$TenantShortName-offer" `
                  -DisplayName "ext-$TenantShortName-offer" `
                  -State Private `
                  -BasePlanIds $Plans2Offer `
                  -ResourceGroupName $RGName `
                  -Location $Location
    $OfferID = (Get-AzsManagedOffer -Name "ext-$TenantShortName-offer" -ResourceGroupName $RGName).Id
    
    #create CustomerSubscription
    New-AzsUserSubscription -Owner $CustomerSubscriptionOwner `
                            -OfferId $OfferID `
                            -TenantId $AzureTenantId `
                            -DisplayName $AZSSubscriptionName
 }
    
