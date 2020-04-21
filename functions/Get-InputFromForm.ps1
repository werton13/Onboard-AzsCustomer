function Get-InputFromForm {

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Font = New-Object System.Drawing.Font("Calibry Light",9,[System.Drawing.FontStyle]::Regular)
#$Font4Combo = New-Object System.Drawing.Font("Calibry Light",11,[System.Drawing.FontStyle]::Regular)
$Font4Button = New-Object System.Drawing.Font("Calibry Light",11,[System.Drawing.FontStyle]::Regular)
$Font4Button2 = New-Object System.Drawing.Font("Webdings",12,[System.Drawing.FontStyle]::Bold)

$form = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 655, 950
    Text          = 'Создание подписки для нового заказчика Azure Stack'
    Topmost       = $true
    #BackColor     = "lightcyan"
    Font          = $Font
    
    #ForeColor     = "navy"
    
}

#region set icons

$avSetIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\avSet.jpg")
$avSetPicBox = new-object Windows.Forms.PictureBox
$avSetPicBox.Width = $avSetIconImage.Size.Width
$avSetPicBox.Height = $avSetIconImage.Size.Height
$avSetPicBox.Top = 402
$avSetPicBox.left = 210
$avSetPicBox.Image = $avSetIconImage

$vCPUIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vCPU.jpg")
$vCPUPicBox1 = new-object Windows.Forms.PictureBox
$vCPUPicBox1.Width = $vCPUIconImage.Size.Width
$vCPUPicBox1.Height = $vCPUIconImage.Size.Height
$vCPUPicBox1.Top = 480
$vCPUPicBox1.left = 210
$vCPUPicBox1.Image = $vCPUIconImage

$scaleSetIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\scaleSet.jpg")
$scaleSetPicBox = new-object Windows.Forms.PictureBox
$scaleSetPicBox.Width = $scaleSetIconImage.Size.Width
$scaleSetPicBox.Height = $scaleSetIconImage.Size.Height
$scaleSetPicBox.Top = 455
$scaleSetPicBox.left = 210
$scaleSetPicBox.Image = $scaleSetIconImage

$VMIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\VM.jpg")
$VMPicBox1 = new-object Windows.Forms.PictureBox
$VMPicBox1.Width = $VMIconImage.Size.Width
$VMPicBox1.Height = $VMIconImage.Size.Height
$VMPicBox1.Top = 430
$VMPicBox1.left = 210
$VMPicBox1.Image = $VMIconImage

$StdDiskconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\mDiskS.jpg")
$StdDiskPicBox1 = new-object Windows.Forms.PictureBox
$StdDiskPicBox1.Width = $StdDiskconImage.Size.Width
$StdDiskPicBox1.Height = $StdDiskconImage.Size.Height
$StdDiskPicBox1.Top = 520
$StdDiskPicBox1.left = 210
$StdDiskPicBox1.Image = $StdDiskconImage

$PrmDiskiconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\mDiskP.jpg")
$PrmDiskPicBox1 = new-object Windows.Forms.PictureBox
$PrmDiskPicBox1.Width = $PrmDiskIconImage.Size.Width
$PrmDiskPicBox1.Height = $PrmDiskIconImage.Size.Height
$PrmDiskPicBox1.Top = 548
$PrmDiskPicBox1.left = 210
$PrmDiskPicBox1.Image = $PrmDiskIconImage

$vNetIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vNet.jpg")
$vNetPicBox = new-object Windows.Forms.PictureBox
$vNetPicBox.Width = $vNetIconImage.Size.Width
$vNetPicBox.Height = $vNetIconImage.Size.Height
$vNetPicBox.Top = 407
$vNetPicBox.left = 527
$vNetPicBox.Image = $vNetIconImage

$vNicIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vNic.jpg")
$vNicPicBox = new-object Windows.Forms.PictureBox
$vNicPicBox.Width = $vNicIconImage.Size.Width
$vNicPicBox.Height = $vNicIconImage.Size.Height
$vNicPicBox.Top = 430
$vNicPicBox.left = 527
$vNicPicBox.Image = $vNicIconImage

$PIPIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\PIP.jpg")
$PIPPicBox = new-object Windows.Forms.PictureBox
$PIPPicBox.Width = $PIPIconImage.Size.Width
$PIPPicBox.Height = $PIPIconImage.Size.Height
$PIPPicBox.Top = 457
$PIPPicBox.left = 527
$PIPPicBox.Image = $PIPIconImage

$vGWIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vGW.jpg")
$vGWPicBox = new-object Windows.Forms.PictureBox
$vGWPicBox.Width = $vGWIconImage.Size.Width
$vGWPicBox.Height = $vGWIconImage.Size.Height
$vGWPicBox.Top = 482
$vGWPicBox.left = 531
$vGWPicBox.Image = $vGWIconImage

$vGWConIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\gwCon.jpg")
$vGWConPicBox = new-object Windows.Forms.PictureBox
$vGWConPicBox.Width = $vGWConIconImage.Size.Width
$vGWConPicBox.Height = $vGWConIconImage.Size.Height
$vGWConPicBox.Top = 507
$vGWConPicBox.left = 529
$vGWConPicBox.Image = $vGWConIconImage

$vLBIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vLB.jpg")
$vLBPicBox = new-object Windows.Forms.PictureBox
$vLBPicBox.Width  = $vLBIconImage.Size.Width
$vLBPicBox.Height = $vLBIconImage.Size.Height
$vLBPicBox.Top = 532
$vLBPicBox.left = 529
$vLBPicBox.Image = $vLBIconImage

$NSGIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\NSG.jpg")
$NSGPicBox = new-object Windows.Forms.PictureBox
$NSGPicBox.Width  = $NSGIconImage.Size.Width
$NSGPicBox.Height = $NSGIconImage.Size.Height
$NSGPicBox.Top = 557
$NSGPicBox.left = 532
$NSGPicBox.Image = $NSGIconImage

$ResRelImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\VMResRelationsDesc-80-4.jpg")
$pictureBox1 = new-object Windows.Forms.PictureBox
$pictureBox1.Width = $ResRelImage.Size.Width
$pictureBox1.Height = $ResRelImage.Size.Height
$pictureBox1.Top = 605
$pictureBox1.left = 5
$pictureBox1.Image = $ResRelImage





$errorprovider1 = New-Object "System.Windows.Forms.ErrorProvider";
$errorprovider2 = New-Object "System.Windows.Forms.ErrorProvider";
$errorprovider2.Icon = "$PSScriptRoot\icons\correct.ico";

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
$Label04.Text = "Пароль существующей у/з 'Admin' в Azure AD заказчика";

#define Label for Customer Azure Active Directory 'CloudAdmin' Password
$Label05 = New-Object “System.Windows.Forms.Label”;
$Label05.Left = 10
$Label05.Top = 235;
$Label05.Width =187;
$label05.Height =40;
$Label05.Text = "Пароль для создания у/з 'cloudadmin' в Azure AD заказчика";


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
$hSeparator2.Left =325;
$hSeparator2.Height =2;
$hSeparator2.Width =260;
$hSeparator2.BorderStyle="Fixed3D";

#create horizontal separator line3
$hSeparator3 = New-Object “System.Windows.Forms.Label”;
$hSeparator3.Top =685;
$hSeparator3.Left =325;
$hSeparator3.Height =2;
$hSeparator3.Width =550;
$hSeparator3.BorderStyle="Fixed3D";

#create horizontal separator line4
$hSeparator4 = New-Object “System.Windows.Forms.Label”;
$hSeparator4.Top =760;
$hSeparator4.Left =325;
$hSeparator4.Height =2;
$hSeparator4.Width =550;
$hSeparator4.BorderStyle="Fixed3D";
 
#create vertical separator line1
$vSeparator1 = New-Object “System.Windows.Forms.Label”;
$vSeparator1.Top =400;
$vSeparator1.Left =320;
$vSeparator1.Height =200;
$vSeparator1.Width =2;
$vSeparator1.BorderStyle="Fixed3D";

#create vertical separator line2
$vSeparator2 = New-Object “System.Windows.Forms.Label”;
$vSeparator2.Top =605;
$vSeparator2.Left =320;
$vSeparator2.Height =75;
$vSeparator2.Width =2;
$vSeparator2.BorderStyle="Fixed3D";

#create vertical separator line3
$vSeparator3 = New-Object “System.Windows.Forms.Label”;
$vSeparator3.Top =690;
$vSeparator3.Left =320;
$vSeparator3.Height =60;
$vSeparator3.Width =2;
$vSeparator3.BorderStyle="Fixed3D";

#create vertical separator line4
$vSeparator4 = New-Object “System.Windows.Forms.Label”;
$vSeparator4.Top =765;
$vSeparator4.Left =320;
$vSeparator4.Height =60;
$vSeparator4.Width =2;
$vSeparator4.BorderStyle="Fixed3D";

#Define L2bel for Azure Stack IaaS Availability Set Quotes
$Label3 = New-Object “System.Windows.Forms.Label”;
$Label3.Left = 10;
$Label3.Top = 405;
$Label3.Width =187;
$Label3.Text = 'Макс. кол-во Availability set';

#Define Label for Azure Stack IaaS vCPUQuotes
$Label4 = New-Object “System.Windows.Forms.Label”;
$Label4.Left = 10;
$Label4.Top = 480;
$Label4.Width =187;
$Label4.Text = 'Макс. кол-во vCPU';

#Define Label for Azure Stack IaaS VMScale Sets
$Label5 = New-Object “System.Windows.Forms.Label”;
$Label5.Left = 10;
$Label5.Top = 455;
$Label5.Width =187;
$Label5.Text = 'Макс. кол-во VM Scale Sets';

#Define Label for Azure Stack IaaS VMs
$Label6 = New-Object “System.Windows.Forms.Label”;
$Label6.Left = 10;
$Label6.Top = 430;
$Label6.Width =187;
$Label6.Text = 'Макс. кол-во Virtual Machines';

#Define Label for Azure Stack IaaS Standard Storage
$Label7 = New-Object “System.Windows.Forms.Label”;
$Label7.Left = 10;
$Label7.Top = 520;
$Label7.Width =187;
$Label7.Height =25;
$Label7.Text = 'Макс. объем Managed Disks Standard (Gb)';

