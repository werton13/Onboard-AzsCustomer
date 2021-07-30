function test-psconfig {

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

. .\functions\get-scriptartifacts.ps1
function Print-PSConfigState {
param (
       [System.Windows.Forms.TextBox]$TextBoxName,
       [String]$AzureStackToolsPath
       )

#create summary and put it to the textbox



$PowershellGetState   = (Get-Module -Name powershellget -ListAvailable) | select name,version
$PowershellGetVersion = $PowershellGetState.version.ToString()
$NugetState = (Get-PackageProvider -Name nuget -ListAvailable -ErrorAction SilentlyContinue) | select name,version

if ($NugetState){$NugetVersion = $NugetState.Version.ToString()} else {$NugetVersion = "Not installed"}
$PSGalleryState = (get-PSRepository -Name "PSGallery")| select name,InstallationPolicy


if (Get-Module -Name azurerm -ListAvailable){
    $AzureRMProfileState = get-AzureRmProfile  | select Profilename
    $AzureRMState        = get-Module -Name AzureRM.BootStrapper -ListAvailable |select name,version
    }
else{
    $AzureRMProfileState = "Not installed" 
    $AzureRMState        = "Not installed"
    }

if (Get-Module -Name "AzureStack" -ListAvailable){
    $AzureStackModuleState = Get-Module -Name "AzureStack" -ListAvailable |select name,version
    }
else{
    $AzureStackModuleState = "Not installed"
    }

if (Get-Module -Name "azuread" -ListAvailable){
    $AzureModuleState = Get-Module -Name "azuread" -ListAvailable |select name,version
    }
else{
    $AzureModuleState = "Not installed"
    }

#$AzureModuleState = Get-Module -Name "azuread" -ListAvailable |select name,version
if (Test-Path -PathType Container -Path "$AzureStackToolsPath") {
    $AzureStackToolsState = gci $AzureStackToolsPath | select fullname
    $AzureStackToolsDir = Get-Item $AzureStackToolsPath | select fullname,creationtime
    $AzureStackToolsList = ""
    $AzureStackToolsState | % { $AzureStackToolsList += "`n                              $($_.fullname.tostring())"}#29spaces
    }
else{
    $AzureStackToolsDir = "Not exist"
    $AzureStackToolsList = ""
    }


#Print summary to textbox
$TextBoxName.Text =""
$TextBoxName.AppendText("`r`n PowershellGetVersion                            :$($PowershellGetVersion.tostring())")
$TextBoxName.AppendText("`r`n NugetVersion                                         :$($NugetVersion.tostring())")
$TextBoxName.AppendText("`r`n PSGallery                                               :$($PSGalleryState.InstallationPolicy.tostring())")
if ($AzureRMState -match "Not installed"){
    $TextBoxName.AppendText("`r`n AzureRM.BootStrapper                          :$AzureRMState")
    }
else{
    $TextBoxName.AppendText("`r`n AzureRM.BootStrapper                          :$($AzureRMState.Version.tostring())")
    }

if ($AzureRMProfileState -match "Not installed"){
    $TextBoxName.AppendText("`r`n AzureRMProfile                                      :$AzureRMProfileState")
    }
else{
    $TextBoxName.AppendText("`r`n AzureRMProfile                                      :$($AzureRMProfileState.ProfileName.tostring())")
    }
#$TextBoxName.AppendText("`r`n AzureRM.BootStrapper                          :$($AzureRMState.Version.tostring())")
#$TextBoxName.AppendText("`r`n AzureRMProfile                                      :$($AzureRMProfileState.ProfileName.tostring())")
if ($AzureStackModuleState -match "Not installed"){
    $TextBoxName.AppendText("`r`n AzureStackModuleVersion                     :$AzureStackModuleState")
    }
else{
    $TextBoxName.AppendText("`r`n AzureStackModuleVersion                     :$($AzureStackModuleState.Version.tostring())")
    }

if ($AzureModuleState -match "Not installed"){
    $TextBoxName.AppendText("`r`n AzureADModuleVersion                         :$AzureModuleState")
    }
else{
    $TextBoxName.AppendText("`r`n AzureADModuleVersion                         :$($AzureModuleState.Version.tostring())")
    }

#$TextBoxName.AppendText("`r`n AzureStackModuleVersion                     :$($AzureStackModuleState.Version.tostring())")

if ($AzureStackToolsDir -match "Not exist"){
    $TextBoxName.AppendText("`r`n AzureStackToolsPath                             :$AzureStackToolsDir")
    }
else{
    $TextBoxName.AppendText("`r`n AzureStackToolsPath                             :$($AzureStackToolsDir.FullName.tostring())")
    $TextBoxName.AppendText("`r`n AzureStackToolsCreationTime               :$($AzureStackToolsDir.creationtime.tostring())")
    }
#$TextBoxName.AppendText("`r`n AzureStackToolsPath                             :$($AzureStackToolsDir.FullName.tostring())")

if ($AzureStackToolsState){
    $AzureStackToolsState | %{
    $TextBoxName.AppendText("`r`n                                                   $($_.fullname.tostring())")



}
} else {
        if ($AzureStackToolsDir -match "Not exist") {
            $TextBoxName.AppendText("`r`n $AzureStackToolsPath         : Not exist!")
            }
        else{
             $TextBoxName.AppendText("`r`n $($AzureStackToolsDir.FullName.tostring())         : is EMPTY!")
            }
       
       }



}
function print-actionresult {
    param (
            [System.Windows.Forms.TextBox]$TextBoxName,
            [String]$Message
          )
    $timestamp = Get-Date -UFormat "%m/%d %T"
    #write-host "$timestamp : $Message"
    $TextBoxName.Text =""
    $TextBoxName.AppendText("`r`n $Message")
}
#. .\Get-InputFromForm.ps1
<#
$PSConfigState = New-Object PSObject
$PSConfigState |add-member -type NoteProperty -Name AzureRMProfileState -Value $null
$PSConfigState |add-member -type NoteProperty -Name AzureRMState -Value $null
$PSConfigState |add-member -type NoteProperty -Name AzureStackModuleState -Value $null
$PSConfigState |add-member -type NoteProperty -Name AzureModuleState -Value $null
$PSConfigState |add-member -type NoteProperty -Name AzureStackToolsState -Value $null
#>

#Download icons

get-scriptartifacts

#$PSConfigForm = New-Object System.Windows.Forms.Form
$PSConfigForm = New-Object Windows.Forms.Form
$PSConfigForm.Width =820
$PSConfigForm.Height =800

$Font4Button = New-Object System.Drawing.Font("Calibry",11,[System.Drawing.FontStyle]::Regular)
$Font4Labels = New-Object System.Drawing.Font("Calibry",10,[System.Drawing.FontStyle]::Regular)
$Font4Labels2 = New-Object System.Drawing.Font("Calibry",9,[System.Drawing.FontStyle]::Regular)
$Font4Headers = New-Object System.Drawing.Font("Calibry",16,[System.Drawing.FontStyle]::Regular)

#Define Label for tool name
$Label01 = New-Object “System.Windows.Forms.Label”;
$Label01.Left = 20
$Label01.Top = 15;
$Label01.Width =500;
$label01.Height =40;
$Label01.Font =$Font4Headers
$Label01.ForeColor = "LightSeaGreen"
$Label01.Text = '#CloudMTS Azure Stack Tenants onboard tool';

#Define Label for tool declaration
$Label02 = New-Object “System.Windows.Forms.Label”;
$Label02.Left = 20
$Label02.Top = 65;
$Label02.Width =400;
$label02.Height =60;
$Label02.Font = $Font4Labels
#$Label02.ForeColor = "DarkGreen"
$Label02.Text = "This tool is depend from several PowerShell Modules, please press 'Check System PowerShell Configuration State' button to ensure if all required modules are installed";

#Define Label for tool permission declaration
$Label03 = New-Object “System.Windows.Forms.Label”;
$Label03.Left = 430
$Label03.Top = 65;
$Label03.Width =360;
$label03.Height =60;
$Label03.Font = $Font4Labels
$Label03.ForeColor = "DarkRed"
$Label03.Text = "Please NOTE: Local administrator privilegues are required for Powershell modules installation - please run this script from elevated shell if modules installation required";

#Define Label for Azure Stack Tools Path
$Label04 = New-Object “System.Windows.Forms.Label”;
$Label04.Left = 460
$Label04.Top = 125;
$Label04.Width =230;
$label04.Height =20;
$Label04.Font = $Font4Labels
#$Label04.ForeColor = "DarkRed"
$Label04.Text = "Please enter Azure Stack Tools Path";

#Define Label for Azure Stack Tools Path
$Label05 = New-Object “System.Windows.Forms.Label”;
$Label05.Left = 460
$Label05.Top = 190;
$Label05.Width =255;
$label05.Height =30;
$Label05.Font = $Font4Labels
#$Label05.ForeColor = "DarkRed"
$Label05.Text = "This path will be used to install the Azure Stack Tools if they are not installed";

$TextBox00 = New-Object "System.Windows.Forms.TextBox";
$TextBox00.Top = 200;
$TextBox00.Left = 20;
$TextBox00.multiline = $true;
$TextBox00.Width = 420
$TextBox00.Height =400
$TextBox00.Visible = $False

$TextBox01 = New-Object "System.Windows.Forms.TextBox";
$TextBox01.Top = 200;
$TextBox01.Left = 20;
$TextBox01.multiline = $true;
$TextBox01.Width = 420
$TextBox01.Height =400
$TextBox01.ForeColor = "DarkGreen"
$TextBox01.Visible = $False

$TextBox02 = New-Object "System.Windows.Forms.TextBox";
$TextBox02.Top = 165;
$TextBox02.Left = 460;
$TextBox02.Height =20
$TextBox02.Width = 235
$TextBox02.Font = $Font4Labels
$TextBox02.ForeColor = "Navy"
$TextBox02.Visible = $True
$TextBox02.Text = "S:\AzureStack-Tools-az"

### Experimental feature
#$button = $browse = $PSConfigForm = 0
[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$browse = new-object system.windows.Forms.FolderBrowserDialog
$browse.RootFolder = [System.Environment+SpecialFolder]'MyComputer'
$browse.ShowNewFolderButton = $false
#$browse.selectedPath = "C:\"
$browse.Description = "Choose a directory"

$BrowsButton = New-Object system.Windows.Forms.Button
$BrowsButton.Text = "Choose Directory"
$BrowsButton.Font   = $Font4Button
$BrowsButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$BrowsButton.FlatAppearance.BorderSize = 1;
$BrowsButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$BrowsButton.BackColor = [System.Drawing.Color]::aliceblue 
$BrowsButton.Add_Click({$browse.ShowDialog()})
$BrowsButton.left = 705
$BrowsButton.top = 125
$BrowsButton.Width  = 80
$BrowsButton.Height = 60

#$browse.SelectedPath
#$text
###--end experimental feature


$Button01 = New-Object “System.Windows.Forms.Button”;
$Button01.Width  = 200
$Button01.Height = 60
$Button01.Left   = 20;
$Button01.Top    = 125;
$Button01.Text   = "Check System PowerShell Configuration State";
$button01.Font   = $Font4Button
$Button01.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$Button01.FlatAppearance.BorderSize = 1;
$Button01.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$Button01.BackColor = [System.Drawing.Color]::aliceblue 


$Button02 = New-Object “System.Windows.Forms.Button”;
$Button02.Width  = 200
$Button02.Height = 60
$Button02.Left   = 240;
$Button02.Top    = 125;
$Button02.Text   = "Check and Install PowerShell Requirements";
$button02.Font   = $Font4Button
$Button02.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$Button02.FlatAppearance.BorderSize = 1;
$Button02.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$Button02.BackColor = [System.Drawing.Color]::aliceblue  

$Button03 = New-Object “System.Windows.Forms.Button”;
$Button03.Width  = 200
$Button03.Height = 100
$Button03.Left   = 460;
$Button03.Top    = 235;
$Button03.Text   = "Open Azure Stack tenant registration form";
$button03.Font   = $Font4Button
$Button03.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$Button03.FlatAppearance.BorderSize = 1;
$Button03.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$Button03.BackColor = [System.Drawing.Color]::aliceblue    

# Test procedure set path via brows button event handler
$BrowsButtonEventHandler = [System.EventHandler]{
    $TextBox02.Text = $browse.SelectedPath

}

# Test procedure for Check OS Powershell Configuration event handler
$СhkPSConfigEventHandler = [System.EventHandler]{
    $AzureStackToolsPath = $TextBox02.Text
    $TextBox00.Visible = $True       
    $AzSPSCurVersion     = @(1,8,1)
    #$AzureStackToolsPath = "c:\temp\AzureStack-Tools-master"
    Print-PSConfigState -TextBoxName $TextBox00 -AzureStackToolsPath $AzureStackToolsPath


}

# Test procedure for Check Powershell Prerequisites event handler
$СhkandFixcPSConfigEventHandler = [System.EventHandler]{
    $TextBox00.Visible = $false       
    $TextBox01.Visible = $True
    $TextBox01.ReadOnly = $True
    $AzSPSCurVersion     = @(1,8,1)
    #$AzureStackToolsPath = "c:\temp\AzureStack-Tools-master"
    $AzureStackToolsPath = $TextBox02.Text
    $AzureStackToolsURL  = "https://github.com/Azure/AzureStack-Tools/archive/master.zip"

#here must be internet check block

#Check if PowerShellGet is installed
if(!(Get-Module -Name powershellget -ListAvailable).version){
     write-host "powershellget module is not installed --trying to install"
     print-actionresult -TextBoxName $TextBox01 -Message "powershellget module is not installed --trying to install"
     Install-module -Name PowerShellGet -Force
     if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "powershellget module  installation complete"}
     else {print-actionresult -TextBoxName $TextBox01 -Message "powershellget module  installation FAILED"}
     }

#Check if NuGet installed
if(!(Get-PackageProvider -Name nuget -ListAvailable -ErrorAction SilentlyContinue).version){
     write-host "NuGet package provider is not installed --trying to install"
     print-actionresult -TextBoxName $TextBox01 -Message "NuGet package provider is not installed --trying to install"
     Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force  
     if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "NuGet package provider installation complete"}
     else {print-actionresult -TextBoxName $TextBox01 -Message "NuGet package provider  installation FAILED"}
    }
 

Import-Module -Name PackageManagement -ErrorAction Stop
#Check if   the repository "PSGallery" isn't registered
if(!(Get-PSRepository -Name "PSGallery")){     
     write-host "the repository 'PSGallery' isn't registered --trying to register"
     print-actionresult -TextBoxName $TextBox01 -Message "PSGallery' isn't registered --trying to register"     
     Register-PSRepository -Default
     if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "PSGallery registration complete"}
     else {print-actionresult -TextBoxName $TextBox01 -Message "PSGallery registration  FAILED"}
     Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
     }

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
#Check if AzureRm and Azs modules are installed
if(!(Get-Module -Name AzureRM.BootStrapper -ListAvailable).Version){    
    write-host "'AzureRM.BootStrappe' module is not installed --trying to install"
    print-actionresult -TextBoxName $TextBox01 -Message "'AzureRM.BootStrappe' module is not installed --trying to install"  
    Install-Module -Name AzureRM.BootStrapper -Force -Confirm:$false }
    if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureRM.BootStrapper' module installation complete"}
    else {print-actionresult -TextBoxName $TextBox01 -Message "AzureRM.BootStrapper' module installation   FAILED"}
