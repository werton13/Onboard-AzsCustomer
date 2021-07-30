  $adminARMEndpoint  = "https://adminmanagement.azuremsk.ec.mts.ru"
function Test-AzsCredentials { #to check Azure Stack credentials

    #Function Check-AzsCredentials
    param(
          [string]$AZSUserName,
          [string]$AZSPassword
          )
try {


   Add-AzEnvironment -Name "AzureStackAdmin" `
                      -ArmEndpoint $adminARMEndpoint `
                      -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
                      -AzureKeyVaultServiceEndpointResourceId "https://adminvault.azuremsk.ec.mts.ru"
#Set your tenant name
                     $AuthEndpoint      = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
                     $AADTenantName = "iurnvgru.onmicrosoft.com"
                     $TenantId      = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
                     
                     #$AZSSubscrUserName = $TextBox01.Text
                     $AZSSubscrUserName = "$AZSUserName@iurnvgru.onmicrosoft.com"                                          
                     #$secretpass    =  ConvertTo-SecureString -String $TextBox02.Text -AsPlainText -Force
                     $secretpass    =  ConvertTo-SecureString -String $AZSPassword -AsPlainText -Force
                     $AZSCredential =  New-Object System.Management.Automation.PSCredential($AZSSubscrUserName, $secretpass)
 #                   Add-AzureRmAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantId -Credential $AZSCredential -ErrorAction Stop
    Connect-AzAccount -EnvironmentName "AzureStackAdmin" `
                      -TenantId $TenantId `
                      -Credential $AZSCredential `
                      -ErrorAction Stop

                     #Login-AzAccount -Environment "AzureStackAdmin" -Credential $AZSCredential
    $AzureRMContextSubName = (Get-AzContext  -ListAvailable |? {$_.account -match "$AZSSubscrUserName" }).Subscription.Name
    $AzureRMContextAccount = (Get-AzContext  -ListAvailable |? {$_.account -match "$AZSSubscrUserName" }).Account.id
    ##new code##
    Connect-MsolService -Credential $AZSCredential
    $date = get-date
    $UsersPWD = Get-MsolUser |Select UserPrincipalName, LastPasswordChangeTimestamp |? {$_.UserPrincipalName -match "$AZSSubscrUserName@*"}
      if (($UsersPWD.LastPasswordChangeTimestamp).addDays(90) -lt $date )
           { $AccountExpirationMsg = "Password for $($UsersPWD.UserPrincipalName.split("@")[0]) expired"}
      else { $AccountExpirationMsg = "Password for $($UsersPWD.UserPrincipalName.split("@")[0]) left $((New-TimeSpan -Start $date -end $($UsersPWD.LastPasswordChangeTimestamp).addDays(90)).Days) days"}
           



    ##end new code ###
    
    if ($AzureRMContextSubName -eq "Default Provider Subscription"){
                                                                     $Global:CredCheckState ="correct"
                                                                     #Write-Host -ForegroundColor green "Account authenticated and correct permissions granted"
                                                                     $Global:OutputMsg = "Account authenticated and correct permissions granted ` $AccountExpirationMsg "
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
        Clear-AzContext -Force -ErrorAction SilentlyContinue
       }

}