#Define Label for Azure Stack IaaS Premium Storage
$Label8 = New-Object “System.Windows.Forms.Label”;
$Label8.Left = 10;
$Label8.Top = 548;
$Label8.Width =187;
$Label8.Height =25;
$Label8.Text = 'Макс. объем Managed Disks Premium (Gb)';

 #Define Label for Azure Stack IaaS Virtual Networks Quote
 $Label9 = New-Object “System.Windows.Forms.Label”;
 $Label9.Left = 325;
 $Label9.Top = 405;
 $Label9.Width =187;
 $Label9.Text = 'Макс кол-во Virtual Networks';
 
 #Define Label for Azure Stack IaaS Networks adapters
 $Label10 = New-Object “System.Windows.Forms.Label”;
 $Label10.Left = 325;
 $Label10.Top = 430;
 $Label10.Width =187;
 $Label10.Text = 'Макс кол-во Network adapters';

#Define Label for Azure Stack IaaS Public IP addresses Quote
$Label11 = New-Object “System.Windows.Forms.Label”;
$Label11.Left = 325;
$Label11.Top = 455;
$Label11.Width =187;
$Label11.Text = 'Макс кол-во Public IP';

#Define Label for Azure Stack IaaS Virtual Network Gateways Quote
$Label12 = New-Object “System.Windows.Forms.Label”;
$Label12.Left = 325;
$Label12.Top = 480;
$Label12.Width =187;
$Label12.Height =25;
$Label12.Text = 'Макс кол-во Virtual Network Gateways';

#Define Label for Azure Stack IaaS Virtual Network Gateways Connections Quote
$Label13 = New-Object “System.Windows.Forms.Label”;
$Label13.Left = 325;
$Label13.Top = 510;
$Label13.Width =187;
$Label13.Height =25;
$Label13.Text = 'Макс кол-во Virtual Network Gateway Connections';

#Define Label for Azure Stack IaaS Load Balancers Quote
$Label14 = New-Object “System.Windows.Forms.Label”;
$Label14.Left = 325;
$Label14.Top = 540;
$Label14.Width =187;
$Label14.Height =25;
$Label14.Text = 'Макс кол-во Virtual Load Balancers';

#Define Label for Azure Stack IaaS Load Balancers Quote
$Label15 = New-Object “System.Windows.Forms.Label”;
$Label15.Left = 325;
$Label15.Top = 570;
$Label15.Width =187;
$Label15.Height =25;
$Label15.Text = 'Макс кол-во Network Security Groups';

#Define Label for Azure Stack IaaS Unmanaged Storage Quota
$Label16 = New-Object “System.Windows.Forms.Label”;
$Label16.Left = 325;
$Label16.Top = 615;
$Label16.Width =187;
$Label16.Height =25;
$Label16.Text = 'Макс объем Unmanaged Storage (Gb)';

#Define Label for Azure Stack IaaS Unmanaged Storage Quota
$Label17 = New-Object “System.Windows.Forms.Label”;
$Label17.Left = 325;
$Label17.Top = 645;
$Label17.Width =187;
$Label17.Height =25;
$Label17.Text = 'Макс кол-во Storage Accounts';

#Define L2bel for Azure Stack SQL as Service Quota
$Label18 = New-Object “System.Windows.Forms.Label”;
$Label18.Left = 325;
$Label18.Top = 695;
$Label18.Width =167;
$Label18.Height =25;
$Label18.Text = 'Макс объем ресурсов SQL as Service';

#Define L2bel for Azure Stack Web Apps Quota
$Label19 = New-Object “System.Windows.Forms.Label”;
$Label19.Left = 325;
$Label19.Top = 765;
$Label19.Width =167;
$Label19.Height =30;
$Label19.Text = 'Макс объем ресурсов Web Apps';


#Define TextBox01 for input Azure Stack account name
$TextBox01 = New-Object "System.Windows.Forms.TextBox";
$TextBox01.Left = 210;
$TextBox01.Top = 15;
$TextBox01.width = 220;
$TextBox01.BackColor = "lightblue";
$textbox01.text = "subscription_adm"


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


#Define TextBox02 for INPUT Azure Stack password
$TextBox02 = New-Object "System.Windows.Forms.MaskedTextBox";
$TextBox02.Left = 210;
$TextBox02.Top = 55;
$TextBox02.width = 220;
$TextBox02.BackColor = "lightblue";
$Textbox02.PasswordChar = "*";


$TextBox02ToolTip = New-Object "System.Windows.Forms.ToolTip";
$TextBox02ToolTip.ShowAlways =$true;
$TextBox02ToolTip.SetToolTip($TextBox02,"Пароль для у/з Azure Stack с полномочиями на управление подписками");
$TextBox02ToolTip.InitialDelay = 0;

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

 #Define TextBox0002 for SHOW Azure Stack password
$TextBox0002 = New-Object "System.Windows.Forms.TextBox";
$TextBox0002.Left = 210;
$TextBox0002.Top = 55;
$TextBox0002.width = 220;
$TextBox0002.BackColor = "lightblue";
$TextBox0002.visible =$false       
 #Define show pwd button1

$ShPwdButton1 = New-Object “System.Windows.Forms.Button”;
$ShPwdButton1.Left = 460;
$ShPwdButton1.Top = 55;
$ShPwdButton1.Width = 35;
$ShPwdButton1.Height = 20;
$ShPwdButton1.BackColor = "lightblue";
$ShPwdButton1.Font = $Font4Button2;
$ShPwdButton1.Text = “N”;
$ShPwdButton1.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$ShPwdButton1.FlatAppearance.BorderSize = 1;
$ShPwdButton1.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$ShPwdButton1.BackColor = [System.Drawing.Color]::aliceblue  

