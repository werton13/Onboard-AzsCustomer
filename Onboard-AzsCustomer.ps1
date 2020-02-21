Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Font = New-Object System.Drawing.Font("Calibry Light",9,[System.Drawing.FontStyle]::Regular)
$Font4Button = New-Object System.Drawing.Font("Calibry Light",9,[System.Drawing.FontStyle]::Bold)

$form = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 600, 950
    Text          = 'Создание подписки для нового заказчика Azure Stack'
    Topmost       = $true
    BackColor     = "lightcyan"
    Font          = $Font
    
    #ForeColor     = "navy"
    
}
$errorprovider1 = New-Object "System.Windows.Forms.ErrorProvider";
$errorprovider2 = New-Object "System.Windows.Forms.ErrorProvider";
$errorprovider2.Icon = "C:\Temp\correct.ico";
#Helper functions##
function Test-IsEmptyTrim ([string] $field) #to check if field is empty or consist from spaces
{
    if($field -eq $null -or $field.Trim().Length -eq 0)
    {
        return $true    
    }
    
    return $false
}

function Check-AzsCredentials { #to check Azure Stack credentials

    #Function Check-AzsCredentials
    param(
          [string]$AZSUserName,
          [string]$AZSPassword
          )



try {

    Add-AzureRMEnvironment `
                    -Name "AzureStackAdmin" `
                    -ArmEndpoint "https://adminmanagement.azuremsk.ec.mts.ru" `
                    -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
                    -AzureKeyVaultServiceEndpointResourceId https://adminvault.azuremsk.ec.mts.ru
# Set your tenant name
                     $AuthEndpoint = (Get-AzureRmEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
                     $AADTenantName = "iurnvgru.onmicrosoft.com"
                     $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
                     
                     #$AZSSubscrUserName = $TextBox01.Text
                     $AZSSubscrUserName = $AZSUserName                                             
                     #$secretpass    =  ConvertTo-SecureString -String $TextBox02.Text -AsPlainText -Force
                     $secretpass    =  ConvertTo-SecureString -String $AZSPassword -AsPlainText -Force
                     $AZSCredential =  New-Object System.Management.Automation.PSCredential($AZSSubscrUserName, $secretpass)
                     Add-AzureRmAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantId -Credential $AZSCredential -ErrorAction Stop
                     #Login-AzAccount -Environment "AzureStackAdmin" -Credential $AZSCredential
    $AzureRMContextSubName = (Get-AzureRmContext -ListAvailable |? {$_.account -match "$AZSSubscrUserName" }).Subscription.Name
    $AzureRMContextAccount = (Get-AzureRmContext -ListAvailable |? {$_.account -match "$AZSSubscrUserName" }).Account.id
    
    if ($AzureRMContextSubName -eq "Default Provider Subscription"){
                                                                     $Global:CredCheckState ="correct"
                                                                     #Write-Host -ForegroundColor green "Account authenticated and correct permissions granted"
                                                                     $Global:OutputMsg = "Account authenticated and correct permissions granted"
                                                                  }
    
    if ((!$AzureRMContextSubName) -and ($AzureRMContextAccount -match $AZSSubscrUserName )) { 
                                     $Global:CredCheckState ="warning"                                            
                                     #Write-Host -ForegroundColor red "Account authenticated but have not assigned correct permissions"
                                     $Global:OutputMsg = "Account authenticated but have not assigned correct permissions"
                                 } 
    #>
    
}

catch [Microsoft.Azure.Commands.Common.Authentication.AadAuthenticationFailedException]  {
         
       $rawmessage = $_.exception.message
       $message = $rawmessage.split(".")[0].split(":").Trim()[1]
       # Write-Host -ForegroundColor red -BackgroundColor white     $message
       $Global:CredCheckState= "fail"
       $Global:OutputMsg     = $message 
       #return $CredCheckState, $OutputMsg
       
      }

finally{
        Clear-Variable AZSSubscrUserName 
        Clear-Variable secretpass
        Clear-Variable AZSCredential
        Clear-AzureRmContext -Force -ErrorAction SilentlyContinue
       }

}
function New-AzSCustomerResourceProfile {
        param(
            [string]$TenantName,
            [string]$CustomerAzureTenantID,
            [string]$SubscriptionName,
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
            [string]$WebQuotaName                   
            )
        
        
        $CustomerAzureTenantID = "$TenantName.onmicrosoft.com"
        $CustomerSubscriptionOwner ="cloudadmin@$CustomerAzureTenantID"
        $Location          = "azuremsk"
        $ProvSubID         = (Get-AzureRmSubscription | Where-Object { $_.Name -eq "Default Provider Subscription" }).id
        $RGName            = "ext-$TenantName-rg"
        #create ResourceGroup
        New-AzureRmResourceGroup -Location $Location -Name $RGName 
        #set quotas
        
        New-AzsComputeQuota -Name "ext-$TenantName-cq" `
                            -AvailabilitySetCount $IaaS_CQ_AvailSetCount `
                            -CoresCount $IaaS_CQ_CoresCount `
                            -VmScaleSetCount $IaaS_CQ_VMScaleSetCount `
                            -VirtualMachineCount $IaaS_CQ_VMMachineCount `
                            -StandardManagedDiskAndSnapshotSize $IaaS_CQ_STDStorageSize `
                            -PremiumManagedDiskAndSnapshotSize $IaaS_CQ_PREMStorageSize `
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
        #$sqlQuotaName = $SQLQuotaName
        $sqlQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $sqlDatabaseAdapterNamespace, $sqlLocation, $SQLQuotaName
        $SQL_Quotas += $SQLQuotaId
        $appServiceNamespace = "Microsoft.Web.Admin"
        $appServiceLocation = "$Location"
        #$appServiceQuotaName = $WebQuotaName
        $appServiceQuotaId = '/subscriptions/{0}/providers/{1}/locations/{2}/quotas/{3}' -f $ProvSubID, $appServiceNamespace, $appServiceLocation, $WebQuotaName
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
        
}


#$errorprovider2.Icon = "C:\Temp\correct.ico";

#$MyApp = New-Object System.Windows.Forms.Form
#$checkBox1 = New-Object System.Windows.Forms.CheckBox
# checkBox1
#$checkBox1.Location = New-Object System.Drawing.Point(8, 8)
#$checkBox1.Name = 'checkBox1'
#$checkBox1.TabIndex = 0
#$checkBox1.Text = 'Circle'

#Define Label for Azure Active Directory Tenant Name
$Label01 = New-Object “System.Windows.Forms.Label”;
$Label01.Left = 10
$Label01.Top = 15;
$Label01.Width =187;
$label01.Height =40;
$Label01.Text = 'Имя у/з Azure Stack (до @iurnvgru.onmicrosoft.com)';


#Define Label for Azure Active Directory Tenant Name
$Label02 = New-Object “System.Windows.Forms.Label”;
$Label02.Left = 10
$Label02.Top = 55;
$Label02.Width =187;
$label02.Height =40;
$Label02.Text = 'Пароль учетной записи в Azure Stack';

#define Label for Customer Azure Active Directory SubscriptionID
$Label03 = New-Object “System.Windows.Forms.Label”;
$Label03.Left = 10
$Label03.Top = 155;
$Label03.Width =187;
$label03.Height =40;
$Label03.Text = 'Customer Azure Subscription ID';

#define Label for Customer Azure Active Directory Admin Password
$Label04 = New-Object “System.Windows.Forms.Label”;
$Label04.Left = 10
$Label04.Top = 195;
$Label04.Width =187;
$label04.Height =40;
$Label04.Text = "Пароль учетной записи Admin в Azure AD заказчика";



#Define Label for Azure Active Directory Tenant Name
 $Label1 = New-Object “System.Windows.Forms.Label”;
 $Label1.Left = 10
 $Label1.Top = 315;
 $Label1.Width =187;
 $label1.Height =40;
 $Label1.Text = 'Имя тенанта Azure Active Directory (до .onmicrosoft.com)';

 
 #Define Label for Azure Stack Subscription Name
 $Label2 = New-Object “System.Windows.Forms.Label”;
 $Label2.Left = 10;
 $Label2.Top = 355;
 $Label2.Width =187;
 $Label2.Text = 'Azure Stack Subscription Name';

 #create horizontal separator line1
 $hSeparator1 = New-Object “System.Windows.Forms.Label”;
 $hSeparator1.Top =395;
 $hSeparator1.Left =10;
 $hSeparator1.Height =2;
 $hSeparator1.Width =580;
 $hSeparator1.BorderStyle="Fixed3D";

#create horizontal separator line2
$hSeparator2 = New-Object “System.Windows.Forms.Label”;
$hSeparator2.Top =600;
$hSeparator2.Left =300;
$hSeparator2.Height =2;
$hSeparator2.Width =260;
$hSeparator2.BorderStyle="Fixed3D";

#create horizontal separator line3
$hSeparator3 = New-Object “System.Windows.Forms.Label”;
$hSeparator3.Top =685;
$hSeparator3.Left =10;
$hSeparator3.Height =2;
$hSeparator3.Width =550;
$hSeparator3.BorderStyle="Fixed3D";

#create horizontal separator line4
$hSeparator4 = New-Object “System.Windows.Forms.Label”;
$hSeparator4.Top =760;
$hSeparator4.Left =10;
$hSeparator4.Height =2;
$hSeparator4.Width =550;
$hSeparator4.BorderStyle="Fixed3D";
 
#create vertical separator line1
$vSeparator1 = New-Object “System.Windows.Forms.Label”;
$vSeparator1.Top =400;
$vSeparator1.Left =295;
$vSeparator1.Height =200;
$vSeparator1.Width =2;
$vSeparator1.BorderStyle="Fixed3D";

#create vertical separator line2
$vSeparator2 = New-Object “System.Windows.Forms.Label”;
$vSeparator2.Top =605;
$vSeparator2.Left =295;
$vSeparator2.Height =75;
$vSeparator2.Width =2;
$vSeparator2.BorderStyle="Fixed3D";

#create vertical separator line3
$vSeparator3 = New-Object “System.Windows.Forms.Label”;
$vSeparator3.Top =690;
$vSeparator3.Left =295;
$vSeparator3.Height =60;
$vSeparator3.Width =2;
$vSeparator3.BorderStyle="Fixed3D";

#create vertical separator line4
$vSeparator4 = New-Object “System.Windows.Forms.Label”;
$vSeparator4.Top =765;
$vSeparator4.Left =295;
$vSeparator4.Height =60;
$vSeparator4.Width =2;
$vSeparator4.BorderStyle="Fixed3D";

#Define L2bel for Azure Stack IaaS Availability Set Quotes
$Label3 = New-Object “System.Windows.Forms.Label”;
$Label3.Left = 10;
$Label3.Top = 405;
$Label3.Width =187;
$Label3.Text = 'Макс кол-во Availability set';

#Define Label for Azure Stack IaaS vCPUQuotes
$Label4 = New-Object “System.Windows.Forms.Label”;
$Label4.Left = 10;
$Label4.Top = 430;
$Label4.Width =187;
$Label4.Text = 'Макс кол-во vCPU';

#Define Label for Azure Stack IaaS VMScale Sets
$Label5 = New-Object “System.Windows.Forms.Label”;
$Label5.Left = 10;
$Label5.Top = 455;
$Label5.Width =187;
$Label5.Text = 'Макс кол-во VM Scale Sets';

#Define Label for Azure Stack IaaS VMs
$Label6 = New-Object “System.Windows.Forms.Label”;
$Label6.Left = 10;
$Label6.Top = 480;
$Label6.Width =187;
$Label6.Text = 'Макс кол-во Virtual Machines';

#Define Label for Azure Stack IaaS Standard Storage
$Label7 = New-Object “System.Windows.Forms.Label”;
$Label7.Left = 10;
$Label7.Top = 505;
$Label7.Width =187;
$Label7.Height =25;
$Label7.Text = 'Макс объем Managed Disks Standard (Gb)';

#Define Label for Azure Stack IaaS Premium Storage
$Label8 = New-Object “System.Windows.Forms.Label”;
$Label8.Left = 10;
$Label8.Top = 535;
$Label8.Width =187;
$Label8.Height =25;
$Label8.Text = 'Макс объем Managed Disks Premium (Gb)';

 #Define Label for Azure Stack IaaS Virtual Networks Quote
 $Label9 = New-Object “System.Windows.Forms.Label”;
 $Label9.Left = 300;
 $Label9.Top = 405;
 $Label9.Width =187;
 $Label9.Text = 'Макс кол-во Virtual Networks';
 
 #Define Label for Azure Stack IaaS Networks adapters
 $Label10 = New-Object “System.Windows.Forms.Label”;
 $Label10.Left = 300;
 $Label10.Top = 430;
 $Label10.Width =187;
 $Label10.Text = 'Макс кол-во Network adapters';

#Define Label for Azure Stack IaaS Public IP addresses Quote
$Label11 = New-Object “System.Windows.Forms.Label”;
$Label11.Left = 300;
$Label11.Top = 455;
$Label11.Width =187;
$Label11.Text = 'Макс кол-во Public IP';

#Define Label for Azure Stack IaaS Virtual Network Gateways Quote
$Label12 = New-Object “System.Windows.Forms.Label”;
$Label12.Left = 300;
$Label12.Top = 480;
$Label12.Width =187;
$Label12.Height =25;
$Label12.Text = 'Макс кол-во Virtual Network Gateways';

#Define Label for Azure Stack IaaS Virtual Network Gateways Connections Quote
$Label13 = New-Object “System.Windows.Forms.Label”;
$Label13.Left = 300;
$Label13.Top = 510;
$Label13.Width =187;
$Label13.Height =25;
$Label13.Text = 'Макс кол-во Virtual Network Gateway Connections';

#Define Label for Azure Stack IaaS Load Balancers Quote
$Label14 = New-Object “System.Windows.Forms.Label”;
$Label14.Left = 300;
$Label14.Top = 540;
$Label14.Width =187;
$Label14.Height =25;
$Label14.Text = 'Макс кол-во Virtual Load Balancers';

#Define Label for Azure Stack IaaS Load Balancers Quote
$Label15 = New-Object “System.Windows.Forms.Label”;
$Label15.Left = 300;
$Label15.Top = 570;
$Label15.Width =187;
$Label15.Height =25;
$Label15.Text = 'Макс кол-во Network Security Groups';

#Define Label for Azure Stack IaaS Unmanaged Storage Quota
$Label16 = New-Object “System.Windows.Forms.Label”;
$Label16.Left = 300;
$Label16.Top = 615;
$Label16.Width =187;
$Label16.Height =25;
$Label16.Text = 'Макс объем Unmanaged Storage (Gb)';

#Define Label for Azure Stack IaaS Unmanaged Storage Quota
$Label17 = New-Object “System.Windows.Forms.Label”;
$Label17.Left = 300;
$Label17.Top = 645;
$Label17.Width =187;
$Label17.Height =25;
$Label17.Text = 'Макс кол-во Storage Accounts';

#Define L2bel for Azure Stack SQL as Service Quota
$Label18 = New-Object “System.Windows.Forms.Label”;
$Label18.Left = 300;
$Label18.Top = 695;
$Label18.Width =167;
$Label18.Height =25;
$Label18.Text = 'Макс объем ресурсов SQL as Service';

#Define L2bel for Azure Stack Web Apps Quota
$Label19 = New-Object “System.Windows.Forms.Label”;
$Label19.Left = 300;
$Label19.Top = 765;
$Label19.Width =167;
$Label19.Height =30;
$Label19.Text = 'Макс объем ресурсов Web Apps';


#Define TextBox01 for input Azure Stack account name
$TextBox01 = New-Object "System.Windows.Forms.TextBox";
$TextBox01.Left = 210;
$TextBox01.Top = 15;
$TextBox01.width = 200;
$TextBox01.BackColor = "lightblue";


$Textbox01ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Textbox01ToolTip.ShowAlways =$true;
$Textbox01ToolTip.SetToolTip($TextBox01,"Имя входа у/з Azure Stack с полномочиями на управление подписками (до @iurnvgru.onmicrosoft.com)");
$Textbox01ToolTip.InitialDelay = 0;


####################################



$TextBox01.add_Validating({
      
    $_.Cancel = Test-IsEmptyTrim $TextBox01.Text
    if($_.Cancel) {
                   #Display an error message
                   $errorprovider1.SetError($TextBox01, "Please enter your name.");
                  }
    else
                  {
                  #Clear the error message
                  $errorprovider1.SetError($TextBox01, "");
                  $errorprovider2.SetError($TextBox01,"correct")
                  }
    }) 
  
#########################################


#Define TextBox02 for input Azure Stack password
$TextBox02 = New-Object "System.Windows.Forms.MaskedTextBox";
$TextBox02.Left = 210;
$TextBox02.Top = 55;
$TextBox02.width = 200;
$Textbox02.PasswordChar = "*";
$TextBox02.BackColor = "lightblue";

$Testbox02ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox02ToolTip.ShowAlways =$true;
$Testbox02ToolTip.SetToolTip($TextBox02,"Пароль для у/з Azure Stack с полномочиями на управление подписками");
$Testbox02ToolTip.InitialDelay = 0;

$TextBox02.add_Validating({
      
        $_.Cancel = Test-IsEmptyTrim $TextBox02.Text
        if($_.Cancel) {
                       #Display an error message
                       $errorprovider1.SetError($TextBox02, "Please enter your password.");
                      }
        else
                      {
                      #Clear the error message
                      $errorprovider1.SetError($TextBox02, "");
                      $errorprovider2.SetError($TextBox02,"correct")
                      }
        }) 

#Define TextBox03 for print output for Azure Stack credential validation
$TextBox03 = New-Object "System.Windows.Forms.TextBox";
$TextBox03.Left = 210;
$TextBox03.Top = 90;
$TextBox03.width = 200;
$TextBox03.Multiline = $true;
$TextBox03.height = 60;
$TextBox03.BackColor = "lightblue";
$TextBox03.Visible = $False

#Define TextBox04 for Customer Azure Subscription ID
$TextBox04 = New-Object "System.Windows.Forms.TextBox";
$TextBox04.Left = 210;
$TextBox04.Top = 155;
$TextBox04.width = 220;
#$TextBox04.Multiline = $true;
#$TextBox04.height = 60;
$TextBox04.BackColor = "lightblue";

#Define TextBox05 for Customer Azure AD admin password
$TextBox05 = New-Object "System.Windows.Forms.MaskedTextBox";
$TextBox05.Left = 210;
$TextBox05.Top = 195;
$TextBox05.width = 200;
$TextBox05.BackColor = "lightblue";
$Textbox05.PasswordChar = "*";

$Testbox05ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox05ToolTip.ShowAlways =$true;
$Testbox05ToolTip.SetToolTip($TextBox05,"Пароль для у/з admin в Azure AD заказчика");
$Testbox05ToolTip.InitialDelay = 0;


#Define TextBox1 for Label1 - 'Имя тенанта Azure Active Directory (до .onmicrosoft.com)';
$TextBox1 = New-Object “System.Windows.Forms.TextBox”;
$TextBox1.Left = 210;
$TextBox1.Top = 310;
$TextBox1.width = 200;
$TextBox1.BackColor = "lightblue";

$Testbox1ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox1ToolTip.ShowAlways =$true;
$Testbox1ToolTip.SetToolTip($TextBox1,"Имя тенанта Azure Active Directory (до .onmicrosoft.com), которое было выбрано  при  создании заказчика на сайте partner.microsoft.com");
$Testbox1ToolTip.InitialDelay = 0;


#Define TextBox2 for Label2 - 'Azure Stack Subscription Name'
$TextBox2 = New-Object “System.Windows.Forms.TextBox”;
$TextBox2.Left = 210;
$TextBox2.Top = 355;
$TextBox2.width = 200;
$TextBox2.BackColor = "lightblue";

$Testbox2ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox2ToolTip.ShowAlways =$true;
$Testbox2ToolTip.SetToolTip($TextBox2,"Наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com");
$Testbox2ToolTip.InitialDelay = 0;

#Define ComboBox for Label3 'Макс кол-во Availability set'
$CValues=@("1","2","3","4");
$ComboBox1 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox1.DroppedDown = $true;
$ComboBox1.Left = 210;
$ComboBox1.Top = 405;
$ComboBox1.Width =60;
$ComboBox1.BackColor ="lightblue";
$ComboBox1.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter their own vaalues in combobox
$ComboBox1.Items.AddRange($CValues);

#Define ComboBox for Label4 'Макс кол-во vCPU'
$CValues=@(1..32);
$ComboBox2 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox2.DroppedDown = $true;
$ComboBox2.Left = 210;
$ComboBox2.Top = 430;
$ComboBox2.Width =60;
$ComboBox2.BackColor ="lightblue";
$ComboBox2.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox2.Items.AddRange($CValues);

#Define ComboBox for Label5 'Макс кол-во VM Scale Sets'
$CValues=@(1..4);
$ComboBox3 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox3.DroppedDown = $true;
$ComboBox3.Left = 210;
$ComboBox3.Top = 455;
$ComboBox3.Width =60;
$ComboBox3.BackColor ="lightblue";
$ComboBox3.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox3.Items.AddRange($CValues);


#Define ComboBox for Label6 'Макс кол-во Virtual Machines'
$CValues=@(1..16);
$ComboBox4 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox4.DroppedDown = $true;
$ComboBox4.Left = 210;
$ComboBox4.Top = 480;
$ComboBox4.Width =60;
$ComboBox4.BackColor ="lightblue";
$ComboBox4.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox4.Items.AddRange($CValues);

#Define ComboBox for Label7 'Макс объем Managed Disks Standard (Gb)'
$CValues=@(128,256,512,1024,2048,3072,4096,5120,6144,7168,8192,9216,10240,16384,20480);
$ComboBox5 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox5.DroppedDown = $true;
$ComboBox5.Left = 210;
$ComboBox5.Top = 505;
$ComboBox5.Width =60;
$ComboBox5.BackColor ="lightblue";
$ComboBox5.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox5.Items.AddRange($CValues);

#Define ComboBox for Label8 'Макс объем Managed Disks Premium (Gb)'
$CValues=@(128,256,512,1024,2048,3072,4096,5120,6144,7168,8192,9216,10240,16384,20480);
$ComboBox6 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox6.DroppedDown = $true;
$ComboBox6.Left = 210;
$ComboBox6.Top = 535;
$ComboBox6.Width =60;
$ComboBox6.BackColor ="lightblue";
$ComboBox6.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox6.Items.AddRange($CValues);

#Define ComboBox for Label9 'Макс кол-во Virtual Networks'
$CValues=@(1..4);
$ComboBox7 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox7.DroppedDown = $true;
$ComboBox7.Left = 500;
$ComboBox7.Top = 405;
$ComboBox7.Width =60;
$ComboBox7.BackColor ="lightblue";
$ComboBox7.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox7.Items.AddRange($CValues);

#Define ComboBox for Label10 'Макс кол-во Network adapters'
$CValues=@(1..16);
$ComboBox8 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox8.DroppedDown = $true;
$ComboBox8.Left = 500;
$ComboBox8.Top = 430;
$ComboBox8.Width =60;
$ComboBox8.BackColor ="lightblue";
$ComboBox8.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox8.Items.AddRange($CValues);

#Define ComboBox for Label11 'Макс кол-во Public IP'
$CValues=@(1..10);
$ComboBox9 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox9.DroppedDown = $true;
$ComboBox9.Left = 500;
$ComboBox9.Top = 455;
$ComboBox9.Width =60;
$ComboBox9.BackColor ="lightblue";
$ComboBox9.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox9.Items.AddRange($CValues);

#Define ComboBox for Label12 'Макс кол-во Virtual Network Gateways'
$CValues=@(1,2);
$ComboBox10 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox10.DroppedDown = $true;
$ComboBox10.Left = 500;
$ComboBox10.Top = 480;
$ComboBox10.Width =60;
$ComboBox10.BackColor ="lightblue";
$ComboBox10.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox10.Items.AddRange($CValues);

#Define ComboBox for Label13 'Макс кол-во Virtual Network Gateway Connections'
$CValues=@(1,2);
$ComboBox11 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox11.DroppedDown = $true;
$ComboBox11.Left = 500;
$ComboBox11.Top = 510;
$ComboBox11.Width =60;
$ComboBox11.BackColor ="lightblue";
$ComboBox11.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox11.Items.AddRange($CValues);

#Define ComboBox for Label14 'Макс кол-во Virtual Load Balancers'
$CValues=@(1..4);
$ComboBox12 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox12.DroppedDown = $true;
$ComboBox12.Left = 500;
$ComboBox12.Top = 540;
$ComboBox12.Width =60;
$ComboBox12.BackColor ="lightblue";
$ComboBox12.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox12.Items.AddRange($CValues);

#Define ComboBox for Label15 'Макс кол-во Network Security Groups'
$CValues=@(1..10);
$ComboBox13 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox13.DroppedDown = $true;
$ComboBox13.Left = 500;
$ComboBox13.Top = 570;
$ComboBox13.Width =60;
$ComboBox13.BackColor ="lightblue";
$ComboBox13.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox13.Items.AddRange($CValues);

#Define ComboBox for Label16 'Макс объем Unmanaged Storage (Gb)'
$CValues=@(128,256,512,1024,2048,3072,4096,5120,6144,7168,8192,9216,10240,16384,20480);
$ComboBox14 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox14.DroppedDown = $true;
$ComboBox14.Left = 500;
$ComboBox14.Top = 615;
$ComboBox14.Width =60;
$ComboBox14.BackColor ="lightblue";
$ComboBox14.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox14.Items.AddRange($CValues);

#Define ComboBox for Label17  'Макс кол-во Storage Accounts';
$CValues=@(1..10);
$ComboBox15 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox15.DroppedDown = $true;
$ComboBox15.Left = 500;
$ComboBox15.Top = 645;
$ComboBox15.Width =60;
$ComboBox15.BackColor ="lightblue";
$ComboBox15.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox15.Items.AddRange($CValues);

#Define ComboBox for Label18 'Макс объем ресурсов SQL as Service'
$CValues=@("10GB 5DB","10GB 10DBs","100GB 10DBs");
$ComboBox16 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox16.DroppedDown = $true;
$ComboBox16.Left = 470;
$ComboBox16.Top = 696;
$ComboBox16.Width =90;
$ComboBox16.BackColor ="lightblue";
$ComboBox16.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox16.Items.AddRange($CValues);

#Define ComboBox for Label19 'Макс объем ресурсов Web Apps'
$CValues=@("1 App SP","3 App SP","Evaluation");
$ComboBox17 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox17.DroppedDown = $true;
$ComboBox17.Left = 470;
$ComboBox17.Top = 765;
$ComboBox17.Width =90;
$ComboBox17.BackColor ="lightblue";
$ComboBox17.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox17.Items.AddRange($CValues);




#Define OK Button
$CreateButton = New-Object “System.Windows.Forms.Button”;
$CreateButton.Left = 450;
$CreateButton.Top = 850;
$CreateButton.Width = 125;
$CreateButton.Height = 30;
$CreateButton.BackColor = "lightblue";
$CreateButton.Font = $Font4Button;
$CreateButton.Text = “Создать подписку”;

############# This is when you have to close the Form after getting values
$eventHandler = [System.EventHandler]{
                                        
                                        $TextBox01.Text;
                                        $TextBox1.Text;
                                        $TextBox2.Text;
                                        $TextBox3.Text;
########################################--------------------create all stuff here-------------######################################
#   0) Setup all variables from user inputs +
#   1) Login to Azure Stack default provider subscription
#   2) Retrieving billing subscription account password from Azure Stack Key Vault
#   3) Add Azure Environment for Billing Subscription
#   4) Register Customer AAD Subscription ID in Azure Stack billing subscription using 
#   5) Logout from billing subscription
#   6) Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription
#   
#   7) Register Azure Stack Provider AAD Subscription ID to Customer AAD subscription
#   8) Add Azure Environment for  Customer AAD Subscription
#   9) Create 'cloudadmin' account in Customer AAD subscription and assign 'Global Admins' role to this account
#   10) Create Resource Group
#   11) Create Quotas according Subscription Operator inputs
#   12) Create Plans
#   13) Create Offer 
#   14) Create customer AAD tenant subscription to Azure Stack offer
#
#import modules
if (!(get-module -ListAvailable |?{$_.name -match "azuread"})){Write-Host "module not installed"}
install-module azuread
import-module azuread
Import-Module C:\AzureStack\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1
Import-Module C:\AzureStack\AzureStack-Tools-master\Identity\AzureStack.Identity.psm1 

#######################################################################################################################################################
#   ПАРАМЕТРЫ ПОДПИСКИ ДЛЯ СОЗДАНИЯ НОВОГО ПОДПИСЧИКА НИЖЕ
$TenantName            = $TextBox1.text+".onmicrosoft.com"   # -> имя тенанта Azure Active Directory (до @onmicrosoft.com), которое было выбрано  при создании заказчика на сайте partner.microsoft.com
$SubscriptionName      = $TextBox2.Text     # -> наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com
$CustomerAzureSubscrID = $TextBox04.text #not defined yet
$AzureTenantCstmrAdmin      = "admin@$TenantName"
$AzureTenantCstmrAdminPwd   = ConvertTo-SecureString -String $TextBox05.text -AsPlainText -Force #not defined yet
$AzureTenantCstmrCloudAdminPwd   =  $TextBox06.text  #not defined yet # here converto secure  string not performed beause it passed as i to Microsoft.Open.AzureAD.Model.PasswordProfile

#  0) УСТАНОВКА ПАРАМЕТРОВ КВОТ НА ВЫЧИСЛИТЕЛЬНЫЕ РЕСУРСЫ ТЕНАНТА AZURE STACK
#----------------------------------------------------------------------
   
$IaaS_CQ_AvailSetCount   =   [int]$ComboBox1.SelectedValue # 
$IaaS_CQ_CoresCount      =   [int]$ComboBox2.SelectedValue #
$IaaS_CQ_VMScaleSetCount =   [int]$ComboBox3.SelectedValue  #
$IaaS_CQ_VMMachineCount  =   [int]$ComboBox4.SelectedValue  #
$IaaS_CQ_STDStorageSize  =   [int]$ComboBox5.SelectedValue  #
$IaaS_CQ_PREMStorageSize =   [int]$ComboBox6.SelectedValue  #
$IaaS_NQ_VNetCount       =   [int]$ComboBox7.SelectedValue  #
$IaaS_NQ_NicsCount       =   [int]$ComboBox8.SelectedValue  #
$IaaS_NQ_PIPCount        =   [int]$ComboBox9.SelectedValue  #
$IaaS_NQ_VNGCount        =   [int]$ComboBox10.SelectedValue #
$IaaS_NQ_VNGConCount     =   [int]$ComboBox11.SelectedValue #
$IaaS_NQ_LBCount         =   [int]$ComboBox12.SelectedValue     #
$IaaS_NQ_SGCount         =   [int]$ComboBox13.SelectedValue      #
$IaaS_SQ_Capacity        =   [int]$ComboBox14.SelectedValue   #
$IaaS_SQ_SACount         =   [int]$ComboBox15.SelectedValue      #
$SQLQuotaName            =   $ComboBox16.SelectedValue 
$WebQuotaName            =   $ComboBox17.SelectedValue 
#
###################################################################################################################
# 1) Login to Azure Stack default provider subscription
#
# Register an Azure Resource Manager environment that targets your Azure Stack instance. 

    $adminARMEndpoint  = "https://adminmanagement.azuremsk.ec.mts.ru"
    $AuthEndpoint      = (Get-AzureRmEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameAZS  = "iurnvgru.onmicrosoft.com"
    $TenantId          = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantNameAZS)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    Add-AzureRMEnvironment `
                        -Name "AzureStackAdmin" `
                        -ArmEndpoint $adminARMEndpoint`
                        -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
                        -AzureKeyVaultServiceEndpointResourceId "https://adminvault.azuremsk.ec.mts.ru"
    # Set your tenant name
    
    $AZSAdminSubscrUserName  =  $TextBox01.Text                                    
    $AZSAdminSubscrPwd       =  ConvertTo-SecureString -String $TextBox02.Text -AsPlainText -Force
    $AZSAdminCredential      =  New-Object System.Management.Automation.PSCredential($AZSAdminSubscrUserName, $AZSAdminSubscrPwd)
    Add-AzureRmAccount -EnvironmentName "AzureStackAdmin" 
                       -TenantId $TenantId 
                       -Credential $AZSAdminCredential 
                       -ErrorAction Stop

# 2) Retrieving billing subscription account password from Azure Stack Key Vault---#################################
#    we can do this only after we have logged in Azure Stack Default Provider Subscription
    $AzureBillSubscrPwd =  (Get-AzureKeyVaultSecret -VaultName 'ProvKeyVault1' -Name stackbilling).SecretValue
    
# 3) Add Azure Environment for Billing Subscription-------------------------------#################################

    $AuthEndpointBill  = (Get-AzureRmEnvironment -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameBill = "iurmtspjsc.onmicrosoft.com"
    $AzureTenantId     = (invoke-restmethod "$($AuthEndpointBill)/$($AADTenantNameBill)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    $AzureBillCredential = New-Object System.Management.Automation.PSCredential('stack_billing@iurmtspjsc.onmicrosoft.com', $AzureBillSubscrPwd)
    #Add-AzureRmAccount -EnvironmentName "AzureCloud" -TenantId $AzureTenantId -Credential $AzureCredential
    Login-AzAccount -Environment "AzureCloud" -Credential $AzureBillCredential
    #Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureStackadminLnv5" -and $_.Subscription -like "NameOftheSub"}
    #$env = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }

    $AzureContext      = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }
    $AzureStackAdminContext = Get-AzureRmContext -ListAvailable | ?{$_.Environment -match "AzureStackAdmin" }

# 4) -Register Customer AAD Subscription ID in Azure Stack billing subscription using 
set-azurermcontext -Context $AzureContext # actions below are performing in context 'stack_billing@iurmtspjsc.onmicrosoft.com' 

    $BillSubscrID = (Get-AzureRmSubscription).Id
    $BillRG       = "azsReg-azuremsk"
    $RegProv      = "providers/Microsoft.AzureStack/registrations/"
    $AZSRegID     = "AzureStack-ed2f4ae8-4eff-499a-8316-e3dda4bf8a7f"

    $ApiVersion   = "2017-06-01"
    $RegResourceID = "/subscriptions/$BillSubscrID/resourceGroups/$BillRG/$RegProv/$AZSRegID/customerSubscriptions/$CustomerAzureSubscrID"
    New-AzureRmResource -ResourceId $RegResourceID -ApiVersion $ApiVersion 

# 5) Logout from billing subscription
     Disconnect-AzureRmAccount -Username stack_billing@iurmtspjsc.onmicrosoft.com

# 6) Onboard Customer AAD Subscription ID to Azure Stack  provider AAD subscription
set-azurermcontext -Context $AzureStackAdminContext 
    $guestDirectoryTenantToBeOnboarded = $TenantName #"<Tenant_Name>.onmicrosoft.com" 
    $ResourceGroupName = "tenantdirs-rg" 
    $Location = "azuremsk" 
    Register-AzSGuestDirectoryTenant -AdminResourceManagerEndpoint $adminARMEndpoint  `
                                     -DirectoryTenantName $AADTenantNameAZS   `
                                     -GuestDirectoryTenantName $guestDirectoryTenantToBeOnboarded `
                                     -Location $Location  `
                                     -ResourceGroupName $ResourceGroupName 

# 7) Register Azure Stack Provider AAD Subscription ID to Customer AAD subscription
    $AzureTenantCstmrCredential = New-Object System.Management.Automation.PSCredential($AzureTenantCstmrAdmin, $AzureTenantCstmrAdminPwd)
    $tenantARMEndpoint = "https://management.azuremsk.ec.mts.ru" 
        Register-AzSWithMyDirectoryTenant `
        -TenantResourceManagerEndpoint $tenantARMEndpoint `
        -DirectoryTenantName $TenantName  `
        -AutomationCredential $AzureTenantCstmrCredential  `
        -verbose
        Disconnect-AzureRmAccount -Username $AzureTenantCstmrAdmin

# 8) Add Azure Environment for  Customer AAD Subscription 
    $AuthEndpointCstmr    = (Get-AzureRmEnvironment -Name "AzureCloud").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantNameCstmr   = $TenantName
    $AzureTenantId        = (invoke-restmethod "$($AuthEndpointCstmr)/$($AADTenantNameCstmr)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
    #Add-AzureRmAccount -EnvironmentName "AzureCloud" -TenantId $AzureTenantId -Credential $AzureCredential
    Login-AzAccount -Environment "AzureCloud" -Credential $AzureTenantCstmrCredential
    $AzureContext      = Get-AzureRmContext -ListAvailable | ?{$_.Environment -like "AzureCloud" }

# 9) Create 'cloudadmin' account in Customer AAD subscription and assign 'Global Admins' role to this account
set-azurermcontext -Context $AzureContext # actions below are performing in context of admin@%customertenantname%.onmicrosoft.com 
    
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $AzureTenantCstmrCloudAdminPwd
    Connect-AzureAD -Credential $AzureCredential
    $CloudadminUser = New-AzureADUser -DisplayName "cloudadmin" -PasswordProfile $PasswordProfile -UserPrincipalName "cloudadmin@$tenantname" -AccountEnabled $true -MailNickName "cloudadmin"
    #  Add 'cloudadmin' user as  member to an Active Directory role 'Company Administrator'  - it is a PowerShell alias of  'Global Administrator'
    $GlobalAdminRole = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Company Administrator'}
    Add-AzureADDirectoryRoleMember -ObjectId $GlobalAdminRole.ObjectId -RefObjectId $CloudadminUser.ObjectId
    
    Disconnect-AzureRmAccount -Username $AzureTenantCstmrAdmin

#   10) Create Resource Group Quotas Plans and Offers
set-azurermcontext -Context $AzureStackAdminContext 

New-AzSCustomerResourceProfile -TenantName $TenantName `
                               -CustomerAzureTenantID $CustomerAzureTenantID `
                               -SubscriptionName $SubscriptionName `
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
                               -IaaS_NQ_VNGConCount $IaaS_NQ_VNGConCount
                               -IaaS_NQ_LBCount $IaaS_NQ_LBCount `
                               -IaaS_NQ_SGCount $IaaS_NQ_SGCount `
                               -IaaS_SQ_Capacity $IaaS_SQ_Capacity `
                               -IaaS_SQ_SACount $IaaS_SQ_SACount `
                               -SQLQuotaName $SQLQuotaName `
                               -WebQuotaName $WebQuotaName
    $Form.Close();
};
$CreateButton.Add_Click($eventHandler) ;

#Define check cred button

$CheckCredButton = New-Object “System.Windows.Forms.Button”;
$CheckCredButton.Left = 10;
$CheckCredButton.Top = 90;
$CheckCredButton.Width = 125;
$CheckCredButton.Height = 35;
$CheckCredButton.BackColor = "lightblue";
$CheckCredButton.Font = $Font4Button;
$CheckCredButton.Text = “Проверить учетные данные”;

# Test procedure for Check Credential event handler
$СhkCredEventHandler = [System.EventHandler]{
    
    Check-AzsCredentials -AZSUserName $TextBox01.Text -AZSPassword $TextBox02.Text
    $TextBox03.Visible = $true
    #Write-Host "CredCheckState: $CredCheckState"
    #Write-Host "OutputMsg: $OutputMsg"
    if ($global:CredCheckState -eq "correct"){$TextBox03.ForeColor = "green"}
    if ($global:CredCheckState -eq "warning"){$TextBox03.ForeColor = "DarkGoldenRod"}
    if ($global:CredCheckState -eq "fail"){$TextBox03.ForeColor = "red"}
    $TextBox03.Text = $global:OutputMsg
    $TextBox03.ReadOnly =$true



#>
                                                                            };
$CheckCredButton.Add_Click($СhkCredEventHandler) ;

 #Add controls to the Form
#$Form.Controls.Add($checkBox1);
$Form.Controls.Add($CheckCredButton);
$Form.Controls.Add($CreateButton);
$Form.Controls.Add($Label01);
$Form.Controls.Add($Label02);
$Form.Controls.Add($Label03);
$Form.Controls.Add($Label04);
$Form.Controls.Add($Label1);
$Form.Controls.Add($Label2);
$Form.Controls.Add($Label3);
$Form.Controls.Add($Label4);
$Form.Controls.Add($Label5);
$Form.Controls.Add($Label6);
$Form.Controls.Add($Label7);
$Form.Controls.Add($Label8);
$Form.Controls.Add($Label9);
$Form.Controls.Add($Label10);
$Form.Controls.Add($Label11);
$Form.Controls.Add($Label12);
$Form.Controls.Add($Label13);
$Form.Controls.Add($Label14);
$Form.Controls.Add($Label15);
$Form.Controls.Add($Label16);
$Form.Controls.Add($Label17);
$Form.Controls.Add($Label18);
$Form.Controls.Add($Label19);
$Form.Controls.Add($TextBox01);
$Form.Controls.Add($TextBox02);
$Form.Controls.Add($TextBox03);
$Form.Controls.Add($TextBox04);
$Form.Controls.Add($TextBox05);
$Form.Controls.Add($TextBox1);
$Form.Controls.Add($TextBox2);
$Form.Controls.Add($TextBox3);
$form.Controls.Add($ComboBox1);
$form.Controls.Add($ComboBox2);
$form.Controls.Add($ComboBox3);
$form.Controls.Add($ComboBox4);
$form.Controls.Add($ComboBox5);
$form.Controls.Add($ComboBox6);
$form.Controls.Add($ComboBox7);
$form.Controls.Add($ComboBox8);
$form.Controls.Add($ComboBox9);
$form.Controls.Add($ComboBox10);
$form.Controls.Add($ComboBox11);
$form.Controls.Add($ComboBox12);
$form.Controls.Add($ComboBox13);
$form.Controls.Add($ComboBox14);
$form.Controls.Add($ComboBox15);
$form.Controls.Add($ComboBox16);
$form.Controls.Add($ComboBox17);
$form.Controls.Add($hSeparator1);
$form.Controls.Add($hSeparator2);
$form.Controls.Add($hSeparator3);
$form.Controls.Add($hSeparator4);
$form.Controls.Add($vSeparator1);
$form.Controls.Add($vSeparator2);
$form.Controls.Add($vSeparator3);
$form.Controls.Add($vSeparator4);
$Form.ShowDialog()|Out-Null

Return $TextBox1.Text,$TextBox2.Text,$TextBox3.Text