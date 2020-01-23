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

function Publish-PackageToS3
{
    param (
        [string]$org = $( Read-Host "Package organization: " ),
        [string]$name = $( Read-Host "Package name: " ),
        [string]$rev = $( Read-Host "Package revision: " )
    )

    $ivyCache = 'C:\dev\Projects\.ivycache'
    $cachePath = (Join-Path $ivyCache $org $name $rev)
    $tempPath = [System.IO.Path]::GetTempPath()
    $destination = Join-Path $tempPath $org $name $rev
    Write-Host "Copying from $cachePath to $destination"
    Copy-Item -Path $cachePath -Destination $destination -Recurse
    Write-Host "Removing ivy.xml.original"
    Remove-Item  (Join-Path $destination 'ivy.xml.original')
    Write-Host "Compressing folder"
    Compress-Package $destination
    $s3Destination = "s3://coveo-ndev-binaries/ivy/external/$($org.Replace('.','/'))/$name/$rev/"
    Write-Host "Uploading folder $destination to $s3Destination"
    aws s3 cp $destination $s3Destination --recursive
    Write-Host "Clean up folder $destination"
    Remove-Item -Path $destination -Recurse
}