# Test procedure for Show Pwd Button1 event handler
$ShPwdButton1EventHandler = [System.EventHandler]{
    $Textbox02.Visible = $False
    $TextBox0002.Visible = $true
    $TextBox0002.Text = $Textbox02.Text
    $TextBox0002.ReadOnly =$true
    
    Start-Sleep -Seconds 2
    
    $TextBox0002.Visible = $False
    $TextBox0002.Clear()
    $Textbox02.Visible = $True 

};
$ShPwdButton1.Add_Click($ShPwdButton1EventHandler) ;    

#Define TextBox03 for print output for Azure Stack credential validation
$TextBox03 = New-Object "System.Windows.Forms.TextBox";
$TextBox03.Left = 210;
$TextBox03.Top = 90;
$TextBox03.width = 220;
$TextBox03.Multiline = $true;
$TextBox03.height = 60;
$TextBox03.BackColor = "lightblue";
$TextBox03.Visible = $False

#Define TextBox04 for Customer Azure Subscription ID
$TextBox04 = New-Object "System.Windows.Forms.TextBox";
$TextBox04.Left = 210;
$TextBox04.Top = 155;
$TextBox04.width = 220;
$TextBox04.text = "введите Azure Subscription ID"
#$TextBox04.Multiline = $true;
#$TextBox04.height = 60;
$TextBox04.BackColor = "lightblue";

#Define TextBox05 for Customer Azure AD admin password
$TextBox05 = New-Object "System.Windows.Forms.MaskedTextBox";
$TextBox05.Left = 210;
$TextBox05.Top = 195;
$TextBox05.width = 220;
$TextBox05.BackColor = "lightblue";
$Textbox05.PasswordChar = "*";

$Textbox05ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Textbox05ToolTip.ShowAlways =$true;
$Textbox05ToolTip.SetToolTip($TextBox05,"Пароль уже установленный при создании у/з 'admin' в Azure AD заказчика");
$Textbox05ToolTip.InitialDelay = 0;

 #Define TextBox0005 for SHOW Azure AD admin password
 $TextBox0005 = New-Object "System.Windows.Forms.TextBox";
 $TextBox0005.Left = 210;
 $TextBox0005.Top = 195;
 $TextBox0005.width = 220;
 $TextBox0005.BackColor = "lightblue";
 $TextBox0005.visible =$false       

 #Define show pwd button2
 $ShPwdButton2 = New-Object “System.Windows.Forms.Button”;
 $ShPwdButton2.Left = 460;
 $ShPwdButton2.Top = 195;
 $ShPwdButton2.Width = 35;
 $ShPwdButton2.Height = 20;
 $ShPwdButton2.BackColor = "lightblue";
 $ShPwdButton2.Font = $Font4Button2;
 $ShPwdButton2.Text = “N”;
 $ShPwdButton2.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
 $ShPwdButton2.FlatAppearance.BorderSize = 1;
 $ShPwdButton2.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
 $ShPwdButton2.BackColor = [System.Drawing.Color]::aliceblue  
 
 # Test procedure for Show Pwd Button2 event handler
 $ShPwdButton2EventHandler = [System.EventHandler]{
     $Textbox05.Visible = $False
     $TextBox0005.Visible = $true
     $TextBox0005.Text =$Textbox05.Text
     $TextBox0005.ReadOnly =$true
     
     Start-Sleep -Seconds 1
     
     $TextBox0005.Visible = $False
     $TextBox0005.Clear()
     $Textbox05.Visible = $True 
 
 };
 $ShPwdButton2.Add_Click($ShPwdButton2EventHandler) ; 

#Define TextBox06 for Customer Azure AD 'cloudadmin' password -it is an account intended to manage Azure Stack resources from customer side
$TextBox06 = New-Object "System.Windows.Forms.MaskedTextBox";
$TextBox06.Left = 210;
$TextBox06.Top = 235;
$TextBox06.width = 220;
$TextBox06.BackColor = "lightblue";
$Textbox06.PasswordChar = "*";

$Testbox06ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox06ToolTip.ShowAlways =$true;
$Testbox06ToolTip.SetToolTip($TextBox06,"Пароль для создания у/з 'cloudadmin' в Azure AD заказчика");
$Testbox06ToolTip.InitialDelay = 0;

 #Define TextBox0005 for SHOW Azure AD CLOUDADMIN  password
 $TextBox0006 = New-Object "System.Windows.Forms.TextBox";
 $TextBox0006.Left = 210;
 $TextBox0006.Top = 235;
 $TextBox0006.width = 220;
 $TextBox0006.BackColor = "lightblue";
 $TextBox0006.visible =$false       

 #Define show pwd button3
 $ShPwdButton3 = New-Object “System.Windows.Forms.Button”;
 $ShPwdButton3.Left = 460;
 $ShPwdButton3.Top = 235;
 $ShPwdButton3.Width = 35;
 $ShPwdButton3.Height = 20;
 $ShPwdButton3.BackColor = "lightblue";
 $ShPwdButton3.Font = $Font4Button2;
 $ShPwdButton3.Text = “N”;
 $ShPwdButton3.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
 $ShPwdButton3.FlatAppearance.BorderSize = 1;
 $ShPwdButton3.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
 $ShPwdButton3.BackColor = [System.Drawing.Color]::aliceblue  
 
 # Test procedure for Show Pwd Button3 event handler
 $ShPwdButton3EventHandler = [System.EventHandler]{
     $Textbox06.Visible = $False
     $TextBox0006.Visible = $true
     $TextBox0006.Text =$Textbox06.Text
     $TextBox0006.ReadOnly =$true
     
     Start-Sleep -Seconds 1
     
     $TextBox0006.Visible = $False
     $TextBox0006.Clear()
     $Textbox06.Visible = $True 
 
 };
 $ShPwdButton3.Add_Click($ShPwdButton3EventHandler) ; 

