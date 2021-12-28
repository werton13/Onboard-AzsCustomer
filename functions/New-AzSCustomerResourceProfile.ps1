function New-AzSCustomerResourceProfile {
    param(
    [string]$TenantName,
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
    [string]$AzureTenantId,
    [string]$location,
    [string]$IaaS,
    [string]$WebApps,
    [string]$SQL,
    [string]$EventsHub,
    [string]$IoT,
    [string]$AKS
    #[string]$CustomerAzureTenantID,
    )
     write-host "inside AzSCustomer Resource Profile"
     write-host "location: $location"
     write-host "IaaS $IaaS"
     write-host "WebApps $WebApps"
     write-host "SQL $SQL"
     write-host "EventsHub $EventsHub"
     write-host "IoT $IoT"
     write-host "AKS $AKS"
     write-host "TenantName: $TenantName"
    
    #$CustomerAzureTenantID = "$TenantName.onmicrosoft.com"
    $TenantShortName = $TenantName.split('.')[0] 
    $CustomerSubscriptionOwner ="cloudadmin@$TenantName"
    #$Location = "azuremsk"
    #$ProvSubID = (Get-AzureRmSubscription | Where-Object {$_.Name -eq "Default Provider Subscription"}).id
    $ProvSubID = (Get-AzSubscription | Where-Object {$_.Name -eq "Default Provider Subscription"}).id
    $RGName = "ext-$TenantShortName-rg"
    write-host "RGName: $RGName"
    #create ResourceGroup
    #New-AzureRmResourceGroup -Location $Location -Name $RGName 
    $RGNameDebug = New-AzResourceGroup -Location $Location -Name $RGName
    write-host "RGNameDebug: $RGNameDebug"
    #set quotas
    if ($IaaS -eq "Enabled") {
        New-AzsComputeQuota -Name "ext-$TenantShortName-cq" `
                            -AvailabilitySetCount $IaaS_CQ_AvailSetCount `
                            -CoresCount $IaaS_CQ_CoresCount `
                            -VmScaleSetCount $IaaS_CQ_VMScaleSetCount `
                            -VirtualMachineCount $IaaS_CQ_VMMachineCount `
                            -StandardManagedDiskAndSnapshotSize $IaaS_CQ_STDStorageSize `
                            -PremiumManagedDiskAndSnapshotSize $IaaS_CQ_PREMStorageSize `
                            -location $Location
        New-AzsNetworkQuota -Name "ext-$TenantShortName-nq" `
                            -MaxVnetsPerSubscription $IaaS_NQ_VNetCount `
                            -MaxNicsPerSubscription $IaaS_NQ_NicsCount `
                            -MaxPublicIpsPerSubscription $IaaS_NQ_PIPCount `
                            -MaxVirtualNetworkGatewaysPerSubscription $IaaS_NQ_VNGCount `
                            -MaxVirtualNetworkGatewayConnectionsPerSubscription $IaaS_NQ_VNGConCount `
                            -MaxLoadBalancersPerSubscription $IaaS_NQ_LBCount `
                            -MaxSecurityGroupsPerSubscription $IaaS_NQ_SGCount `
                            -location $Location
        New-AzsStorageQuota -Name "ext-$TenantShortName-sq" `
                            -CapacityInGb $IaaS_SQ_Capacity `
                            -NumberOfStorageAccounts $IaaS_SQ_SACount `
                            -Location $location

    
    
    
        $IaaSComputeQuotaID = (Get-AzsComputeQuota -Name "ext-$TenantShortName-cq").id
        $IaaSNetworkQuotaID = (Get-AzsNetworkQuota -Name "ext-$TenantShortName-nq").id
        $IaaSStorageQuotaID = (Get-AzsStorageQuota -Name "ext-$TenantShortName-sq").id
        $KeyVaultQuotaID    = (Get-AzsKeyVaultQuota).id

        $IaaS_Quotas = @()
        $IaaS_Quotas += $KeyVaultQuotaID
        $IaaS_Quotas += $IaaSComputeQuotaID
        $IaaS_Quotas += $IaaSNetworkQuotaID
        $IaaS_Quotas += $IaaSStorageQuotaID
        
        New-AzsPlan  -Name "ext-$TenantShortName-plan-iaas" `
                     -ResourceGroupName $RGName `
                     -QuotaIds $IaaS_Quotas `
                     -Location $Location `
                     -DisplayName "ext-$TenantShortName-plan-iaas" 
        $IaaS_PlanID  = (Get-AzsPlan -Name "ext-$TenantShortName-plan-iaas"  -ResourceGroupName $RGName).id
    }
    
    if ($SQL -eq "Enabled") {
        $sqlDatabaseAdapterNamespace = "Microsoft.SQLAdapter.Admin"
        $sqlLocation= $Location
        #$sqlQuotaName = $SQLQuotaName
        $sqlQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $sqlDatabaseAdapterNamespace,$sqlLocation, $SQLQuotaName
        $SQL_Quotas += $SQLQuotaId

        New-AzsPlan  -Name "ext-$TenantShortName-plan-sql" `
                     -ResourceGroupName $RGName `
                     -QuotaIds $SQL_Quotas `
                     -Location $Location `
                     -DisplayName "ext-$TenantShortName-plan-sql" 
        $SQL_PlanID   = (Get-AzsPlan -Name "ext-$TenantShortName-plan-sql"   -ResourceGroupName $RGName).id

    }

    if ($WebApps -eq "Enabled"){
        $WEB_Quotas  = @()
        
        $appServiceNamespace = "Microsoft.Web.Admin"
        $appServiceLocation  = "$Location"
        #$appServiceQuotaNameВ =В $WebQuotaName
        $appServiceQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $appServiceNamespace, $appServiceLocation, $WebQuotaName
        $WEB_Quotas += $appServiceQuotaId
    
        New-AzsPlan  -Name "ext-$TenantShortName-plan-web" `
                 -ResourceGroupName $RGName `
                 -QuotaIds $WEB_Quotas `
                 -Location $Location `
                 -DisplayName "ext-$TenantShortName-plan-web" 
        $WEB_PlanID   = (Get-AzsPlan -Name "ext-$TenantShortName-plan-web"   -ResourceGroupName $RGName).id
    }
    
    #Additional resource providers
    if($EventsHub -eq "Enabled"){}
    if($IoT -eq "Enabled"){}
    if($AKS -eq "Enabled"){}
 
    #create Plans
    
    $Plans2Offer = @()
    if($IaaS_PlanID){$Plans2Offer += $IaaS_PlanID}
    if($SQL_PlanID){$Plans2Offer += $SQL_PlanID}
    if($WEB_PlanID){$Plans2Offer += $WEB_PlanID}

    if($EventsHub_PlanID){ $Plans2Offer += $EventsHub_PlanID}
    if($IoT_PlanID){ $Plans2Offer += $IoT_PlanID}
    if($AKS_PlanID){ $Plans2Offer += $AKS_PlanID}
    
    write-host "Plans2Offer: $Plans2Offer"

        
    #create Offer
    New-AzsOffer  -Name "ext-$TenantShortName-offer" `
                  -DisplayName "ext-$TenantShortName-offer" `
                  -State Private `
                  -BasePlanIds $Plans2Offer `
                  -ResourceGroupName $RGName `
                  -Location $Location
    $OfferID = (Get-AzsManagedOffer -Name "ext-$TenantShortName-offer" -ResourceGroupName $RGName).Id
    
    #create CustomerSubscription
    New-AzsUserSubscription -Owner $CustomerSubscriptionOwner `
                            -OfferId $OfferID `
                            -TenantId $AzureTenantId `
                            -DisplayName $AZSSubscriptionName
    return
 }
    