#Check AzureRm Profile version
if((get-AzureRmProfile).profilename -notmatch "2019-03-01-hybrid" ){
    write-host "AzureRM profile version mismathch -- trying to  Install and import the API Version Profile required by Azure Stack Hub into the current PowerShell session"
    print-actionresult -TextBoxName $TextBox01 -Message "AzureRM profile version mismathch -- trying to  Install and import the API Version Profile required by Azure Stack Hub into the current PowerShell session"  
    Use-AzureRmProfile -Profile 2019-03-01-hybrid -Force
    if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureRM profile installation complete"}
    else {print-actionresult -TextBoxName $TextBox01 -Message "AzureRM profile installation   FAILED"}
    }

#Check if Azs modules are installed
if(!(Get-Module -Name "AzureStack" -ListAvailable)){   
    write-host "'AzureStack' module is not installed --trying to install"  
    print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module is not installed --trying to install"    
    Install-Module -Name AzureStack -RequiredVersion "$($AzSPSCurVersion[0]).$($AzSPSCurVersion[1]).$($AzSPSCurVersion[2])" -Force   
    if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module  installation complete"}
    else {print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module  installation   FAILED"} 
 }
 else { $InstalledAzsPSVersion = ((Get-Module -Name "AzureStack" -ListAvailable).version).ToString().split(".")

    if ([int]$InstalledAzsPSVersion[1] -lt [int]$AzSPSCurVersion[1])
    {
      #Uninstall old modules
      write-host "Uninstall old AzureStack modules $($InstalledAzsPSVersion[0]).$($InstalledAzsPSVersion[1]).$($InstalledAzsPSVersion[2])"
      print-actionresult -TextBoxName $TextBox01 -Message "Uninstall old AzureStack modules $($InstalledAzsPSVersion[0]).$($InstalledAzsPSVersion[1]).$($InstalledAzsPSVersion[2])"  
      Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
      Get-Module -Name Az.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
      #Install new modules  
      print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module is uninstalled --trying to reinstall"
      Install-Module -Name AzureStack -RequiredVersion "$($AzSPSCurVersion[0]).$($AzSPSCurVersion[1]).$($AzSPSCurVersion[2])"
      if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module  installation complete"}
      else {print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module  installation   FAILED"}
    }
    if ([int]$InstalledAzsPSVersion[2] -lt [int]$AzSPSCurVersion[2])
    {
      #Uninstall old modules
      write-host "Uninstall old AzureStack modules $($InstalledAzsPSVersion[0]).$($InstalledAzsPSVersion[1]).$($InstalledAzsPSVersion[2])"
      Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
      Get-Module -Name Az.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
      #Install new modules
      print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module is uninstalled --trying to reinstall"
      Install-Module -Name AzureStack -RequiredVersion "$($AzSPSCurVersion[0]).$($AzSPSCurVersion[1]).$($AzSPSCurVersion[2])"
      if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module  installation complete"}
      else {print-actionresult -TextBoxName $TextBox01 -Message "'AzureStack' module  installation   FAILED" }  
      }
 }

#Check if AzureAD modules are installed
if (!(Get-Module -Name "azuread" -ListAvailable)){    
    write-host "'AzureAD' module is not installed --trying to install"
    print-actionresult -TextBoxName $TextBox01 -Message "'AzureAD' module is not installed --trying to install"
    Install-module -Name azuread -Force
    if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "'AzureAD' module   installation complete"}
    else {print-actionresult -TextBoxName $TextBox01 -Message "'AzureAD' module  installation   FAILED"}
 }


#Check if AzureStack-Tools is installed

if ((Test-Path -PathType Container -Path "$AzureStackToolsPath") -eq $false){
    print-actionresult -TextBoxName $TextBox01 -Message "$AzureStackToolsPath is not exist --trying to create"
    New-Item -ItemType Directory -Path $AzureStackToolsPath 
    if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "$AzureStackToolsPath folder created"}
    else {print-actionresult -TextBoxName $TextBox01 -Message "$AzureStackToolsPath folder creation   FAILED" }
    #
    $output = "$AzureStackToolsPath\AzureStackTools.zip"
    Invoke-WebRequest -Uri $AzureStackToolsURL -OutFile $output
    if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools downloaded"}
    else {print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools download   FAILED" }

    if (test-path -Path "$AzureStackToolsPath\\AzureStackTools.zip"){
              Expand-Archive -LiteralPath "$AzureStackToolsPath\\AzureStackTools.zip" -DestinationPath $AzureStackToolsPath
              if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools extracted to $AzureStackToolsPath"}
              else {print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools extraction   FAILED" }
              move-Item -path "$AzureStackToolsPath\\AzureStack-Tools-master\*" -destination $AzureStackToolsPath
              Remove-Item -Path "$AzureStackToolsPath\\AzureStack-Tools-master"
             }

}
else {
    # here we check if two important modules are exist inside AzureStackToolsPath folder, if not - it is trigger for reinstalling AzureStackTools
    $chk =[int]0
    if (test-path -Path "$AzureStackToolsPath\\Connect\\AzureStack.Connect.psm1"){$chk+=1}
    if (test-path -Path "$AzureStackToolsPath\\Identity\\AzureStack.Identity.psm1"){$chk+=1} 
    if ($chk -lt 2){
        write-host "chk -lt 2"
        print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools modules set is inconsistent - will be reinstalled" ###!
        Remove-Item -Path "$AzureStackToolsPath\\*" -Recurse -Force
        if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools old folder content cleared"}
        else {print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools old folder content cleaning  FAILED" }
        

        $output = "$AzureStackToolsPath\AzureStackTools.zip"
        Invoke-WebRequest -Uri $AzureStackToolsURL -OutFile $output
        if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools downloaded"}
        else {print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools download   FAILED" }

        if (test-path -Path "$AzureStackToolsPath\\AzureStackTools.zip"){
              Expand-Archive -LiteralPath "$AzureStackToolsPath\\AzureStackTools.zip" -DestinationPath $AzureStackToolsPath
              if ($LASTEXITCODE -eq 0){print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools extracted to $AzureStackToolsPath"}
              else {print-actionresult -TextBoxName $TextBox01 -Message "AzureStackTools extraction   FAILED" }
              move-Item -path "$AzureStackToolsPath\\AzureStack-Tools-master\*" -destination $AzureStackToolsPath
              Remove-Item -Path "$AzureStackToolsPath\\AzureStack-Tools-master"
             }
        
        }
}

Print-PSConfigState -TextBoxName $TextBox01 -AzureStackToolsPath $AzureStackToolsPath



}#<-end event handler;

$CallRegistrationFormEventHandler = [System.EventHandler]{
   
    $script:AzureStackToolsPath = $TextBox02.Text
    $PSConfigForm.Close()

  
}


$Button01.Add_Click($СhkPSConfigEventHandler) ; 
$Button02.Add_Click($СhkandFixcPSConfigEventHandler) ;
$Button03.Add_Click($CallRegistrationFormEventHandler);
$BrowsButton.Add_Click($BrowsButtonEventHandler);
#$Button.

$PSConfigForm.Controls.Add($Label01);
$PSConfigForm.Controls.Add($Label02);
$PSConfigForm.Controls.Add($Label03);
$PSConfigForm.Controls.Add($Label04);
$PSConfigForm.Controls.Add($Label05);
$PSConfigForm.Controls.Add($Button01);
$PSConfigForm.Controls.Add($Button02);
$PSConfigForm.Controls.Add($Button03);
$PSConfigForm.Controls.Add($BrowsButton);
$PSConfigForm.Controls.Add($TextBox00);
$PSConfigForm.Controls.Add($TextBox01);
$PSConfigForm.Controls.Add($TextBox02)
$PSConfigForm.ShowDialog() |Out-Null

return $script:AzureStackToolsPath 


}