#Define TextBox1 for Label1 - 'Имя тенанта Azure Active Directory (до .onmicrosoft.com)';
$TextBox1 = New-Object “System.Windows.Forms.TextBox”;
$TextBox1.Left = 210;
$TextBox1.Top = 310;
$TextBox1.width = 220;
$Textbox1.text = "короткое имя - например TenanName"
$TextBox1.BackColor = "lightblue";

$Testbox1ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox1ToolTip.ShowAlways =$true;
$Testbox1ToolTip.SetToolTip($TextBox1,"Имя тенанта Azure Active Directory (до .onmicrosoft.com), которое было выбрано  при  создании заказчика на сайте partner.microsoft.com");
$Testbox1ToolTip.InitialDelay = 0;


#Define TextBox2 for Label2 - 'Azure Stack Subscription Name'
$TextBox2 = New-Object “System.Windows.Forms.TextBox”;
$TextBox2.Left = 210;
$TextBox2.Top = 355;
$TextBox2.width = 220;
$TextBox2.BackColor = "lightblue";
$TextBox2.Text = "например ООО Сетконс"

$Testbox2ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox2ToolTip.ShowAlways =$true;
$Testbox2ToolTip.SetToolTip($TextBox2,"Наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com");
$Testbox2ToolTip.InitialDelay = 0;

#Define ComboBox for Label3 'Макс кол-во Availability set'
$CValues=@("1","2","3","4");
$ComboBox1 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox1.DroppedDown = $true;
$ComboBox1.Left = 240;
$ComboBox1.Top = 405;
$ComboBox1.Width =60;
$ComboBox1.BackColor ="lightblue";
$ComboBox1.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter their own vaalues in combobox
$ComboBox1.Items.AddRange($CValues);
$ComboBox1.selectedindex = 1 # set default value - index for the values array


#Define ComboBox for Label4 'Макс кол-во vCPU'
$CValues=@(1..64);
$ComboBox2 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox2.DroppedDown = $true;
$ComboBox2.Left = 240;
$ComboBox2.Top = 480;
$ComboBox2.Width =60;
$ComboBox2.BackColor ="lightblue";
$ComboBox2.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox2.Items.AddRange($CValues);
$ComboBox2.selectedindex = 7 # set default value - index for the values array

#Define ComboBox for Label5 'Макс кол-во VM Scale Sets'
$CValues=@(1..8);
$ComboBox3 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox3.DroppedDown = $true;
$ComboBox3.Left = 240;
$ComboBox3.Top = 455;
$ComboBox3.Width =60;
$ComboBox3.BackColor ="lightblue";
$ComboBox3.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox3.Items.AddRange($CValues);
$ComboBox3.selectedindex = 0 # set default value - index for the values array


#Define ComboBox for Label6 'Макс кол-во Virtual Machines'
$CValues=@(1..32);
$ComboBox4 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox4.DroppedDown = $true;
$ComboBox4.Left = 240;
$ComboBox4.Top = 430;
$ComboBox4.Width =60;
$ComboBox4.BackColor ="lightblue";
$ComboBox4.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox4.Items.AddRange($CValues);
$ComboBox4.selectedindex = 3 # set default value - index for the values array

$ComboBox4_ValueChanged =
{
    $test = 128+128*([int]($ComboBox4.SelectedItem))
    write-host $test
    $ComboBox2.SelectedItem   =  [int]($ComboBox4.SelectedItem)*2  #vCPU
    $ComboBox5.SelectedItem   = 128+128*([int]($ComboBox4.SelectedItem)) #Standard Managed Disks Storage
    $ComboBox6.SelectedItem   = 128+128*([int]($ComboBox4.SelectedItem))  #Premium Managed Disks Storage
    $ComboBox8.SelectedItem   = $ComboBox4.SelectedItem   #vNics
    $ComboBox13.SelectedItem  = $ComboBox4.SelectedItem  #NSG
    
   
}
$ComboBox4.add_SelectedIndexChanged($ComboBox4_ValueChanged)

