function Check-AzsCredentials {

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
                                                                     $CredCheckState ="correct"
                                                                     Write-Host -ForegroundColor green "Account authenticated and correct permissions granted"
                                                                  }
    
    if ((!$AzureRMContextSubName) -and ($AzureRMContextAccount -match $AZSSubscrUserName )) {                                             
                                     Write-Host -ForegroundColor red "Account authenticated but have not assigned correct permissions"
                                 } 
    #>
}

catch [Microsoft.Azure.Commands.Common.Authentication.AadAuthenticationFailedException]  {
         
       $rawmessage = $_.exception.message
       $message = $rawmessage.split(".")[0].split(":").Trim()[1]
       Write-Host -ForegroundColor red -BackgroundColor white     $message
       
      }

finally{
        Clear-Variable AZSSubscrUserName 
        Clear-Variable secretpass
        Clear-Variable AZSCredential
        Clear-AzureRmContext -Force -ErrorAction SilentlyContinue
       }

    }
