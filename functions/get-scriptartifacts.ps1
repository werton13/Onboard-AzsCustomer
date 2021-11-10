function get-scriptartifacts {

$IconsURL = "https://onboardscriptartefacts.blob.azuremsk.ec.mts.ru/pics/icons.zip?sv=2019-02-02&st=2021-10-12T08%3A00%3A00Z&se=2022-10-13T20%3A00%3A00Z&sr=b&sp=r&sig=wj1U8121ov3tw5RHqnEqZgypzzy67V5LDKZDT%2Bb%2BVng%3D"
$IconsDownloadPath = "$PSScriptRoot\icons.zip"


if ((Test-Path -PathType Container -Path "$PSScriptRoot\icons") -eq $false){

    Invoke-WebRequest -Uri $IconsURL -OutFile $IconsDownloadPath
    if (test-path -Path "$IconsDownloadPath"){
        Expand-Archive -LiteralPath $IconsDownloadPath -DestinationPath $PSScriptRoot
        Remove-Item $IconsDownloadPath -Force
        }
}
}

