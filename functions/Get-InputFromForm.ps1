function Get-InputFromForm {
    param(
          [string]$CSPResultPath
          )
    
#Debug
# write-host "CSPResultPath: $CSPResultPath"
##

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Font = New-Object System.Drawing.Font("Calibry Light",9,[System.Drawing.FontStyle]::Regular)
$Font2 = New-Object System.Drawing.Font("Calibry Light",11,[System.Drawing.FontStyle]::Regular)
#$Font4Combo = New-Object System.Drawing.Font("Calibry Light",11,[System.Drawing.FontStyle]::Regular)
$Font4Button = New-Object System.Drawing.Font("Calibry Light",11,[System.Drawing.FontStyle]::Regular)
$Font4Button2 = New-Object System.Drawing.Font("Webdings",12,[System.Drawing.FontStyle]::Bold)
$Font4logo = New-Object System.Drawing.Font("Comic Sans MS",16,[System.Drawing.FontStyle]::Bold)


$form = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    #Size          = New-Object Drawing.Size 655, 950
    Size          = New-Object Drawing.Size 1350, 950
    Text          = 'Создание подписки для нового заказчика Azure Stack'
    Topmost       = $true
    #BackColor     = "MediumPurple"
    Font          = $Font
    
    #ForeColor     = "navy"

   # $Form.Add_FormClosing({ OnClick_Exit })
    
}

#region set icons
$MainIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\Franky3-2.png")
$LogoPicBox = new-object Windows.Forms.PictureBox
$LogoPicBox.Width = $MainIconImage.Size.Width
$LogoPicBox.Height = $MainIconImage.Size.Height
$LogoPicBox.Top = 20
$LogoPicBox.left = 1150#210
$LogoPicBox.Image = $MainIconImage


$avSetIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\avSet.jpg")
$avSetPicBox = new-object Windows.Forms.PictureBox
$avSetPicBox.Width = $avSetIconImage.Size.Width
$avSetPicBox.Height = $avSetIconImage.Size.Height
$avSetPicBox.Top = 402
$avSetPicBox.left = 850#210
$avSetPicBox.Image = $avSetIconImage

$vCPUIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vCPU.jpg")
$vCPUPicBox1 = new-object Windows.Forms.PictureBox
$vCPUPicBox1.Width = $vCPUIconImage.Size.Width
$vCPUPicBox1.Height = $vCPUIconImage.Size.Height
$vCPUPicBox1.Top = 480
$vCPUPicBox1.left = 850#210
$vCPUPicBox1.Image = $vCPUIconImage

$scaleSetIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\scaleSet.jpg")
$scaleSetPicBox = new-object Windows.Forms.PictureBox
$scaleSetPicBox.Width = $scaleSetIconImage.Size.Width
$scaleSetPicBox.Height = $scaleSetIconImage.Size.Height
$scaleSetPicBox.Top = 455
$scaleSetPicBox.left = 850#210
$scaleSetPicBox.Image = $scaleSetIconImage

$VMIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\VM.jpg")
$VMPicBox1 = new-object Windows.Forms.PictureBox
$VMPicBox1.Width = $VMIconImage.Size.Width
$VMPicBox1.Height = $VMIconImage.Size.Height
$VMPicBox1.Top = 430
$VMPicBox1.left = 850#210
$VMPicBox1.Image = $VMIconImage

$StdDiskconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\mDiskS.jpg")
$StdDiskPicBox1 = new-object Windows.Forms.PictureBox
$StdDiskPicBox1.Width = $StdDiskconImage.Size.Width
$StdDiskPicBox1.Height = $StdDiskconImage.Size.Height
$StdDiskPicBox1.Top = 520
$StdDiskPicBox1.left = 850#210
$StdDiskPicBox1.Image = $StdDiskconImage

$PrmDiskiconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\mDiskP.jpg")
$PrmDiskPicBox1 = new-object Windows.Forms.PictureBox
$PrmDiskPicBox1.Width = $PrmDiskIconImage.Size.Width
$PrmDiskPicBox1.Height = $PrmDiskIconImage.Size.Height
$PrmDiskPicBox1.Top = 548
$PrmDiskPicBox1.left = 850#210
$PrmDiskPicBox1.Image = $PrmDiskIconImage

$vNetIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vNet.jpg")
$vNetPicBox = new-object Windows.Forms.PictureBox
$vNetPicBox.Width = $vNetIconImage.Size.Width
$vNetPicBox.Height = $vNetIconImage.Size.Height
$vNetPicBox.Top = 407
$vNetPicBox.left = 1167#527
$vNetPicBox.Image = $vNetIconImage

$vNicIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vNic.jpg")
$vNicPicBox = new-object Windows.Forms.PictureBox
$vNicPicBox.Width = $vNicIconImage.Size.Width
$vNicPicBox.Height = $vNicIconImage.Size.Height
$vNicPicBox.Top = 430
$vNicPicBox.left = 1167#527
$vNicPicBox.Image = $vNicIconImage

$PIPIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\PIP.jpg")
$PIPPicBox = new-object Windows.Forms.PictureBox
$PIPPicBox.Width = $PIPIconImage.Size.Width
$PIPPicBox.Height = $PIPIconImage.Size.Height
$PIPPicBox.Top = 457
$PIPPicBox.left = 1167#527
$PIPPicBox.Image = $PIPIconImage

$vGWIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vGW.jpg")
$vGWPicBox = new-object Windows.Forms.PictureBox
$vGWPicBox.Width = $vGWIconImage.Size.Width
$vGWPicBox.Height = $vGWIconImage.Size.Height
$vGWPicBox.Top = 482
$vGWPicBox.left = 1171#531
$vGWPicBox.Image = $vGWIconImage

$vGWConIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\gwCon.jpg")
$vGWConPicBox = new-object Windows.Forms.PictureBox
$vGWConPicBox.Width = $vGWConIconImage.Size.Width
$vGWConPicBox.Height = $vGWConIconImage.Size.Height
$vGWConPicBox.Top = 507
$vGWConPicBox.left = 1169#529
$vGWConPicBox.Image = $vGWConIconImage

$vLBIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\vLB.jpg")
$vLBPicBox = new-object Windows.Forms.PictureBox
$vLBPicBox.Width  = $vLBIconImage.Size.Width
$vLBPicBox.Height = $vLBIconImage.Size.Height
$vLBPicBox.Top = 532
$vLBPicBox.left = 1169#529
$vLBPicBox.Image = $vLBIconImage

$NSGIconImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\NSG.jpg")
$NSGPicBox = new-object Windows.Forms.PictureBox
$NSGPicBox.Width  = $NSGIconImage.Size.Width
$NSGPicBox.Height = $NSGIconImage.Size.Height
$NSGPicBox.Top = 557
$NSGPicBox.left = 1172#532
$NSGPicBox.Image = $NSGIconImage

$ResRelImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\VMResRelationsDesc-80-4.jpg")
$pictureBox1 = new-object Windows.Forms.PictureBox
$pictureBox1.Width = $ResRelImage.Size.Width
$pictureBox1.Height = $ResRelImage.Size.Height
$pictureBox1.Top = 605
$pictureBox1.left = 645#5
$pictureBox1.Image = $ResRelImage

$ASHRegionImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\AZH.png")
$ASHRegionPicBox = new-object Windows.Forms.PictureBox
$ASHRegionPicBox.Width = $ASHRegionImage.Size.Width
$ASHRegionPicBox.Height = $ASHRegionImage.Size.Height
$ASHRegionPicBox.Top = 110
$ASHRegionPicBox.left = 835
$ASHRegionPicBox.Image = $ASHRegionImage 

$AzureSubscriptionImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\azsubsc.png")
$AzureSubscriptionPicBox = new-object Windows.Forms.PictureBox
$AzureSubscriptionPicBox.Width = $AzureSubscriptionImage.Size.Width
$AzureSubscriptionPicBox.Height = $AzureSubscriptionImage.Size.Height
$AzureSubscriptionPicBox.Top = 155
$AzureSubscriptionPicBox.left = 845
$AzureSubscriptionPicBox.Image = $AzureSubscriptionImage 

##
$AdminPWDImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\pwd.png")
$AdminPWDPicBox = new-object Windows.Forms.PictureBox
$AdminPWDPicBox.Width = $AdminPWDImage.Size.Width
$AdminPWDPicBox.Height = $AdminPWDImage.Size.Height
$AdminPWDPicBox.Top = 195
$AdminPWDPicBox.left = 845
$AdminPWDPicBox.Image = $AdminPWDImage 


$CloudAdminPWDImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\pwd.png")
$CloudAdminPWDImagePicBox = new-object Windows.Forms.PictureBox
$CloudAdminPWDImagePicBox.Width = $CloudAdminPWDImage.Size.Width
$CloudAdminPWDImagePicBox.Height = $CloudAdminPWDImage.Size.Height
$CloudAdminPWDImagePicBox.Top = 235
$CloudAdminPWDImagePicBox.left = 845
$CloudAdminPWDImagePicBox.Image = $CloudAdminPWDImage 

$AZTenantPWDImage = [system.drawing.image]::FromFile("$PSScriptRoot\icons\AzTenant.png")
$AZTenantPicBox = new-object Windows.Forms.PictureBox
$AZTenantPicBox.Width = $AZTenantPWDImage.Size.Width
$AZTenantPicBox.Height = $AZTenantPWDImage.Size.Height
$AZTenantPicBox.Top = 303
$AZTenantPicBox.left = 845
$AZTenantPicBox.Image = $AZTenantPWDImage 



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
$Label01.Left = 10#650#10
$Label01.Top = 15;
$Label01.Width =187;
$label01.Height =40;
$Label01.Text = 'Имя у/з Azure Stack (до @iurnvgru.onmicrosoft.com)';


#Define Label for Azure Active Directory Tenant Name
$Label02 = New-Object “System.Windows.Forms.Label”;
$Label02.Left = 10#650#10
$Label02.Top = 55;
$Label02.Width =187;
$label02.Height =40;
$Label02.Text = 'Пароль учетной записи в Azure Stack';



#define Label for Customer Azure Active Directory SubscriptionID
$Label03 = New-Object “System.Windows.Forms.Label”;
$Label03.Left = 650#10
$Label03.Top = 155;
$Label03.Width =187;
$label03.Height =40;
$Label03.Text = 'Customer Azure Subscription ID';

#define Label for Customer Azure Active Directory Admin Password
$Label04 = New-Object “System.Windows.Forms.Label”;
$Label04.Left = 650#10
$Label04.Top = 195;
$Label04.Width =187;
$label04.Height =40;
$Label04.Text = "Пароль существующей у/з 'Admin' в Azure AD заказчика";