$NumbersSequence = @() # from 128 till 20480
for ($i=128;$i -le 20480;$i+=128){$NumbersSequence+=$i}
#Define ComboBox for Label7 'Макс объем Managed Disks Standard (Gb)'
$ComboBox5Values=$NumbersSequence
#$CValues=@(128,256,384,512,640,768,896,1024,1152,1280,1408,1536,1664,1792,1920,2048,2176,2304,2432,2560,2688,2816,2944,3072,3200,3328,3456,3584,3712,3840,3968,4096,4224,4352,4480,4608,4736,4864,4992,5120,5248,5376,5504,5632,5760,5888,6016,6144,6272,6400,6528,6656,6784,6912,7040,7168,7296,7424,7552,7680,7808,7936,8064,8192,8320,8448,8576,8704,8832,8960,9088,9216,9344,9472,9600,9728,9856,9984,10112,10240,10368,10496,10624,10752,10880,11008,11136,11264,11392,11520,11648,11776,11904,12032,12160,12288,12416,12544,12672,12800,12928,13056,13184,13312,13440,13568,13696,13824,13952,14080,14208,14336,14464,14592,14720,14848,14976,15104,15232,15360,15488,15616,15744,15872,16000,16128,16256,16384,16512,16640,16768,16896,17024,17152,17280,17408,17536,17664,17792,17920,18048,18176,18304,18432,18560,18688,18816,18944,19072,19200,19328,19456,19584,19712,19840,19968,20096,20224,20352,20480);
$ComboBox5 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox5.DroppedDown = $true;
$ComboBox5.Left = 240;
$ComboBox5.Top = 520;
$ComboBox5.Width =60;
$ComboBox5.BackColor ="lightblue";
$ComboBox5.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox5.Items.AddRange($ComboBox5Values);
$ComboBox5.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label8 'Макс объем Managed Disks Premium (Gb)'
$ComboBox6Values = $NumbersSequence;
$ComboBox6 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox6.DroppedDown = $true;
$ComboBox6.Left = 240;
$ComboBox6.Top = 548;
$ComboBox6.Width =60;
$ComboBox6.BackColor ="lightblue";
$ComboBox6.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox6.Items.AddRange($ComboBox6Values);
$ComboBox6.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label9 'Макс кол-во Virtual Networks'
$CValues=@(1..10);
$ComboBox7 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox7.DroppedDown = $true;
$ComboBox7.Left = 555;
$ComboBox7.Top = 405;
$ComboBox7.Width =60;
$ComboBox7.BackColor ="lightblue";
$ComboBox7.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox7.Items.AddRange($CValues);
$ComboBox7.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label10 'Макс кол-во Network adapters'
$CValues=@(1..32);
$ComboBox8 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox8.DroppedDown = $true;
$ComboBox8.Left = 555;
$ComboBox8.Top = 430;
$ComboBox8.Width =60;
$ComboBox8.BackColor ="lightblue";
$ComboBox8.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox8.Items.AddRange($CValues);
$ComboBox8.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label11 'Макс кол-во Public IP'
$CValues=@(1..10);
$ComboBox9 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox9.DroppedDown = $true;
$ComboBox9.Left = 555;
$ComboBox9.Top = 455;
$ComboBox9.Width =60;
$ComboBox9.BackColor ="lightblue";
$ComboBox9.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox9.Items.AddRange($CValues);
$ComboBox9.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label12 'Макс кол-во Virtual Network Gateways'
$CValues=@(0,1,2);
$ComboBox10 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox10.DroppedDown = $true;
$ComboBox10.Left = 555;
$ComboBox10.Top = 480;
$ComboBox10.Width =60;
$ComboBox10.BackColor ="lightblue";
$ComboBox10.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox10.Items.AddRange($CValues);
$ComboBox10.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label13 'Макс кол-во Virtual Network Gateway Connections'
$CValues=@(0,1,2);
$ComboBox11 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox11.DroppedDown = $true;
$ComboBox11.Left = 555;
$ComboBox11.Top = 507;
$ComboBox11.Width =60;
$ComboBox11.BackColor ="lightblue";
$ComboBox11.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox11.Items.AddRange($CValues);
$ComboBox11.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label14 'Макс кол-во Virtual Load Balancers'
$CValues=@(1..8);
$ComboBox12 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox12.DroppedDown = $true;
$ComboBox12.Left = 555;
$ComboBox12.Top = 532;
$ComboBox12.Width =60;
$ComboBox12.BackColor ="lightblue";
$ComboBox12.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox12.Items.AddRange($CValues);
$ComboBox12.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label15 'Макс кол-во Network Security Groups'
$CValues=@(1..32);
$ComboBox13 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox13.DroppedDown = $true;
$ComboBox13.Left = 555;
$ComboBox13.Top = 557;
$ComboBox13.Width =60;
$ComboBox13.BackColor ="lightblue";
$ComboBox13.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox13.Items.AddRange($CValues);
$ComboBox13.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label16 'Макс объем Unmanaged Storage (Gb)'
$CValues=@(128,256,512,1024,2048,3072,4096,5120,6144,7168,8192,9216,10240,16384,20480);
$ComboBox14 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox14.DroppedDown = $true;
$ComboBox14.Left = 525;
$ComboBox14.Top = 615;
$ComboBox14.Width =60;
$ComboBox14.BackColor ="lightblue";
$ComboBox14.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox14.Items.AddRange($CValues);
$ComboBox14.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label17  'Макс кол-во Storage Accounts';
$CValues=@(1..20);
$ComboBox15 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox15.DroppedDown = $true;
$ComboBox15.Left = 525;
$ComboBox15.Top = 645;
$ComboBox15.Width =60;
$ComboBox15.BackColor ="lightblue";
$ComboBox15.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox15.Items.AddRange($CValues);
$ComboBox15.selectedindex = 1 # set default value - index for the values array

#Define ComboBox for Label18 'Макс объем ресурсов SQL as Service'
$CValues=@("10GB 5DB","10GB 10DBs","100GB 10DBs");
$ComboBox16 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox16.DroppedDown = $true;
$ComboBox16.Left = 495;
$ComboBox16.Top = 696;
$ComboBox16.Width =90;
$ComboBox16.BackColor ="lightblue";
$ComboBox16.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox16.Items.AddRange($CValues);
$ComboBox16.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label19 'Макс объем ресурсов Web Apps'
$CValues=@("1 App SP","3 App SP","Evaluation");
$ComboBox17 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox17.DroppedDown = $true;
$ComboBox17.Left = 495;
$ComboBox17.Top = 765;
$ComboBox17.Width =90;
$ComboBox17.BackColor ="lightblue";
$ComboBox17.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
$ComboBox17.Items.AddRange($CValues);
$ComboBox17.selectedindex = 2 # set default value - index for the values array




