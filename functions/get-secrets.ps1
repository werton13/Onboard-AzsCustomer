function Get-Secrets { #to check Azure Stack credentials

    #Function Check-AzsCredentials
    param(
          [string]$AZSUserName,
          [string]$AZSPassword
          )
try {

   $adminARMEndpoint  = "https://adminmanagement.azuremsk.ec.mts.ru"
   Add-AzEnvironment -Name "AzureStackAdmin" `
                      -ArmEndpoint $adminARMEndpoint `
                      -AzureKeyVaultDnsSuffix adminvault.azuremsk.ec.mts.ru `
                      -AzureKeyVaultServiceEndpointResourceId "https://adminvault.azuremsk.ec.mts.ru"
#Set your tenant name
                     $AuthEndpoint  = (Get-AzEnvironment -name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
                     $AADTenantName = "iurnvgru.onmicrosoft.com"
                     #$TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
                     $TenantId = '58ebb353-d0b4-4bb2-a00c-14318306db92'
                     
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

    $AzureRMContextSubName = (Get-AzContext  -ListAvailable |? {$_.account -match "$AZSSubscrUserName" }).Subscription.Name
    $AzureRMContextAccount = (Get-AzContext  -ListAvailable |? {$_.account -match "$AZSSubscrUserName" }).Account.id
    ##new code##
    Connect-MsolService -Credential $AZSCredential
    $date = get-date
    $UsersPWD = Get-MsolUser | Select UserPrincipalName, LastPasswordChangeTimestamp |? {$_.UserPrincipalName -match "$AZSSubscrUserName@*"}
      if (($UsersPWD.LastPasswordChangeTimestamp).addDays(90) -lt $date )
           { $AccountExpirationMsg = "Password for $($UsersPWD.UserPrincipalName.split("@")[0]) expired"}
      else { $AccountExpirationMsg = "Password for $($UsersPWD.UserPrincipalName.split("@")[0]) left $((New-TimeSpan -Start $date -end $($UsersPWD.LastPasswordChangeTimestamp).addDays(90)).Days) days"}
           



    ##end new code ###
    if ($AzureRMContextSubName -eq "Default Provider Subscription"){
                                                                     $Global:CredCheckState ="correct"
                                                                     #Write-Host -ForegroundColor green "Account authenticated and correct permissions granted"
                                                                     
                                                                    # Get Service Principal ApplicationID and Application Secret from KeyVault
                                                                     $ApplicationIdSec     = (Get-AzKeyVaultSecret -VaultName 'ProvKeyVault1' -Name partnerappid).SecretValue
                                                                     $ApplicationIdBin     = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApplicationIdSec)
                                                                     $ApplicationId        = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ApplicationIdBin)

                                                                     $ApplicationSecret    = (Get-AzKeyVaultSecret -VaultName 'ProvKeyVault1' -Name partnerappkey).SecretValue
                                                                     
                                                                     # Get RefreshToken  SecretObject attributes from KeyVault
                                                                     $ActualKVRTokenSecret        = Get-AzKeyVaultSecret -VaultName 'ProvKeyVault1' -Name partnerapprefreshtoken
                                                                     $ActualKVRTokenSecretVersion = $ActualKVRTokenSecret.Version
                                                                     $ActualKVRTokenSecretUpdated = $ActualKVRTokenSecret.Attributes.Updated
                                                                    
                                                                     # Get Actual RefreshToken  Secret value from KeyVault
                                                                     $ActualKVRTokenSec      = (Get-AzKeyVaultSecret -VaultName 'ProvKeyVault1' -Name partnerapprefreshtoken).SecretValue
                                                                     $ActualKVRTokenBin      = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ActualKVRTokenSec)
                                                                     $ActualRefreshToken     = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ActualKVRTokenBin)
                                                                     
                                                                     # Create Service prinipal credentials to get a new Token using actual RefreshToken
                                                                     $credential = New-Object System.Management.Automation.PSCredential($ApplicationId, $ApplicationSecret)
                                                                     
                                                                     #  Get a new Token using actual RefreshToken
                                                                    
                                                                    # $token = New-PartnerAccessToken -ApplicationId $ApplicationId `
                                                                    #                                 -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' `
                                                                    #                                 -Credential $credential `
                                                                    #                                 -RefreshToken $ActualRefreshToken
                                                                    try{
                                                                            $token = New-PartnerAccessToken -ApplicationId $ApplicationId `
                                                                                                            -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' `
                                                                                                            -Credential $credential `
                                                                                                            -RefreshToken $ActualRefreshToken
                                                                    }
                                                                    catch{

                                                                        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                                                                        $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                                                                        $streamReader.Close()
                                                                    
                                                                        $script:NewShoppingCardDBG = "catchmessage: $ErrResp" 
                                                                        write-host "Access token receiving error: $ErrResp " 
                                                                        write-host "error data: $($ErrResp.data)"
                                                                    }


                                                                    # If ActualKVRTokenSecret is older then 5 days -create a new KeyVaultSecret version and put new RefreshToken in to it 
                                                                    if($ActualKVRTokenSecretUpdated -lt $(get-date).AddDays(-5)){

                                                                        # Take a new RefreshToken from a Token and convert it to secure string to put it as new KeyVault Secret Value
                                                                        $NewRefreshToken = ConvertTo-SecureString -String  $token.RefreshToken -AsPlainText -Force
                                                                        
                                                                        # Put new RefreshToken and  put it as new KeyVault Secret Value
                                                                        Set-AzKeyVaultSecret          -VaultName 'ProvKeyVault1' `
                                                                                                      -Name 'partnerapprefreshtoken' `
                                                                                                      -SecretValue $NewRefreshToken

                                                                        # Actual KeyVault Secret version for 'partnerapprefreshtoken' become oudated and should be disabled
                                                                        Set-AzKeyVaultSecretAttribute -VaultName 'ProvKeyVault1' `
                                                                                                      -Name 'partnerapprefreshtoken' `
                                                                                                      -Version $ActualKVRTokenSecretVersion `
                                                                                                      -Enable $false
                                                                        $RefreshTokenUpdateStatus = "RefreshToken KeyVault secret - Updated$(get-date)" # RefreshToken update status for diagnostic message

                                                                    }   else {
                                                                              # RefreshToken update status for diagnostic message
                                                                              $RefreshTokenUpdateStatus = "RefreshToken KeyVault secret - was not updated - last update: $ActualKVRTokenSecretUpdated"
                                                                                                                                    
                                                                             }
                                                                    
                                                                    
                                                                    


                                                                     <# to create a new token  with two factor Authorization
                                                                     $token = New-PartnerAccessToken -ApplicationId 'a3d9619d-bae9-4750-8f74-722d9e56d0ca' `
                                                                                                     -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' `
                                                                                                     -ServicePrincipal -Credential $credential `
                                                                                                     -Tenant '95ea7a0a-8acd-44df-b197-2faaa56ab6cd' -UseAuthorizationCode 
                                                                     #>
                                                                     #create a token from credentials and RefreshToken
                                                                     
                                                                     
                                                                     #$token.RefreshToken | clip
                                                                     #$global:atoken = $token.AccessToken
                                                                     $script:PCenterAccessToken = $token.AccessToken
                                                                     
                                                                     $TokenExpires = $token.ExpiresOn.LocalDateTime
                                                                     if ($token.AccessToken){$TokenRcvState = "Access token received"} else {$TokenRcvState = "Access token not received"}

                                                                     $Global:OutputMsg = "Account authenticated and correct permissions granted ` $AccountExpirationMsg ` $TokenRcvState ` Access token will expire: $TokenExpires ` $RefreshTokenUpdateStatus"






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
<#
finally{
        Clear-Variable AZSSubscrUserName 
        Clear-Variable secretpass
        Clear-Variable AZSCredential
        Clear-AzContext -Force -ErrorAction SilentlyContinue
       }
#>


}
