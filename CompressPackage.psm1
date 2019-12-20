function Compress-Package
{
    param (
    [string]$Path
    )
    $filesToZip = Get-ChildItem -Recurse -File -Name -Path $Path
    Push-Location $Path
    ForEach( $fileToZip in $filesToZip){
        Compress-Archive -Path $fileToZip -Destination "$fileToZip.zip"
        Remove-Item $fileToZip
        Move-Item -Path "$fileToZip.zip" -Destination $fileToZip
    }
    Pop-Location
}