#Define OK Button
$CreateButton = New-Object “System.Windows.Forms.Button”;
$CreateButton.Left = 420;
$CreateButton.Top = 850;
$CreateButton.Width = 160;
$CreateButton.Height = 50;
$CreateButton.BackColor = "lightblue";
$CreateButton.Font = $Font4Button;
$CreateButton.Text = “Создать подписку”;
$CreateButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$CreateButton.FlatAppearance.BorderSize = 1;
$CreateButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$CreateButton.BackColor = [System.Drawing.Color]::aliceblue  
$CreateButton.BackColor = "lightblue";
$CreateButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$CreateButton.FlatAppearance.BorderSize = 1;
$CreateButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$CreateButton.BackColor = [System.Drawing.Color]::aliceblue 

############# This is when you have to close the Form after getting values
$CreateButtonEventHandler = [System.EventHandler]{
                                        
                                        #$TextBox01.Text;
                                        #$TextBox1.Text;
                                        #$TextBox2.Text;
                                        #$TextBox3.Text;
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
#if (!(get-module -ListAvailable |?{$_.name -match "azuread"})){Write-Host "module not installed"}
#install-module azuread
#import-module azuread
#Import-Module C:\AzureStack\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1
#Import-Module C:\AzureStack\AzureStack-Tools-master\Identity\AzureStack.Identity.psm1 

#######################################################################################################################################################


$AZSAdminSubscrUserName  =  $TextBox01.Text       
$AZSAdminSubscrPwd       =  ConvertTo-SecureString -String $TextBox02.Text -AsPlainText -Force
$CustomerAzureSubscrID = $TextBox04.text #
$TenantName            = $TextBox1.text+".onmicrosoft.com"   # -> имя тенанта Azure Active Directory (до @onmicrosoft.com), которое было выбрано  при создании заказчика на сайте partner.microsoft.com
$SubscriptionName      = $TextBox2.Text     # -> наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com
$AzureTenantCstmrCloudAdminPwd   =  $TextBox06.text
$AzureTenantCstmrAdmin      = "admin@$TenantName"
$AzureTenantCstmrAdminPwd   = ConvertTo-SecureString -String $TextBox05.text -AsPlainText -Force
$IaaS_CQ_AvailSetCount   =   [int]$ComboBox1.SelectedItem # 
$IaaS_CQ_CoresCount      =   [int]$ComboBox2.SelectedItem #
$IaaS_CQ_VMScaleSetCount =   [int]$ComboBox3.SelectedItem  #
$IaaS_CQ_VMMachineCount  =   [int]$ComboBox4.SelectedItem  #
$IaaS_CQ_STDStorageSize  =   [int]$ComboBox5.SelectedItem  #
$IaaS_CQ_PREMStorageSize =   [int]$ComboBox6.SelectedItem  #
$IaaS_NQ_VNetCount       =   [int]$ComboBox7.SelectedItem  #
$IaaS_NQ_NicsCount       =   [int]$ComboBox8.SelectedItem  #
$IaaS_NQ_PIPCount        =   [int]$ComboBox9.SelectedItem  #
$IaaS_NQ_VNGCount        =   [int]$ComboBox10.SelectedItem #
$IaaS_NQ_VNGConCount     =   [int]$ComboBox11.SelectedItem #
$IaaS_NQ_LBCount         =   [int]$ComboBox12.SelectedItem     #
$IaaS_NQ_SGCount         =   [int]$ComboBox13.SelectedItem      #
$IaaS_SQ_Capacity        =   [int]$ComboBox14.SelectedItem   #
$IaaS_SQ_SACount         =   [int]$ComboBox15.SelectedItem     #
$SQLQuotaName            =   ($ComboBox16.SelectedItem).ToString().Replace(" ","")
#$WebQuotaName            =   $ComboBox17.SelectedItem
if ($ComboBox17.SelectedItem -eq "1 App SP"){$WebQuotaName = "ext-1AppSP-web"}
if ($ComboBox17.SelectedItem -eq "3 App SP"){$WebQuotaName = "ext-3AppSP-web"}
if ($ComboBox17.SelectedItem -eq "Evaluation"){$WebQuotaName = "Evaluation"}



$script:FormFields = new-object psobject
$script:FormFields | add-member –membertype NoteProperty –name AZSAdminSubscrUserName –value NotSet #
$script:FormFields | add-member –membertype NoteProperty –name AZSAdminSubscrPwd –value NotSet     #
$script:FormFields | add-member –membertype NoteProperty –name CustomerAzureSubscrID –value NotSet#
$script:FormFields | add-member –membertype NoteProperty –name TenantName –value NotSet           #
$script:FormFields | add-member –membertype NoteProperty –name SubscriptionName –value NotSet     #
$script:FormFields | add-member –membertype NoteProperty –name AzureTenantCstmrCloudAdminPwd –value NotSet #
$script:FormFields | add-member –membertype NoteProperty –name AzureTenantCstmrAdmin –value NotSet#
$script:FormFields | add-member –membertype NoteProperty –name AzureTenantCstmrAdminPwd –value NotSet#
$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_AvailSetCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_CoresCount  –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_VMScaleSetCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_VMMachineCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_STDStorageSize –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_PREMStorageSize –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_VNetCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_NicsCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_PIPCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_VNGCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_VNGConCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_LBCount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_SGCount  –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_SQ_Capacity   –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name IaaS_SQ_SACount –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name SQLQuotaName –value NotSet
$script:FormFields | add-member –membertype NoteProperty –name WebQuotaName –value NotSet

$script:FormFields.AZSAdminSubscrUserName    = $AZSAdminSubscrUserName
$script:FormFields.AZSAdminSubscrPwd         = $AZSAdminSubscrPwd
$script:FormFields.CustomerAzureSubscrID     = $CustomerAzureSubscrID
$script:FormFields.TenantName                = $TenantName

$script:FormFields.SubscriptionName                    = $SubscriptionName
$script:FormFields.AzureTenantCstmrCloudAdminPwd       = $AzureTenantCstmrCloudAdminPwd
$script:FormFields.AzureTenantCstmrAdmin               = $AzureTenantCstmrAdmin 
$script:FormFields.AzureTenantCstmrAdminPwd            = $AzureTenantCstmrAdminPwd
$script:FormFields.IaaS_CQ_AvailSetCount               = $IaaS_CQ_AvailSetCount
$script:FormFields.IaaS_CQ_CoresCount                  = $IaaS_CQ_CoresCount 
$script:FormFields.IaaS_CQ_VMScaleSetCount             = $IaaS_CQ_VMScaleSetCount
$script:FormFields.IaaS_CQ_VMMachineCount              = $IaaS_CQ_VMMachineCount
$script:FormFields.IaaS_CQ_STDStorageSize              = $IaaS_CQ_STDStorageSize
$script:FormFields.IaaS_CQ_PREMStorageSize             = $IaaS_CQ_PREMStorageSize
$script:FormFields.IaaS_NQ_VNetCount                   = $IaaS_NQ_VNetCount
$script:FormFields.IaaS_NQ_NicsCount                   = $IaaS_NQ_NicsCount
$script:FormFields.IaaS_NQ_PIPCount                    = $IaaS_NQ_PIPCount
$script:FormFields.IaaS_NQ_VNGCount                    = $IaaS_NQ_VNGCount
$script:FormFields.IaaS_NQ_VNGConCount                 = $IaaS_NQ_VNGConCount
$script:FormFields.IaaS_NQ_LBCount                     = $IaaS_NQ_LBCount
$script:FormFields.IaaS_NQ_SGCount                     = $IaaS_NQ_SGCount
$script:FormFields.IaaS_SQ_Capacity                    = $IaaS_SQ_Capacity
$script:FormFields.IaaS_SQ_SACount                     = $IaaS_SQ_SACount
$script:FormFields.SQLQuotaName                        = $SQLQuotaName
$script:FormFields.WebQuotaName                        = $WebQuotaName  






$Form.Close();
}
$CreateButton.Add_Click($CreateButtonEventHandler) ;

