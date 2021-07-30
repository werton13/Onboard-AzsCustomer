function set-NewCustomersFields {

    param(
   [string]$CSVPath
)


$CtmrDetailsFromCSV = Import-Csv -Delimiter ';' -Path $CSVPath -Encoding UTF8

$script:Customers =@()

$CtmrDetailsFromCSV | % {

$CtmrEmail          = "$($_.'Customer Email')"
$CtmrCompanyName    = "$($_.'Customer CompanyName')"
$CtmrCompanyRegNum  = "$($_.'Customer INN')"
$CtmrFirstName      = "$($_.'Customer FirstName')"
$CtmrLastName       = "$($_.'Customer LastName')"
$CtmrPhoneNumber    = "$($_.'Customer PhoneNumber')"
$CtmrAddressLine    = "$($_.'Customer AddressLine')"
$CtmrCity           = "$($_.'Customer City')"
$CtmrPostalCode     = "$($_.'Customer PostalCode')"
$CtmrCountry        = "RU"

$CustomerDetails = new-object psobject
$CustomerDetails | add-member -membertype NoteProperty -name CtmrEmail -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrCompanyName -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrCompanyRegNum -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrFirstName -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrLastName -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrPhoneNumber -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrAddressLine -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrCity -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrPostalCode -value NotSet
$CustomerDetails | add-member -membertype NoteProperty -name CtmrCountry -value NotSet


$CustomerDetails.CtmrEmail          = $CtmrEmail
$CustomerDetails.CtmrCompanyName    = $CtmrCompanyName
$CustomerDetails.CtmrCompanyRegNum  = $CtmrCompanyRegNum
$CustomerDetails.CtmrFirstName      = $CtmrFirstName
$CustomerDetails.CtmrLastName       = $CtmrLastName
$CustomerDetails.CtmrPhoneNumber    = $CtmrPhoneNumber
$CustomerDetails.CtmrAddressLine    = $CtmrAddressLine
$CustomerDetails.CtmrCity           = $CtmrCity
$CustomerDetails.CtmrPostalCode     = $CtmrPostalCode
$CustomerDetails.CtmrCountry        = $CtmrCountry

$script:Customers += $CustomerDetails

}
return $script:Customers
}