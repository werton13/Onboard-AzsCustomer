function get-scriptartifacts {

$IconsURL = "https://onboardscriptartefacts.blob.azuremsk.ec.mts.ru/pics/icons.zip?st=2020-04-19T21%3A00%3A00Z&se=2021-04-22T18%3A28%3A00Z&sp=rl&sv=2017-04-17&sr=b&sig=e07ZTbmHvTFmdWQdEYvJpU3elxgbARDIl0Y01NA85Lo%3D"
$IconsDownloadPath = "$PSScriptRoot\icons.zip"


if ((Test-Path -PathType Container -Path "$PSScriptRoot\icons") -eq $false){

    Invoke-WebRequest -Uri $IconsURL -OutFile $IconsDownloadPath
    if (test-path -Path "$IconsDownloadPath"){
        Expand-Archive -LiteralPath $IconsDownloadPath -DestinationPath $PSScriptRoot
        Remove-Item $IconsDownloadPath -Force
        }
}
}