#define Label for Customer Azure Active Directory 'CloudAdmin' Password
$Label05 = New-Object “System.Windows.Forms.Label”;
$Label05.Left = 650#10
$Label05.Top = 235;
$Label05.Width =187;
$label05.Height =40;
$Label05.Text = "Пароль для создания у/з 'cloudadmin' в Azure AD заказчика";

#define Label for Azure Stack Region Name -Combobox0
$Label06 = New-Object “System.Windows.Forms.Label”;
$Label06.Left = 650#10
$Label06.Top = 115;
$Label06.Width =187;
$label06.Height =40;
$Label06.Text = 'Azure Stack Region:'


#Define Label for Azure Active Directory Tenant Name
 $Label1 = New-Object “System.Windows.Forms.Label”;
 $Label1.Left = 650#10
 $Label1.Top = 315;
 $Label1.Width =187;
 $label1.Height = 40;
 $Label1.Text = 'Имя тенанта Azure AD (до .onmicrosoft.com)';

 
 #Define Label for Azure Stack Subscription Name
 $Label2 = New-Object “System.Windows.Forms.Label”;
 $Label2.Left = 650#10;
 $Label2.Top = 355;
 $Label2.Width =187;
 $Label2.Text = 'Azure Stack Subscription Name';

 #create horizontal separator line1
 $hSeparator1 = New-Object “System.Windows.Forms.Label”;
 $hSeparator1.Top =395;
 $hSeparator1.Left = 650#10;
 $hSeparator1.Height =2;
 $hSeparator1.Width =580;
 $hSeparator1.BorderStyle="Fixed3D";

#create horizontal separator line2
$hSeparator2 = New-Object “System.Windows.Forms.Label”;
$hSeparator2.Top =600;
$hSeparator2.Left =965#325;
$hSeparator2.Height =2;
$hSeparator2.Width =260;
$hSeparator2.BorderStyle="Fixed3D";

#create horizontal separator line3
$hSeparator3 = New-Object “System.Windows.Forms.Label”;
$hSeparator3.Top =685;
$hSeparator3.Left =965#325;
$hSeparator3.Height =2;
$hSeparator3.Width =550;
$hSeparator3.BorderStyle="Fixed3D";

#create horizontal separator line4
$hSeparator4 = New-Object “System.Windows.Forms.Label”;
$hSeparator4.Top =760;
$hSeparator4.Left =965#325;
$hSeparator4.Height =2;
$hSeparator4.Width =550;
$hSeparator4.BorderStyle="Fixed3D";
 
#create vertical separator line1
$vSeparator1 = New-Object “System.Windows.Forms.Label”;
$vSeparator1.Top =400;
$vSeparator1.Left =960#320;
$vSeparator1.Height =200;
$vSeparator1.Width =2;
$vSeparator1.BorderStyle="Fixed3D";

#create vertical separator line2
$vSeparator2 = New-Object “System.Windows.Forms.Label”;
$vSeparator2.Top = 605;
$vSeparator2.Left = 960#320;
$vSeparator2.Height = 75;
$vSeparator2.Width = 2;
$vSeparator2.BorderStyle="Fixed3D";

#create vertical separator line3
$vSeparator3 = New-Object “System.Windows.Forms.Label”;
$vSeparator3.Top =690;
$vSeparator3.Left = 960#320;
$vSeparator3.Height =60;
$vSeparator3.Width =2;
$vSeparator3.BorderStyle="Fixed3D";

#create vertical separator line4
$vSeparator4 = New-Object “System.Windows.Forms.Label”;
$vSeparator4.Top =765;
$vSeparator4.Left = 960#320;
$vSeparator4.Height =60;
$vSeparator4.Width =2;
$vSeparator4.BorderStyle="Fixed3D";

#create vertical separator line5
$vSeparator5 = New-Object “System.Windows.Forms.Label”;
$vSeparator5.Top =  155;
$vSeparator5.Left = 600#320;
$vSeparator5.Height = 600;
$vSeparator5.Width = 2;
$vSeparator5.BorderStyle="Fixed3D";



#Define L2bel for Azure Stack IaaS Availability Set Quotes
$Label3 = New-Object “System.Windows.Forms.Label”;
$Label3.Left = 650#10;
$Label3.Top = 405;
$Label3.Width =187;
$Label3.Text = 'Макс. кол-во Availability set';

#Define Label for Azure Stack IaaS vCPUQuotes
$Label4 = New-Object “System.Windows.Forms.Label”;
$Label4.Left = 650#10;
$Label4.Top = 480;
$Label4.Width =187;
$Label4.Text = 'Макс. кол-во vCPU';

#Define Label for Azure Stack IaaS VMScale Sets
$Label5 = New-Object “System.Windows.Forms.Label”;
$Label5.Left = 650#10;
$Label5.Top = 455;
$Label5.Width =187;
$Label5.Text = 'Макс. кол-во VM Scale Sets';

#Define Label for Azure Stack IaaS VMs
$Label6 = New-Object “System.Windows.Forms.Label”;
$Label6.Left = 650#10;
$Label6.Top = 430;
$Label6.Width =187;
$Label6.Text = 'Макс. кол-во Virtual Machines';

#Define Label for Azure Stack IaaS Standard Storage
$Label7 = New-Object “System.Windows.Forms.Label”;
$Label7.Left = 650#10;
$Label7.Top = 520;
$Label7.Width =187;
$Label7.Height =25;
$Label7.Text = 'Макс. объем Managed Disks Standard (Gb)';

#Define Label for Azure Stack IaaS Premium Storage
$Label8 = New-Object “System.Windows.Forms.Label”;
$Label8.Left = 650#10;
$Label8.Top = 548;
$Label8.Width =187;
$Label8.Height =25;
$Label8.Text = 'Макс. объем Managed Disks Premium (Gb)';

 #Define Label for Azure Stack IaaS Virtual Networks Quote
 $Label9 = New-Object “System.Windows.Forms.Label”;
 $Label9.Left = 965#325;
 $Label9.Top = 405;
 $Label9.Width =187;
 $Label9.Text = 'Макс кол-во Virtual Networks';
 
 #Define Label for Azure Stack IaaS Networks adapters
 $Label10 = New-Object “System.Windows.Forms.Label”;
 $Label10.Left = 965#325;
 $Label10.Top = 430;
 $Label10.Width =187;
 $Label10.Text = 'Макс кол-во Network adapters';

#Define Label for Azure Stack IaaS Public IP addresses Quote
$Label11 = New-Object “System.Windows.Forms.Label”;
$Label11.Left = 965#325;
$Label11.Top = 455;
$Label11.Width =187;
$Label11.Text = 'Макс кол-во Public IP';

#Define Label for Azure Stack IaaS Virtual Network Gateways Quote
$Label12 = New-Object “System.Windows.Forms.Label”;
$Label12.Left = 965#325;
$Label12.Top = 480;
$Label12.Width =187;
$Label12.Height =25;
$Label12.Text = 'Макс кол-во Virtual Network Gateways';

#Define Label for Azure Stack IaaS Virtual Network Gateways Connections Quote
$Label13 = New-Object “System.Windows.Forms.Label”;
$Label13.Left = 965#325;
$Label13.Top = 510;
$Label13.Width =187;
$Label13.Height =25;
$Label13.Text = 'Макс кол-во Virtual Network Gateway Connections';

#Define Label for Azure Stack IaaS Load Balancers Quote
$Label14 = New-Object “System.Windows.Forms.Label”;
$Label14.Left = 965#325;
$Label14.Top = 540;
$Label14.Width =187;
$Label14.Height =25;
$Label14.Text = 'Макс кол-во Virtual Load Balancers';

#Define Label for Azure Stack IaaS Load Balancers Quote
$Label15 = New-Object “System.Windows.Forms.Label”;
$Label15.Left = 965#325;
$Label15.Top = 570;
$Label15.Width =187;
$Label15.Height =25;
$Label15.Text = 'Макс кол-во Network Security Groups';

#Define Label for Azure Stack IaaS Unmanaged Storage Quota
$Label16 = New-Object “System.Windows.Forms.Label”;
$Label16.Left = 965#325;
$Label16.Top = 615;
$Label16.Width =187;
$Label16.Height =25;
$Label16.Text = 'Макс объем Unmanaged Storage (Gb)';

#Define Label for Azure Stack IaaS Unmanaged Storage Quota
$Label17 = New-Object “System.Windows.Forms.Label”;
$Label17.Left = 965#325;
$Label17.Top = 645;
$Label17.Width =187;
$Label17.Height =25;
$Label17.Text = 'Макс кол-во Storage Accounts';

#Define L2bel for Azure Stack SQL as Service Quota
$Label18 = New-Object “System.Windows.Forms.Label”;
$Label18.Left = 965#325;
$Label18.Top = 695;
$Label18.Width =167;
$Label18.Height =25;
$Label18.Text = 'Макс объем ресурсов SQL as Service';

#Define L2bel for Azure Stack Web Apps Quota
$Label19 = New-Object “System.Windows.Forms.Label”;
$Label19.Left = 965#325;
$Label19.Top = 765;
$Label19.Width =167;
$Label19.Height =30;
$Label19.Text = 'Макс объем ресурсов Web Apps';

#region create fields for the New Customer creation
#Define Label for creating a Partner Center customer
$Label20 = New-Object “System.Windows.Forms.Label”;
$Label20.Left = 10;
$Label20.Top = 155#15;
$Label20.Width =550;
$Label20.Height =45;
$Label20.font = $Font4Button;
$Label20.Text = 'Введите данные для создания нового заказчика  на Microsoft Partner Center вручную заполнив поля или выполнив импорт данных из CSV файла'

#Define Label for logo
$Label32 = New-Object “System.Windows.Forms.Label”;
$Label32.Left = 800;
$Label32.Top = 20#15;
$Label32.Width =350;
$Label32.Height =25; #65
$Label32.font = $Font4logo
$Label32.Text = 'Привет! Franky твоя помогать!'

#Define Label for region warning 
$Label33 = New-Object “System.Windows.Forms.Label”;
$Label33.Left = 1130;
$Label33.Top = 696#15;
$Label33.Width = 180;
$Label33.Height = 40;
$Label33.ForeColor = 'Red'
$Label33.Text = 'Опция не поддерживается в регионе'
$label33.Visible = $false

#Define Label for region warning 
$Label34 = New-Object “System.Windows.Forms.Label”;
$Label34.Left = 1130;
$Label34.Top = 765#15;
$Label34.Width = 180;
$Label34.Height =40;
$Label34.ForeColor = 'Red'
$Label34.Text = 'Опция не поддерживается в регионе'
$label34.Visible = $false