#Define check cred button

$CheckCredButton = New-Object “System.Windows.Forms.Button”;
$CheckCredButton.Left = 10;
$CheckCredButton.Top = 90;
$CheckCredButton.Width = 160;
$CheckCredButton.Height = 50;
$CheckCredButton.BackColor = "lightblue";
$CheckCredButton.Font = $Font4Button;
$CheckCredButton.Text = “Проверить учетные данные”;
$CheckCredButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$CheckCredButton.FlatAppearance.BorderSize = 1;
$CheckCredButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$CheckCredButton.BackColor = [System.Drawing.Color]::aliceblue  




# Test procedure for Check Credential event handler
$СhkCredEventHandler = [System.EventHandler]{
    
    Test-AzsCredentials -AZSUserName $TextBox01.Text -AZSPassword $TextBox02.Text
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
$Form.Controls.Add($ShPwdButton1);
$Form.Controls.Add($ShPwdButton2);
$Form.Controls.Add($ShPwdButton3);
$Form.Controls.Add($CreateButton);
$Form.Controls.Add($Label01);
$Form.Controls.Add($Label02);
$Form.Controls.Add($Label03);
$Form.Controls.Add($Label04);
$Form.Controls.Add($Label05);
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
$Form.Controls.Add($TextBox0002);
$Form.Controls.Add($TextBox0005);
$Form.Controls.Add($TextBox0006);
$Form.Controls.Add($TextBox03);
$Form.Controls.Add($TextBox04);
$Form.Controls.Add($TextBox05);
$Form.Controls.Add($TextBox06);
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
$form.Controls.Add($pictureBox1);
$form.Controls.Add($avSetPicBox)
$form.Controls.Add($VMPicBox1)
$form.Controls.Add($StdDiskPicBox1)
$form.Controls.Add($PrmDiskPicBox1)
$form.Controls.Add($vCPUPicBox1)
$form.Controls.Add($scaleSetPicBox)
$form.Controls.Add($vNetPicBox);
$form.Controls.Add($vNicPicBox);
$form.Controls.Add($PIPPicBox);
$form.Controls.Add($vGWPicBox);
$form.Controls.Add($vGWConPicBox);
$form.Controls.Add($vLBPicBox);
$form.Controls.Add($NSGPicBox);


$Form.ShowDialog()|Out-Null

return $script:FormFields
}


