function Update-TgfVersion
{
param (
    [string]$version = $( Read-Host "Specify new version" )
 )
    $tag = 'docker-image-version:'
    $regex = "$tag\s*.+$"
    $currentLocation = Get-Location
    Write-Host "Looking for files under $($currentLocation.Path)"
    $filesToCHeck = Get-ChildItem -Recurse -File -Filter '.tgf.config' -Path $currentLocation.Path
    ForEach( $fileToCheck in $filesToCheck){
        Write-Host "Found $fileToCheck"
        ((Get-Content -Path  $fileToCheck -Encoding UTF8) -replace $regex,"$tag $version") `
            | Set-Content -Path $fileToCheck -Encoding UTF8
    }
}