# Create radio buttons
$RadioButton1 = New-Object System.Windows.Forms.RadioButton
$RadioButton1.Top = 170#30;
$RadioButton1.Left = 10
$RadioButton1.size = '200,100'
$RadioButton1.Checked = $false 
$RadioButton1.Text = "Create new CSP Customer"
$RadioButton1.visible = $false

$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Top = 170#30;
$RadioButton2.Left = 210
#$RadioButton2.size = '200,100'
$RadioButton2.Height = '100'
$RadioButton2.Width = '200'
#$RadioButton2.
$RadioButton2.Checked = $false 

$RadioButton2.Text = "Load existing CSP Customer"
$RadioButton2.visible = $false

#Define TextBox07 for CSV path location;
$TextBox07 = New-Object “System.Windows.Forms.TextBox”;
$TextBox07.Left = 10;
$TextBox07.Top = 230#90;
$TextBox07.width = 370;
$Textbox07.text = ""
$TextBox07.BackColor = "lightblue";
$TextBox07.Visible = $false

#Customer CompanyName;Customer INN;Customer FirstName;Customer LastName;Customer Email;Customer PhoneNumber;Customer AddressLine;Customer City;Customer PostalCode
#Define Label for Company name
$Label21 = New-Object “System.Windows.Forms.Label”;
$Label21.Left   = 10;
$Label21.Top    = 265#255#115;
$Label21.Width  = 150;
$Label21.Height = 25;
$Label21.Text   = 'CompanyName';

#Define TextBox08 for CompanyName;
$TextBox08 = New-Object “System.Windows.Forms.TextBox”;
$TextBox08.Left = 170;
$TextBox08.Top = 265#255#115;
$TextBox08.width = 150;
$Textbox08.text = ""
$TextBox08.BackColor = "lightgray";
$TextBox08.Visible = $true
$TextBox08.readonly = $true

#Define Label22 for INN
$Label22 = New-Object “System.Windows.Forms.Label”;
$Label22.Left   = 10;
$Label22.Top    = 295#285#145;
$Label22.Width  = 150;
$Label22.Height = 25;
$Label22.Text   = 'Company INN';

#Define TextBox09 for INN;
$TextBox09 = New-Object “System.Windows.Forms.TextBox”;
$TextBox09.Left = 170;
$TextBox09.Top = 295#285#145;
$TextBox09.width = 150;
$Textbox09.text = ""
$TextBox09.BackColor = "lightgray";
$TextBox09.Visible = $true
$TextBox09.readonly = $true

#Define Label23 for for Customer FirstName;
$Label23 = New-Object “System.Windows.Forms.Label”;
$Label23.Left   = 10;
$Label23.Top    = 325#315#175;
$Label23.Width  = 150;
$Label23.Height = 25;
$Label23.Text   = 'Customer FirstName';

#Define TextBox10 for Customer FirstName;
$TextBox10 = New-Object “System.Windows.Forms.TextBox”;
$TextBox10.Left = 170;
$TextBox10.Top = 325#315#175;
$TextBox10.width = 150;
$Textbox10.text = ""
$TextBox10.BackColor = "lightgray";
$TextBox10.Visible = $true
$TextBox10.ReadOnly = $true

#Customer LastName;Customer Email;Customer PhoneNumber;Customer AddressLine;Customer City;Customer PostalCode
#Define Label24 for for Customer  Last Name;
$Label24 = New-Object “System.Windows.Forms.Label”;
$Label24.Left   = 10;
$Label24.Top    = 355#345#205;
$Label24.Width  = 150;
$Label24.Height = 25;
$Label24.Text   = 'Customer Last Name';

#Define TextBox11 for Customer Last Name;
$TextBox11 = New-Object “System.Windows.Forms.TextBox”;
$TextBox11.Left = 170;
$TextBox11.Top = 355#345#205;
$TextBox11.width = 150;
$Textbox11.text = ""
$TextBox11.BackColor = "lightgray";
$TextBox11.Visible = $true
$TextBox11.ReadOnly = $true

#Customer LastName;Customer Email;Customer PhoneNumber;Customer AddressLine;Customer City;Customer PostalCode
#Define Label25 for for Customer Email;
$Label25 = New-Object “System.Windows.Forms.Label”;
$Label25.Left   = 10;
$Label25.Top    = 385#375#235;
$Label25.Width  = 150;
$Label25.Height = 25;
$Label25.Text   = 'Customer Email';

#Define TextBox12 for Customer Customer Email;
$TextBox12 = New-Object “System.Windows.Forms.TextBox”;
$TextBox12.Left = 170;
$TextBox12.Top = 385#375#235;
$TextBox12.width = 150;
$Textbox12.text = ""
$TextBox12.BackColor = "lightgray";
$TextBox12.Visible = $true
$TextBox12.ReadOnly = $true

$Label26 = New-Object “System.Windows.Forms.Label”;
$Label26.Left   = 10;
$Label26.Top    = 415#405#265;
$Label26.Width  = 150;
$Label26.Height = 25;
$Label26.Text   = 'Customer PhoneNumber';

#Define TextBox13 for Customer PhoneNumber;
$TextBox13 = New-Object “System.Windows.Forms.TextBox”;
$TextBox13.Left = 170;
$TextBox13.Top = 415#405#265;
$TextBox13.width = 150;
$Textbox13.text = ""
$TextBox13.BackColor = "lightgray";
$TextBox13.Visible = $true
$TextBox13.ReadOnly = $true

#Customer AddressLine;Customer City;Customer PostalCode

$Label27 = New-Object “System.Windows.Forms.Label”;
$Label27.Left   = 10;
$Label27.Top    = 445#435#295;
$Label27.Width  = 150;
$Label27.Height = 25;
$Label27.Text   = 'Customer City';

#Define TextBox14 for Customer  City;
$TextBox14 = New-Object “System.Windows.Forms.TextBox”;
$TextBox14.Left = 170;
$TextBox14.Top = 445#435#295;
$TextBox14.width = 150;
$Textbox14.text = ""
$TextBox14.BackColor = "lightgray";
$TextBox14.Visible = $true
$TextBox14.ReadOnly = $true


$Label28 = New-Object “System.Windows.Forms.Label”;
$Label28.Left   = 10;
$Label28.Top    = 475#465#325;
$Label28.Width  = 150;
$Label28.Height = 25;
$Label28.Text   = 'Customer Address';

#Define TextBox15 for Customer  AddressLine;
$TextBox15 = New-Object “System.Windows.Forms.TextBox”;
$TextBox15.Left = 170;
$TextBox15.Top = 475#465#325;
$TextBox15.width = 150;
$Textbox15.text = ""
$TextBox15.BackColor = "lightgray";
$TextBox15.Visible = $true
$TextBox15.ReadOnly = $true

$Label29 = New-Object “System.Windows.Forms.Label”;
$Label29.Left   = 10;
$Label29.Top    = 505#495#355;
$Label29.Width  = 150;
$Label29.Height = 25;
$Label29.Text   = 'Customer PostalCode';

#Define TextBox16 for Customer  PostalCode;
$TextBox16 = New-Object “System.Windows.Forms.TextBox”;
$TextBox16.Left = 170;
$TextBox16.Top = 505#495#355;
$TextBox16.width = 150;
$Textbox16.text = ""
$TextBox16.BackColor = "lightgray";
$TextBox16.Visible = $true
$TextBox16.ReadOnly = $true

$Label30 = New-Object “System.Windows.Forms.Label”;
$Label30.Left   = 10;
$Label30.Top    = 535#;
$Label30.Width  = 150;
$Label30.Height = 25;
$Label30.Text   = 'Customer Domain';

#Define TextBox17 for Customer  Domain;
$TextBox17 = New-Object “System.Windows.Forms.TextBox”;
$TextBox17.Left = 170;
$TextBox17.Top = 535#;
$TextBox17.width = 150;
$Textbox17.text = ""
$TextBox17.BackColor = "lightgray";
$TextBox17.Visible = $true
$TextBox17.readonly = $true


$Label31 = New-Object “System.Windows.Forms.Label”;
$Label31.Left   = 170;
$Label31.Top    = 565#;
$Label31.Width  = 150;
$Label31.Height = 25;
$label31.Visible = $true
$Label31.Text   = '';
$label31.Font = $Font2

$DebugTextBox = New-Object “System.Windows.Forms.TextBox”;
$DebugTextBox.Left = 170;
$DebugTextBox.Top = 615#;
$DebugTextBox.width = 300;
$DebugTextBox.Multiline = $true
$DebugTextBox.height = 200
$DebugTextBox.text = ""
$DebugTextBox.BackColor = "lightgray";
$DebugTextBox.readonly = $true
$DebugTextBox.Visible = $true


$CheckDomainButton = New-Object “System.Windows.Forms.Button”;
$CheckDomainButton.visible = $false
$CheckDomainButton.Left = 330;
$CheckDomainButton.Top = 535;
$CheckDomainButton.Width = 130;
$CheckDomainButton.Height = 30;
$CheckDomainButton.BackColor = "lightblue";
$CheckDomainButton.Font = $Font;
$CheckDomainButton.Text = “Доступен?”;
$CheckDomainButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$CheckDomainButton.FlatAppearance.BorderSize = 1;
$CheckDomainButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$CheckDomainButton.BackColor = [System.Drawing.Color]::aliceblue  

# Test procedure for Check Credential event handler
$СhkDomainEventHandler = [System.EventHandler]{
    if($script:HeadersState = "NotCreated"){$headers = test-header}
    if($script:HeadersState = "NewCreated"){$headers = test-header}
       

    test-domainavailability -ProposedDomain $($Textbox17.text) -headers $headers 
    $label31.Visible =  $true
    
    if ("$($script:TestResult)" -match "Available" ){$label31.ForeColor ='green' 
                                                     $script:CtmrDomain        =  $($Textbox17.text) 
                                                     if($script:customerInfoFields = "writed") {$CreateNewCustomerButton.visible = $true}
                                                    
                                                    }
    if ("$($script:TestResult)" -match "Not Authenticated"){$label31.ForeColor ='DarkGoldenrod'}
    if ("$($script:TestResult)" -match "Busy"){$label31.ForeColor ='DarkRed'}

    $label31.Text =  "$($script:TestResult)"
    $DebugTextBox.text = "$($script:FailDetails) ` $($script:TestResult) ` $script:HeadersUsed "
}

$CheckDomainButton.Add_Click($СhkDomainEventHandler)


$RadioButton1.Add_Click({
    
    $TextBox07.Visible = $true
    $BrowsCSVButton.visible = $true
})

$RadioButton2.Add_Click({
    
    $TextBox07.Visible = $false
    $BrowsCSVButton.visible = $false
})

[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
#$browse4csv = new-object system.windows.Forms.FolderBrowserDialog
$browse4csv = new-object system.windows.forms.OpenFileDialog
$browse4csv.InitialDirectory = "c:\"
#$browse4csv.RootFolder = [System.Environment+SpecialFolder]'MyComputer'
#$browse4csv.ShowNewFolderButton = $false
#$browse.selectedPath = "C:\"
#$browse4csv.Description = "Choose a customers CSV file path"

$BrowsCSVButton = New-Object system.Windows.Forms.Button
$BrowsCSVButton.Visible = $false
$BrowsCSVButton.Text = "Укажите путь до *.csv файла"
$BrowsCSVButton.Font   = $Font4Button
$BrowsCSVButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$BrowsCSVButton.FlatAppearance.BorderSize = 1;
$BrowsCSVButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$BrowsCSVButton.BackColor = [System.Drawing.Color]::aliceblue 
$BrowsCSVButton.Add_Click({$browse4csv.ShowDialog()
                           $browse4csv.FileNames})
$BrowsCSVButton.left = 430
$BrowsCSVButton.top = 230#90
$BrowsCSVButton.Width  = 160
$BrowsCSVButton.Height = 60

$BrowsCSVButtonEventHandler = [System.EventHandler]{
  $TextBox07.Text = $browse4csv.FileName
  $CSVPath = $TextBox07.Text
  $customers = set-NewCustomersFields -csvpath $CSVPath
  if ($customers.count -eq 1){} # If we have more then one customer in CSV file
  if ($customers.count -gt 1){
    $TextBox08.text = $customers[0].CtmrCompanyName#Define TextBox08 for CompanyName;
    $TextBox09.text = $customers[0].CtmrCompanyRegNum  #Define TextBox09 for INN;
    $TextBox10.text = $customers[0].CtmrFirstName
    $TextBox11.text = $customers[0].CtmrLastName 
    $TextBox12.text = $customers[0].CtmrEmail  
    $TextBox13.text = $customers[0].CtmrPhoneNumber 
    $TextBox14.text = $customers[0].CtmrCity 
    $TextBox15.text = $customers[0].CtmrAddressLine  #Define TextBox09 for INN;
    $TextBox16.text = $customers[0].CtmrPostalCode 
    if ($($TextBox08.text) `
        -and $($TextBox09.text) `
        -and $($TextBox10.text) `
        -and $($TextBox11.text) `
        -and $($TextBox12.text) `
        -and $($TextBox13.text) `
        -and $($TextBox14.text) `
        -and $($TextBox15.text) `
        -and $($TextBox16.text) `
        -and $($TextBox17.text) `
    ){$script:customerInfoFields = "writed"}

    }
} # If we have only one customer in CSV file
$BrowsCSVButton.Add_Click($BrowsCSVButtonEventHandler); 

#create-newcustomer from fields
$CreateNewCustomerButton = New-Object system.Windows.Forms.Button
$CreateNewCustomerButton.Visible = $false
$CreateNewCustomerButton.Text = "Создать нового клиента"
$CreateNewCustomerButton.Font   = $Font4Button
$CreateNewCustomerButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$CreateNewCustomerButton.FlatAppearance.BorderSize = 1;
$CreateNewCustomerButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$CreateNewCustomerButton.BackColor = [System.Drawing.Color]::aliceblue 
$CreateNewCustomerButton.left = 10
$CreateNewCustomerButton.top = 605
$CreateNewCustomerButton.Width  = 160
$CreateNewCustomerButton.Height = 60


<#
$BrowsButton.Add_Click({$browse4csv.ShowDialog()
                  $browse4csv.FileNames})
#>


$CreateNewCustomerButtonEventHandler = [System.EventHandler]{
  $headers = test-header
  $DebugTextBox.Text = ""
  $DebugTextBox.Text = "
  NewCustomer Parameters
  CtmrDomain: $script:CtmrDomain`r`n
  CtmrCompanyName: $($TextBox08.text)`r`n
  CtmrCompanyRegNum: $($TextBox09.text)`r`n
  CtmrFirstName: $($TextBox10.text)`r`n
  CtmrLastName: $($TextBox11.text)`r`n
  CtmrEmail: $($TextBox12.text)`r`n
  CtmrPhoneNumber: $($TextBox13.text)`r`n
  CtmrCity: $($TextBox14.text)`r`n
  CtmrAddressLine: $($TextBox15.text)`r`n
  CtmrPostalCode: $($TextBox16.text)`r`n
  "
<#$script:CtmrDomain#> 
 $NewCSPCustomerProperties = New-CSPCustomer -headers $headers  `
                                  -CtmrDomain  $script:CtmrDomain `
                                  -CtmrCompanyName "$($TextBox08.text)"  `
                                  -CtmrCompanyRegNum "$($TextBox09.text)"  `
                                  -CtmrFirstName "$($TextBox10.text)"  `
                                  -CtmrLastName "$($TextBox11.text)"  `
                                  -CtmrEmail "$($TextBox12.text)" `
                                  -CtmrPhoneNumber "$($TextBox13.text)"  `
                                  -CtmrCity "$($TextBox14.text)"  `
                                  -CtmrAddressLine "$($TextBox15.text)"  `
                                  -CtmrPostalCode "$($TextBox16.text)"  `
                                  -CtmrCountry "RU"

  $DebugTextBox.text = "$($DebugTextBox.Text)`r`n  New customer creation result: $script:NewCustomerDBG`r`n New customer Agreementresult: $script:NewCtmrAgreementDBG 
  `r`nCustomerTenantID: $script:CustomerTenantIDDBG 
  `r`nAgreementDate: $script:NewAgreemntDateDBG 
  `r`nAzure Product List: $script:ProductListDBG 
  `r`nAzurePlanID: $script:AzurePlanIDDBG
  `r`nAzurePlanSKUList: $script:AzurePlanSKUListDBG
  `r`nAzurePlanSKUID: $script:AzurePlanSKUIDDBG
  `r`nshoppingcart_tmpl: $script:shoppingcart_tmplDBG
  `r`nAzureProductAvailbList: $script:AzureProductAvailbListDBG
  `r`nAzureCatalogID: $script:AzureCatalogIDDBG
  `r`nNewShoppingCard: $script:NewShoppingCardDBG
  `r`nNewShoppingCardCheckOut: $script:NewShoppingCardCheckOutDBG
  `r`nAzurePlanSubscriptionID: $script:AzurePlanSubscriptionIDDBG
  `r`nAzureSubscriptionID: $script:AzureSubscriptionIDDBG 
  
  "
  #$NewCSPCustomerOutpath = 'S:\PS-Scripts\CSPScripts'
  #$NewCSPCustomerProperties | Out-File "$NewCSPCustomerOutpath\$($TextBox08.text.replace('"',''))CSPAccount-Details.txt"
  
  $NewCSPCustomerProperties | Out-File "$CSPResultPath\$($TextBox08.text.replace('"',''))CSPAccount-Details.txt"
  write-host -ForegroundColor Green "CSP Customer creation details writed to a file: $CSPResultPath\$($TextBox08.text.replace('"',''))CSPAccount-Details.txt"

  $TextBox1.text  = $Script:NewCSPCustomerProperties.CustomerDomain #'Имя тенанта (до .onmicrosoft.com)'
  # $Script:NewCSPCustomerProperties.CustomerDomainAdminName
  if($customers){
      
    $TextBox2.Text  = "$($customers[0].CtmrCompanyName)" #Azure Stack Subsciption name = Company Name
    }
  else {$TextBox2.Text = $Textbox08.text }
  
  
  $TextBox04.text = $Script:NewCSPCustomerProperties.CustomerAzureSubscriptionID #Customer Azure Subscription ID
  $TextBox05.text = $Script:NewCSPCustomerProperties.CustomerDomainAdminPWD #Customer Azure AD admin password
  $TextBox06.text = $Script:NewCSPCustomerProperties.CustomerDomainCloudAdminPWD #Customer Azure Subscription ID
 

  
  # $Script:NewCSPCustomerProperties.CustomerAdminPWDResetDetails


}
$CreateNewCustomerButton.Add_Click($CreateNewCustomerButtonEventHandler )



####



#region Fill new customer fields
if( $($TextBox08.text) -and 
    $($TextBox09.text) -and 
    $($TextBox10.text) -and 
    $($TextBox11.text) -and 
    $($TextBox12.text) -and  
    $($TextBox13.text) -and
    $($TextBox14.text) -and
    $($TextBox15.text) -and
    $($TextBox16.text) -and
    $CtmrDomain){} #can run creation only if this field is valid






#endregion


#if ($RadioButton1.Checked ){$TextBox07.Visible = "$true"}

#endregion


#Define TextBox01 for input Azure Stack account name
$TextBox01 = New-Object "System.Windows.Forms.TextBox";
$TextBox01.Left = 210#850#210;
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
$TextBox02.Left = 210#850#210;
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
$TextBox0002.Left = 210#850#210;
$TextBox0002.Top = 55;
$TextBox0002.width = 220;
$TextBox0002.BackColor = "lightblue";
$TextBox0002.visible =$false       
 #Define show pwd button1

$ShPwdButton1 = New-Object “System.Windows.Forms.Button”;
$ShPwdButton1.Left = 460#1100#460;
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
$TextBox03.Left = 210#850#210;
$TextBox03.Top = 90;
$TextBox03.width = 300;
$TextBox03.Multiline = $true;
$TextBox03.height = 60;
$TextBox03.BackColor = "lightblue";
$TextBox03.Visible = $False

#Define TextBox04 for Customer Azure Subscription ID
$TextBox04 = New-Object "System.Windows.Forms.TextBox";
$TextBox04.readonly =$true
$TextBox04.Left = 880#210;
$TextBox04.Top = 155;
$TextBox04.width = 220;
$TextBox04.text = "введите Azure Subscription ID"
#$TextBox04.Multiline = $true;
#$TextBox04.height = 60;
$TextBox04.BackColor = "lightgray";

#Define TextBox05 for Customer Azure AD admin password
$TextBox05 = New-Object "System.Windows.Forms.MaskedTextBox";
$TextBox05.readonly =$true
$TextBox05.Left = 880#210;
$TextBox05.Top = 195;
$TextBox05.width = 220;
$TextBox05.BackColor = "lightgray";
$Textbox05.PasswordChar = "*";

$Textbox05ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Textbox05ToolTip.ShowAlways =$true;
$Textbox05ToolTip.SetToolTip($TextBox05,"Пароль уже установленный при создании у/з 'admin' в Azure AD заказчика");
$Textbox05ToolTip.InitialDelay = 0;

 #Define TextBox0005 for SHOW Azure AD admin password
 $TextBox0005 = New-Object "System.Windows.Forms.TextBox";
 $TextBox0005.Left = 880#210;
 $TextBox0005.Top = 195;
 $TextBox0005.width = 220;
 $TextBox0005.BackColor = "lightblue";
 $TextBox0005.visible =$false       

 #Define show pwd button2
 $ShPwdButton2 = New-Object “System.Windows.Forms.Button”;
 $ShPwdButton2.Left = 1130#460;
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
$TextBox06.readonly = $true
$TextBox06.Left = 880#210;
$TextBox06.Top = 235;
$TextBox06.width = 220;
$TextBox06.BackColor = "lightgray";
$Textbox06.PasswordChar = "*";

$Testbox06ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox06ToolTip.ShowAlways =$true;
$Testbox06ToolTip.SetToolTip($TextBox06,"Пароль для создания у/з 'cloudadmin' в Azure AD заказчика");
$Testbox06ToolTip.InitialDelay = 0;

 #Define TextBox0005 for SHOW Azure AD CLOUDADMIN  password
 $TextBox0006 = New-Object "System.Windows.Forms.TextBox";
 $TextBox0006.Left = 880#210;
 $TextBox0006.Top = 235;
 $TextBox0006.width = 220;
 $TextBox0006.BackColor = "lightblue";
 $TextBox0006.visible =$false       

 #Define show pwd button3
 $ShPwdButton3 = New-Object “System.Windows.Forms.Button”;
 $ShPwdButton3.Left = 1130#460;
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
$TextBox1.readonly = $true
$TextBox1.Left = 880#210;
$TextBox1.Top = 310;
$TextBox1.width = 220;
$Textbox1.text = "короткое имя - например TenanName"
$TextBox1.BackColor = "lightgray";

$Testbox1ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox1ToolTip.ShowAlways =$true;
$Testbox1ToolTip.SetToolTip($TextBox1,"Имя тенанта Azure Active Directory (до .onmicrosoft.com), которое было выбрано при создании заказчика на сайте partner.microsoft.com");
$Testbox1ToolTip.InitialDelay = 0;


#Define TextBox2 for Label2 - 'Azure Stack Subscription Name'
$TextBox2 = New-Object “System.Windows.Forms.TextBox”;
$TextBox2.readonly = $true
$TextBox2.Left = 880#210;
$TextBox2.Top = 355;
$TextBox2.width = 220;
$TextBox2.BackColor = "lightgray";
$TextBox2.Text = "например ООО Сетконс"

$Testbox2ToolTip = New-Object "System.Windows.Forms.ToolTip";
$Testbox2ToolTip.ShowAlways =$true;
$Testbox2ToolTip.SetToolTip($TextBox2,"Наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com");
$Testbox2ToolTip.InitialDelay = 0;

#Define ComboBox for Label3 'Azure Stack Region Name'
#$CValues=@("AzureMSK","MSKNorth");
$ComboBox0 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox0.DroppedDown = $true;
$ComboBox0.Left = 880#240;
$ComboBox0.Top  = 115;
$ComboBox0.Width = 225;
$ComboBox0.BackColor ="lightgray";
$ComboBox0.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter their own vaalues in combobox
#$ComboBox0.Items.AddRange($CValues);
#$ComboBox1.Items.AddRange('0');
#$ComboBox1.selectedindex = 1 # set default value - index for the values array
#$ComboBox1.selectedindex = 0 # set default value - index for the values array

# Hiding options  - not supported in the choosen Azure Stack region 
$ComboBox0_ValueChanged =
{
    if($combobox0.SelectedItem -match "MSKNorth"){
    
    $ComboBox16.hide() #SQL
    $ComboBox17.hide() #WebApps
    $label33.Visible = $true
    $label34.Visible = $true

    }
    if($combobox0.SelectedItem -match "AzureMSK"){
    
    $ComboBox16.show() #SQL
    $ComboBox17.show() #WebApps
    $label33.Visible = $false
    $label34.Visible = $false

    }
    
}
$ComboBox0.add_SelectedIndexChanged($ComboBox0_ValueChanged)

#Define ComboBox for Label3 'Макс кол-во Availability set'
$CValues=@("1","2","3","4");
$ComboBox1 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox1.DroppedDown = $true;
$ComboBox1.Left = 880#240;
$ComboBox1.Top = 405;
$ComboBox1.Width =60;
$ComboBox1.BackColor ="lightgray";
$ComboBox1.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter their own values in combobox
#$ComboBox1.Items.AddRange($CValues);
#$ComboBox1.Items.AddRange('0');
#$ComboBox1.selectedindex = 1 # set default value - index for the values array
#$ComboBox1.selectedindex = 0 # set default value - index for the values array


#Define ComboBox for Label4 'Макс кол-во vCPU'
$CValues=@(1..64);
$ComboBox2 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox2.DroppedDown = $true;
$ComboBox2.Left = 880#240;
$ComboBox2.Top = 480;
$ComboBox2.Width =60;
$ComboBox2.BackColor ="lightgray";
$ComboBox2.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox2.Items.AddRange($CValues);
#$ComboBox2.Items.AddRange('0');
#$ComboBox2.selectedindex = 7 # set default value - index for the values array
#$ComboBox2.selectedindex = 0

#Define ComboBox for Label5 'Макс кол-во VM Scale Sets'
$CValues=@(1..8);
$ComboBox3 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox3.DroppedDown = $true;
$ComboBox3.Left = 880#240;
$ComboBox3.Top = 455;
$ComboBox3.Width =60;
$ComboBox3.BackColor ="lightgray";
$ComboBox3.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox3.Items.AddRange($CValues);
#$ComboBox3.Items.AddRange('0');
#$ComboBox3.selectedindex = 0 # set default value - index for the values array


#Define ComboBox for Label6 'Макс кол-во Virtual Machines'
$CValues=@(1..32);
$ComboBox4 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox4.DroppedDown = $true;
$ComboBox4.Left = 880#240;
$ComboBox4.Top = 430;
$ComboBox4.Width =60;
$ComboBox4.BackColor ="lightgray";
$ComboBox4.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox4.Items.AddRange($CValues);
#$ComboBox4.Items.AddRange('0');
#$ComboBox4.selectedindex = 3 # set default value - index for the values array

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

#$NumbersSequence = @() # from 128 till 20480
#for ($i=128;$i -le 20480;$i+=128){$NumbersSequence+=$i}
#Define ComboBox for Label7 'Макс объем Managed Disks Standard (Gb)'
#$ComboBox5Values=$NumbersSequence
#$CValues=@(128,256,384,512,640,768,896,1024,1152,1280,1408,1536,1664,1792,1920,2048,2176,2304,2432,2560,2688,2816,2944,3072,3200,3328,3456,3584,3712,3840,3968,4096,4224,4352,4480,4608,4736,4864,4992,5120,5248,5376,5504,5632,5760,5888,6016,6144,6272,6400,6528,6656,6784,6912,7040,7168,7296,7424,7552,7680,7808,7936,8064,8192,8320,8448,8576,8704,8832,8960,9088,9216,9344,9472,9600,9728,9856,9984,10112,10240,10368,10496,10624,10752,10880,11008,11136,11264,11392,11520,11648,11776,11904,12032,12160,12288,12416,12544,12672,12800,12928,13056,13184,13312,13440,13568,13696,13824,13952,14080,14208,14336,14464,14592,14720,14848,14976,15104,15232,15360,15488,15616,15744,15872,16000,16128,16256,16384,16512,16640,16768,16896,17024,17152,17280,17408,17536,17664,17792,17920,18048,18176,18304,18432,18560,18688,18816,18944,19072,19200,19328,19456,19584,19712,19840,19968,20096,20224,20352,20480);
$ComboBox5 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox5.DroppedDown = $true;
$ComboBox5.Left = 880#240;
$ComboBox5.Top = 520;
$ComboBox5.Width =60;
$ComboBox5.BackColor ="lightgray";
$ComboBox5.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox5.Items.AddRange('0');
#$ComboBox5.Items.AddRange($ComboBox5Values);
#$ComboBox5.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label8 'Макс объем Managed Disks Premium (Gb)'
#$ComboBox6Values = $NumbersSequence;
$ComboBox6 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox6.DroppedDown = $true;
$ComboBox6.Left = 880#240;
$ComboBox6.Top = 548;
$ComboBox6.Width =60;
$ComboBox6.BackColor ="lightgray";
$ComboBox6.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox6.Items.AddRange('0');
#$ComboBox6.Items.AddRange($ComboBox6Values);
#$ComboBox6.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label9 'Макс кол-во Virtual Networks'
#$CValues=@(1..10);
$ComboBox7 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox7.DroppedDown = $true;
$ComboBox7.Left = 1195#555;
$ComboBox7.Top = 405;
$ComboBox7.Width =60;
$ComboBox7.BackColor ="lightgray";
$ComboBox7.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox7.Items.AddRange($CValues);
#$ComboBox7.Items.AddRange('0');
#$ComboBox7.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label10 'Макс кол-во Network adapters'
#$CValues=@(1..32);
$ComboBox8 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox8.DroppedDown = $true;
$ComboBox8.Left = 1195#555;
$ComboBox8.Top = 430;
$ComboBox8.Width =60;
$ComboBox8.BackColor ="lightgray";
$ComboBox8.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox8.Items.AddRange($CValues);
#$ComboBox8.Items.AddRange('0');
#$ComboBox8.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label11 'Макс кол-во Public IP'
#$CValues=@(1..10);
$ComboBox9 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox9.DroppedDown = $true;
$ComboBox9.Left = 1195#555;
$ComboBox9.Top = 455;
$ComboBox9.Width =60;
$ComboBox9.BackColor ="lightgray";
$ComboBox9.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox9.Items.AddRange($CValues);
#$ComboBox9.Items.AddRange('0');
#$ComboBox9.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label12 'Макс кол-во Virtual Network Gateways'
#$CValues=@(0,1,2);
$ComboBox10 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox10.DroppedDown = $true;
$ComboBox10.Left = 1195#555;
$ComboBox10.Top = 480;
$ComboBox10.Width =60;
$ComboBox10.BackColor ="lightgray";
$ComboBox10.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox10.Items.AddRange($CValues);
#$ComboBox10.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label13 'Макс кол-во Virtual Network Gateway Connections'
#$CValues=@(0,1,2);
$ComboBox11 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox11.DroppedDown = $true;
$ComboBox11.Left = 1195#555;
$ComboBox11.Top = 507;
$ComboBox11.Width =60;
$ComboBox11.BackColor ="lightgray";
$ComboBox11.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox11.Items.AddRange($CValues);
#$ComboBox11.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label14 'Макс кол-во Virtual Load Balancers'
#$CValues=@(1..8);
$ComboBox12 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox12.DroppedDown = $true;
$ComboBox12.Left = 1195#555;
$ComboBox12.Top = 532;
$ComboBox12.Width =60;
$ComboBox12.BackColor ="lightgray";
$ComboBox12.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox12.Items.AddRange($CValues);
#$ComboBox12.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label15 'Макс кол-во Network Security Groups'
#$CValues=@(1..32);
$ComboBox13 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox13.DroppedDown = $true;
$ComboBox13.Left = 1195#555;
$ComboBox13.Top = 557;
$ComboBox13.Width =60;
$ComboBox13.BackColor ="lightgray";
$ComboBox13.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox13.Items.AddRange($CValues);
#$ComboBox13.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label16 'Макс объем Unmanaged Storage (Gb)'
#$CValues=@(128,256,512,1024,2048,3072,4096,5120,6144,7168,8192,9216,10240,16384,20480);
$ComboBox14 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox14.DroppedDown = $true;
$ComboBox14.Left = 1195#525;
$ComboBox14.Top = 615;
$ComboBox14.Width =60;
$ComboBox14.BackColor ="lightgray";
$ComboBox14.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox14.Items.AddRange($CValues);
#$ComboBox14.selectedindex = 3 # set default value - index for the values array

#Define ComboBox for Label17  'Макс кол-во Storage Accounts';
#$CValues=@(1..20);
$ComboBox15 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox15.DroppedDown = $true;
$ComboBox15.Left = 1195#525;
$ComboBox15.Top = 645;
$ComboBox15.Width =60;
$ComboBox15.BackColor ="lightgray";
$ComboBox15.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox15.Items.AddRange($CValues);
#$ComboBox15.selectedindex = 1 # set default value - index for the values array

#Define ComboBox for Label18 'Макс объем ресурсов SQL as Service'
#$CValues=@("10GB 5DB","10GB 10DBs","100GB 10DBs");
$ComboBox16 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox16.DroppedDown = $true;
$ComboBox16.Left = 1165#495;
$ComboBox16.Top = 696;
$ComboBox16.Width =90;
$ComboBox16.BackColor ="lightgray";
$ComboBox16.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own vaalues in combobox
#$ComboBox16.Items.AddRange($CValues);
#$ComboBox16.selectedindex = 0 # set default value - index for the values array

#Define ComboBox for Label19 'Макс объем ресурсов Web Apps'
#$CValues=@("1 App SP","3 App SP","Evaluation");
$ComboBox17 = New-Object "System.Windows.Forms.ComboBox";
$ComboBox17.DroppedDown = $true;
$ComboBox17.Left = 1165#495;
$ComboBox17.Top = 765;
$ComboBox17.Width =90;
$ComboBox17.BackColor ="lightgray";
$ComboBox17.DropDownStyle=[System.Windows.Forms.ComboBoxStyle]::DropDownList; # to prevent user to enter theirr own values in combobox

#$ComboBox17.Items.AddRange($CValues);
#$ComboBox17.selectedindex = 2 # set default value - index for the values array




#Define OK Button
$CreateButton = New-Object “System.Windows.Forms.Button”;
$CreateButton.visible = $false
$CreateButton.Left = 1060#420;
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

write-host "CreateSubscription Button Pushed" -ForegroundColor Cyan
                                        
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


$AZSAdminSubscrUserName = $TextBox01.Text
$AZSAdminSubscrPwd = $TextBox02.Text
#$CustomerAzureSubscrID = $TextBox04.text #
#$TenantName = $TextBox1.text+".onmicrosoft.com" # -> имя тенанта Azure Active Directory (до @onmicrosoft.com), которое было выбрано  при создании заказчика на сайте partner.microsoft.com
#$SubscriptionName  = $TextBox2.Text # -> наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com
#$AzureTenantCstmrCloudAdminPwd = $TextBox06.text
#$AzureTenantCstmrAdmin  = "admin@$TenantName"
#$AzureTenantCstmrAdminPwd = $TextBox05.text

if($combobox0.SelectedItem -match "MSKNorth"){$AZSRegionName = "msknorth"}
if($combobox0.SelectedItem -match "AzureMSK"){$AZSRegionName = "azuremsk"}


if ($TextBox04.text -notmatch "введите")  {$CustomerAzureSubscrID = $TextBox04.text; $TextBox04.BackColor = "LightBlue" }       else {$CustomerAzureSubscrID = "NotSet"; $TextBox04.BackColor = "LightCoral"}
if ($TextBox1.text -notmatch "например")  {$TenantName = $TextBox1.text+".onmicrosoft.com" ;$TextBox1.BackColor = "LightBlue"}  else {$TenantName = "NotSet"; $TextBox1.BackColor = "LightCoral"} # -> имя тенанта Azure Active Directory (до @onmicrosoft.com), которое было выбрано  при создании заказчика на сайте partner.microsoft.com
if ($TextBox2.Text -notmatch "например")  {$SubscriptionName  = $TextBox2.Text; $TextBox2.BackColor = "LightBlue"}              else {$SubscriptionName = "NotSet"; $TextBox2.BackColor = "LightCoral"}    # -> наименование организации заказчика, которое было указано при создании заказчика на сайте partner.microsoft.com
if ($TextBox05.text) {$AzureTenantCstmrAdminPwd = $TextBox05.text; $TextBox05.BackColor = "LightBlue"}      else {$AzureTenantCstmrAdminPwd = "NotSet"; $TextBox05.BackColor = "LightCoral" }
if ($TextBox06.text) {$AzureTenantCstmrCloudAdminPwd = $TextBox06.text; $TextBox06.BackColor = "LightBlue"} else {$AzureTenantCstmrCloudAdminPwd = "NotSet"; $TextBox06.BackColor = "LightCoral" }

if ($TenantName -notmatch "NotSet" ) {$AzureTenantCstmrAdmin  = "admin@$TenantName"} else {$AzureTenantCstmrAdmin  = "NotSet"}


if($ComboBox1.SelectedItem)  {$IaaS_CQ_AvailSetCount      = [int]$ComboBox1.SelectedItem; $ComboBox1.BackColor = "LightBlue" }  else {$IaaS_CQ_AvailSetCount   = "NotSet"; $ComboBox1.BackColor = "LightCoral"} 
if($ComboBox2.SelectedItem)  {$IaaS_CQ_CoresCount         = [int]$ComboBox2.SelectedItem; $ComboBox2.BackColor = "LightBlue" }  else {$IaaS_CQ_CoresCount      = "NotSet"; $ComboBox2.BackColor = "LightCoral"}
if($ComboBox3.SelectedItem)  {$IaaS_CQ_VMScaleSetCount    = [int]$ComboBox3.SelectedItem; $ComboBox3.BackColor = "LightBlue" }  else {$IaaS_CQ_VMScaleSetCount = "NotSet"; $ComboBox3.BackColor = "LightCoral"}
if($ComboBox4.SelectedItem)  {$IaaS_CQ_VMMachineCount     = [int]$ComboBox4.SelectedItem; $ComboBox4.BackColor = "LightBlue" }  else {$IaaS_CQ_VMMachineCount  = "NotSet"; $ComboBox4.BackColor = "LightCoral"}
if($ComboBox5.SelectedItem)  {$IaaS_CQ_STDStorageSize     = [int]$ComboBox5.SelectedItem; $ComboBox5.BackColor = "LightBlue" }  else {$IaaS_CQ_STDStorageSize  = "NotSet"; $ComboBox5.BackColor = "LightCoral"}
if($ComboBox6.SelectedItem)  {$IaaS_CQ_PREMStorageSize    = [int]$ComboBox6.SelectedItem; $ComboBox6.BackColor = "LightBlue" }  else {$IaaS_CQ_PREMStorageSize = "NotSet"; $ComboBox6.BackColor = "LightCoral"}
if($ComboBox7.SelectedItem)  {$IaaS_NQ_VNetCount          = [int]$ComboBox7.SelectedItem; $ComboBox7.BackColor = "LightBlue" }  else {$IaaS_NQ_VNetCount       = "NotSet"; $ComboBox7.BackColor = "LightCoral"}
if($ComboBox8.SelectedItem)  {$IaaS_NQ_NicsCount          = [int]$ComboBox8.SelectedItem; $ComboBox8.BackColor = "LightBlue" }  else {$IaaS_NQ_NicsCount       = "NotSet"; $ComboBox8.BackColor = "LightCoral"}
if($ComboBox9.SelectedItem)  {$IaaS_NQ_PIPCount           = [int]$ComboBox9.SelectedItem; $ComboBox9.BackColor = "LightBlue" }  else {$IaaS_NQ_PIPCount        = "NotSet"; $ComboBox9.BackColor = "LightCoral"}
if($ComboBox10.SelectedItem -in @(0,1,2)) {$IaaS_NQ_VNGCount  = [int]$ComboBox10.SelectedItem; $ComboBox10.BackColor = "LightBlue"  } else {$IaaS_NQ_VNGCount  = "NotSet"; $ComboBox10.BackColor = "LightCoral"} 
if($ComboBox11.SelectedItem) {$IaaS_NQ_VNGConCount        = [int]$ComboBox11.SelectedItem; $ComboBox11.BackColor = "LightBlue"  } else {$IaaS_NQ_VNGConCount   = "NotSet"; $ComboBox11.BackColor = "LightCoral"}
if($ComboBox12.SelectedItem) {$IaaS_NQ_LBCount            = [int]$ComboBox12.SelectedItem; $ComboBox12.BackColor = "LightBlue"  } else {$IaaS_NQ_LBCount       = "NotSet"; $ComboBox12.BackColor = "LightCoral"} 
if($ComboBox13.SelectedItem) {$IaaS_NQ_SGCount            = [int]$ComboBox13.SelectedItem; $ComboBox13.BackColor = "LightBlue"  } else {$IaaS_NQ_SGCount       = "NotSet"; $ComboBox13.BackColor = "LightCoral"}
if($ComboBox14.SelectedItem) {$IaaS_SQ_Capacity           = [int]$ComboBox14.SelectedItem; $ComboBox14.BackColor = "LightBlue"  } else {$IaaS_SQ_Capacity      = "NotSet"; $ComboBox14.BackColor = "LightCoral"}
if($ComboBox15.SelectedItem) {$IaaS_SQ_SACount            = [int]$ComboBox15.SelectedItem; $ComboBox15.BackColor = "LightBlue"  } else {$IaaS_SQ_SACount       = "NotSet"; $ComboBox15.BackColor = "LightCoral"}
if($ComboBox16.SelectedItem) {$SQLQuotaName               = ($ComboBox16.SelectedItem).ToString().Replace(" ",""); $ComboBox16.BackColor = "LightBlue" } else {$SQLQuotaName = "NotSet"; $ComboBox16.BackColor = "LightCoral"}
#$WebQuotaName            =   $ComboBox17.SelectedItem
if($ComboBox17.SelectedItem){
    if ($ComboBox17.SelectedItem -eq "1 App SP"){$WebQuotaName = "ext-1AppSP-web"; $ComboBox17.BackColor = "LightBlue" }
    if ($ComboBox17.SelectedItem -eq "3 App SP"){$WebQuotaName = "ext-3AppSP-web"; $ComboBox17.BackColor = "LightBlue" }
    if ($ComboBox17.SelectedItem -eq "Evaluation"){$WebQuotaName = "Evaluation"; $ComboBox17.BackColor = "LightBlue" }
} else {$WebQuotaName = "NotSet"; $ComboBox17.BackColor = "LightCoral"}

    #$AZSAdminSubscrUserName `
    #  `
    #-and $AzureTenantCstmrAdmin
    # -and $TenantName `
    
    #if ( ($AzureTenantCstmrCloudAdminPwd) -and (($AZSRegionName -match "msknorth") -or ($AZSRegionName -match "azuremsk")) `
if (  ($CustomerAzureSubscrID              -notmatch "NotSet" `
      -and  $TenantName                    -notmatch "NotSet" `
      -and  $SubscriptionName              -notmatch "NotSet" `
      -and  $AzureTenantCstmrAdmin         -notmatch "NotSet" `
      -and  $AzureTenantCstmrAdminPwd      -notmatch "NotSet" `
      -and  $AzureTenantCstmrCloudAdminPwd -notmatch "NotSet" `
      -and  $IaaS_CQ_AvailSetCount         -notmatch "NotSet" `
      -and  $IaaS_CQ_CoresCount            -notmatch "NotSet" `
      -and  $IaaS_CQ_VMScaleSetCount       -notmatch "NotSet" `
      -and  $IaaS_CQ_VMMachineCount        -notmatch "NotSet" `
      -and  $IaaS_CQ_STDStorageSize        -notmatch "NotSet" `
      -and  $IaaS_CQ_PREMStorageSize       -notmatch "NotSet" `
      -and  $IaaS_NQ_VNetCount             -notmatch "NotSet" `
      -and  $IaaS_NQ_NicsCount             -notmatch "NotSet" `
      -and  $IaaS_NQ_PIPCount              -notmatch "NotSet" `
      -and  $IaaS_NQ_VNGCount              -notmatch "NotSet" `
      -and  $IaaS_NQ_VNGConCount           -notmatch "NotSet" `
      -and  $IaaS_NQ_LBCount               -notmatch "NotSet" `
      -and  $IaaS_NQ_SGCount               -notmatch "NotSet" `
      -and  $IaaS_SQ_Capacity              -notmatch "NotSet" `
      -and  $IaaS_SQ_SACount               -notmatch "NotSet" `
     ) -and  (
               ($AZSRegionName -match "msknorth") `
           -or (($AZSRegionName -match "azuremsk") `
                -and  ($SQLQuotaName  -notmatch "NotSet") `
                -and  ($WebQuotaName  -notmatch "NotSet") `
               )
             )
 ){
    write-host "All parameters provided" -ForegroundColor Green
    write-host "AZSAdminSubscrUserName: $AZSAdminSubscrUserName"     
    write-host "AZSAdminSubscrPwd: $AZSAdminSubscrPwd "
    
    New-AZSOnboarding  -AZSRegionName $AZSRegionName `
                       -AZSAdminSubscrUserName $AZSAdminSubscrUserName `
                       -AZSAdminSubscrPwd $AZSAdminSubscrPwd `
                       -CustomerAzureSubscrID $CustomerAzureSubscrID `
                       -TenantName $TenantName `
                       -SubscriptionName $SubscriptionName `
                       -AzureTenantCstmrCloudAdminPwd $AzureTenantCstmrCloudAdminPwd `
                       -AzureTenantCstmrAdmin $AzureTenantCstmrAdmin `
                       -AzureTenantCstmrAdminPwd $AzureTenantCstmrAdminPwd `
                       -IaaS_CQ_AvailSetCount $IaaS_CQ_AvailSetCount `
                       -IaaS_CQ_CoresCount $IaaS_CQ_CoresCount `
                       -IaaS_CQ_VMScaleSetCount $IaaS_CQ_VMScaleSetCount `
                       -IaaS_CQ_VMMachineCount $IaaS_CQ_VMMachineCount `
                       -IaaS_CQ_STDStorageSize $IaaS_CQ_STDStorageSize `
                       -IaaS_CQ_PREMStorageSize $IaaS_CQ_PREMStorageSize `
                       -IaaS_NQ_VNetCount $IaaS_NQ_VNetCount `
                       -IaaS_NQ_NicsCount $IaaS_NQ_NicsCount `
                       -IaaS_NQ_PIPCount $IaaS_NQ_PIPCount `
                       -IaaS_NQ_VNGCount $IaaS_NQ_VNGCount `
                       -IaaS_NQ_VNGConCount $IaaS_NQ_VNGConCount `
                       -IaaS_NQ_LBCount $IaaS_NQ_LBCount `
                       -IaaS_NQ_SGCount $IaaS_NQ_SGCount `
                       -IaaS_SQ_Capacity $IaaS_SQ_Capacity `
                       -IaaS_SQ_SACount $IaaS_SQ_SACount `
                       -SQLQuotaName $SQLQuotaName `
                       -WebQuotaName $WebQuotaName  



 } else {
    write-host -ForegroundColor Yellow "Please provide all required parameters to continue"
 }


#$script:FormFields = new-object psobject
#$script:FormFields | add-member –membertype NoteProperty –name AZSAdminSubscrUserName –value NotSet #
#$script:FormFields | add-member –membertype NoteProperty –name AZSAdminSubscrPwd –value NotSet     #
#$script:FormFields | add-member –membertype NoteProperty –name CustomerAzureSubscrID –value NotSet#
#$script:FormFields | add-member –membertype NoteProperty –name TenantName –value NotSet           #
#$script:FormFields | add-member –membertype NoteProperty –name SubscriptionName –value NotSet     #
#$script:FormFields | add-member –membertype NoteProperty –name AzureTenantCstmrCloudAdminPwd –value NotSet #
#$script:FormFields | add-member –membertype NoteProperty –name AzureTenantCstmrAdmin –value NotSet#
#$script:FormFields | add-member –membertype NoteProperty –name AzureTenantCstmrAdminPwd –value NotSet#
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_AvailSetCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_CoresCount  –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_VMScaleSetCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_VMMachineCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_STDStorageSize –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_CQ_PREMStorageSize –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_VNetCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_NicsCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_PIPCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_VNGCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_VNGConCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_LBCount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_NQ_SGCount  –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_SQ_Capacity   –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name IaaS_SQ_SACount –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name SQLQuotaName –value NotSet
#$script:FormFields | add-member –membertype NoteProperty –name WebQuotaName –value NotSet

#$script:FormFields.AZSAdminSubscrUserName    = $AZSAdminSubscrUserName
#$script:FormFields.AZSAdminSubscrPwd         = $AZSAdminSubscrPwd
#$script:FormFields.CustomerAzureSubscrID     = $CustomerAzureSubscrID
#$script:FormFields.TenantName                = $TenantName
#
#$script:FormFields.SubscriptionName                    = $SubscriptionName
#$script:FormFields.AzureTenantCstmrCloudAdminPwd       = $AzureTenantCstmrCloudAdminPwd
#$script:FormFields.AzureTenantCstmrAdmin               = $AzureTenantCstmrAdmin 
#$script:FormFields.AzureTenantCstmrAdminPwd            = $AzureTenantCstmrAdminPwd
#$script:FormFields.IaaS_CQ_AvailSetCount               = $IaaS_CQ_AvailSetCount
#$script:FormFields.IaaS_CQ_CoresCount                  = $IaaS_CQ_CoresCount 
#$script:FormFields.IaaS_CQ_VMScaleSetCount             = $IaaS_CQ_VMScaleSetCount
#$script:FormFields.IaaS_CQ_VMMachineCount              = $IaaS_CQ_VMMachineCount
#$script:FormFields.IaaS_CQ_STDStorageSize              = $IaaS_CQ_STDStorageSize
#$script:FormFields.IaaS_CQ_PREMStorageSize             = $IaaS_CQ_PREMStorageSize
#$script:FormFields.IaaS_NQ_VNetCount                   = $IaaS_NQ_VNetCount
#$script:FormFields.IaaS_NQ_NicsCount                   = $IaaS_NQ_NicsCount
#$script:FormFields.IaaS_NQ_PIPCount                    = $IaaS_NQ_PIPCount
#$script:FormFields.IaaS_NQ_VNGCount                    = $IaaS_NQ_VNGCount
#$script:FormFields.IaaS_NQ_VNGConCount                 = $IaaS_NQ_VNGConCount
#$script:FormFields.IaaS_NQ_LBCount                     = $IaaS_NQ_LBCount
#$script:FormFields.IaaS_NQ_SGCount                     = $IaaS_NQ_SGCount
#$script:FormFields.IaaS_SQ_Capacity                    = $IaaS_SQ_Capacity
#$script:FormFields.IaaS_SQ_SACount                     = $IaaS_SQ_SACount
#$script:FormFields.SQLQuotaName                        = $SQLQuotaName
#$script:FormFields.WebQuotaName                        = $WebQuotaName  




#return $script:FormFields
#$Form.Close();
}
$CreateButton.Add_Click($CreateButtonEventHandler) ;

#Define check cred button

$CheckCredButton = New-Object “System.Windows.Forms.Button”;
$CheckCredButton.Left = 10#650#10;
$CheckCredButton.Top = 90;
$CheckCredButton.Width = 160;
$CheckCredButton.Height = 50;
$CheckCredButton.BackColor = "lightblue";
$CheckCredButton.Font = $Font4Button;
$CheckCredButton.Text = “Войти в систему”;
$CheckCredButton.FlatStyle = [System.Windows.Forms.FlatStyle]::flat;
$CheckCredButton.FlatAppearance.BorderSize = 1;
$CheckCredButton.FlatAppearance.BorderColor = [System.Drawing.Color]::Gainsboro
$CheckCredButton.BackColor = [System.Drawing.Color]::aliceblue  

<#

#>


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
}

$AuthenticateEventHandler = [System.EventHandler]{

    Get-Secrets -AZSUserName $TextBox01.Text -AZSPassword $TextBox02.Text
    $TextBox03.Visible = $true
    if ($global:CredCheckState -eq "correct"){$TextBox03.ForeColor = "green"
    $RadioButton1.visible = $true
    $RadioButton2.visible = $true
    $TextBox08.ReadOnly =$false
    $TextBox08.BackColor = "lightblue";
    

    $TextBox1.ReadOnly =$false
    $TextBox1.BackColor = "lightblue";

    $TextBox2.ReadOnly =$false
    $TextBox2.BackColor = "lightblue";

    $TextBox04.ReadOnly =$false
    $TextBox04.BackColor = "lightblue";

    $TextBox05.ReadOnly =$false
    $TextBox05.BackColor = "lightblue";

    $TextBox06.ReadOnly =$false
    $TextBox06.BackColor = "lightblue";



    $TextBox09.ReadOnly =$false
    $TextBox09.BackColor = "lightblue";

    $TextBox10.ReadOnly =$false
    $TextBox10.BackColor = "lightblue";

    $TextBox11.ReadOnly =$false
    $TextBox11.BackColor = "lightblue";

    $TextBox12.ReadOnly =$false
    $TextBox12.BackColor = "lightblue";

    $TextBox13.ReadOnly =$false
    $TextBox13.BackColor = "lightblue";

    $TextBox14.ReadOnly =$false 
    $TextBox14.BackColor = "lightblue";

    $TextBox15.ReadOnly =$false
    $TextBox15.BackColor = "lightblue";

    $TextBox16.ReadOnly =$false
    $TextBox16.BackColor = "lightblue";

    $TextBox17.ReadOnly =$false
    $TextBox17.BackColor = "lightblue";

    $DebugTextBox.ReadOnly = $false
    $DebugTextBox.BackColor = "lightblue";
    

    $CheckDomainButton.visible = $true
    
    #Activating Comboboxes

    ##
    $CB0Values=@("AzureMSK Hybrid(HDD+SSD)-КЦОД","MSKNorth AllFlash(SSD)-DataPro");
    $ComboBox0.Items.AddRange($CB0Values)
    $ComboBox0.selectedindex = 0
    $ComboBox0.BackColor ="lightblue";

    $CB1Values=@("1","2","3","4");
    $ComboBox1.Items.AddRange($CB1Values)
    $ComboBox1.selectedindex = 1 
    $ComboBox1.BackColor ="lightblue";
    
    
    ##
    $CB2Values=@(1..64);
    $ComboBox2.Items.AddRange($CB2Values);
    $ComboBox2.selectedindex = 7
    $ComboBox3.BackColor ="lightblue";
    
    ##
    $CB3Values=@(1..8);
    $ComboBox3.Items.AddRange($CB3Values);
    $ComboBox3.selectedindex = 0
    $ComboBox3.BackColor ="lightblue";
    
    ##
    $CB4Values=@(1..32);
    $ComboBox4.Items.AddRange($CB4Values);
    $ComboBox4.BackColor ="lightblue";
    $ComboBox4.selectedindex = 3
    
    ##
    $NumbersSequence = @() # from 128 till 20480
    for ($i=128;$i -le 20480;$i+=128){$NumbersSequence+=$i}
    $CB5Values=$NumbersSequence
    $ComboBox5.Items.AddRange($CB5Values);
    $ComboBox5.BackColor ="lightblue";
    $ComboBox5.selectedindex = 3
    
    ##
    $CB6Values = $NumbersSequence;
    $ComboBox6.Items.AddRange($CB6Values);
    $ComboBox6.BackColor ="lightblue";
    $ComboBox6.selectedindex = 3
    
    #
    $CB7Values=@(1..10);
    $ComboBox7.Items.AddRange($CB7Values);
    $ComboBox7.selectedindex = 0
    $ComboBox7.BackColor ="lightblue";
    
    #
    $CB8Values=@(1..32);
    $ComboBox8.Items.AddRange($CB8Values);
    $ComboBox8.selectedindex = 3 
    $ComboBox8.BackColor ="lightblue";
    
    #
    $CB9Values=@(1..10);
    $ComboBox9.Items.AddRange($CB9Values);
    $ComboBox9.selectedindex = 0
    $ComboBox9.BackColor ="lightblue";
    
    ##
    $CB10Values=@(0,1,2);
    $ComboBox10.Items.AddRange($CB10Values);
    $ComboBox10.selectedindex = 0
    $ComboBox10.BackColor ="lightblue";
    
    ##
    $CB11Values=@(1..8);
    $ComboBox11.Items.AddRange($CB11Values);
    $ComboBox11.selectedindex = 0 
    $ComboBox11.BackColor ="lightblue";
    
    ##
    $CB12Values=@(1..8);
    $ComboBox12.Items.AddRange($CB12Values);
    $ComboBox12.selectedindex = 0
    $ComboBox12.BackColor ="lightblue";
    
    ##
    $CB13Values=@(1..32);
    $ComboBox13.Items.AddRange($CB13Values);
    $ComboBox13.selectedindex = 3 
    $ComboBox13.BackColor ="lightblue";
    
    #
    ##
    $CB14Values=@(128,256,512,1024,2048,3072,4096,5120,6144,7168,8192,9216,10240,16384,20480);
    $ComboBox14.Items.AddRange($CB14Values);
    $ComboBox14.selectedindex = 3
    $ComboBox14.BackColor ="lightblue";
    
    ##
    $CB15Values=@(1..20);
    $ComboBox15.Items.AddRange($CB15Values);
    $ComboBox15.selectedindex = 1 
    $ComboBox15.BackColor ="lightblue";
    
    ##
    $CB16Values=@("10GB 5DB","10GB 10DBs","100GB 10DBs");
    $ComboBox16.Items.AddRange($CB16Values);
    #$ComboBox16.selectedindex = 0
    $ComboBox16.BackColor ="lightblue";
    
    ##
    $CB17Values=@("1 App SP","3 App SP","Evaluation");
    $ComboBox17.Items.AddRange($CB17Values);
    #$ComboBox17.selectedindex = 2 
    $ComboBox17.BackColor ="lightblue";
    
    #
    $CreateButton.visible = $true
    
    

    }
    if ($global:CredCheckState -eq "warning"){$TextBox03.ForeColor = "DarkGoldenRod"}
    if ($global:CredCheckState -eq "fail"){$TextBox03.ForeColor = "red"}
    $TextBox03.Text = "$global:OutputMsg "# atoken: $global:atoken"
    #$TextBox03.Text = "Token: $global:atoken"# atoken: $global:atoken"
    $TextBox03.ReadOnly = $true

    
}


<#
$PCenterAccessToken = $global:atoken
    
if ($PCenterAccessToken){
$headers = @{
    'api-version' = 'v1'
    'Accept' = 'application/json'           
    'Authorization' = "Bearer $PCenterAccessToken"
    'Host' = 'api.partnercenter.microsoft.com'
}
}

#>
                                                                            
#$CheckCredButton.Add_Click($СhkCredEventHandler) ;
$CheckCredButton.Add_Click($AuthenticateEventHandler)
 #Add controls to the Form
#$Form.Controls.Add($checkBox1);
$Form.Controls.Add($CheckCredButton);
$Form.Controls.Add($ShPwdButton1);
$Form.Controls.Add($ShPwdButton2);
$Form.Controls.Add($ShPwdButton3);
$Form.Controls.Add($CreateButton);
$Form.Controls.Add($CheckDomainButton);
$Form.Controls.Add($CreateNewCustomerButton);
$Form.Controls.Add($Label01);
$Form.Controls.Add($Label02);
$Form.Controls.Add($Label03);
$Form.Controls.Add($Label04);
$Form.Controls.Add($Label05);
$Form.Controls.Add($Label06);
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
$Form.Controls.Add($Label20);
$Form.Controls.Add($Label21);
$Form.Controls.Add($Label22);
$Form.Controls.Add($Label23);
$Form.Controls.Add($Label24);
$Form.Controls.Add($Label25);
$Form.Controls.Add($Label26);
$Form.Controls.Add($Label27);
$Form.Controls.Add($Label28);
$Form.Controls.Add($Label29);
$Form.Controls.Add($Label30);
$Form.Controls.Add($Label31);
$Form.Controls.Add($Label32);
$Form.Controls.Add($Label33);
$Form.Controls.Add($Label34);
$Form.Controls.Add($TextBox01);
$Form.Controls.Add($TextBox02);
$Form.Controls.Add($TextBox0002);
$Form.Controls.Add($TextBox0005);
$Form.Controls.Add($TextBox0006);
$Form.Controls.Add($TextBox03);
$Form.Controls.Add($TextBox04);
$Form.Controls.Add($TextBox05);
$Form.Controls.Add($TextBox06);
$Form.Controls.Add($TextBox07);
$Form.Controls.Add($TextBox08);
$Form.Controls.Add($TextBox09);
$Form.Controls.Add($TextBox10);
$Form.Controls.Add($TextBox11);
$Form.Controls.Add($TextBox12);
$Form.Controls.Add($TextBox13);
$Form.Controls.Add($TextBox14);
$Form.Controls.Add($TextBox15);
$Form.Controls.Add($TextBox16);
$Form.Controls.Add($TextBox17);
$Form.Controls.Add($DebugTextBox);
$Form.Controls.Add($TextBox1);
$Form.Controls.Add($TextBox2);
$Form.Controls.Add($TextBox3);
$form.Controls.Add($ComboBox0);
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
$form.Controls.Add($vSeparator5);
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
$form.Controls.Add($LogoPicBox);
$form.Controls.Add($ASHRegionPicBox);
$form.Controls.Add($AzureSubscriptionPicBox);
$form.Controls.Add($AdminPWDPicBox);
$form.Controls.Add($AZTenantPicBox);
$form.Controls.Add($CloudAdminPWDImagePicBox);
$form.Controls.Add($RadioButton1);
$form.Controls.Add($RadioButton2);
$form.Controls.Add($BrowsCSVButton);

$form.add_Closing({
    Write-Host 'Form Closed'
    # code to release any created in form
    $script:FormFields = "FormCLosedByUser"
})

$Form.ShowDialog()|Out-Null



return $script:FormFields
}


