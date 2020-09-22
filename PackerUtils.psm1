function Build-PackerImage
{
    param (
        [Parameter(Mandatory=$true)][string]$packerFile,
        [Parameter(Mandatory=$true)][string]$AmiVersion,
        [string]$privateKey = "~/Downloads/dev-packer-private-key.pem"
    )

    $WorkDir = (Get-Item $packerFile).Directory.FullName
    $JsonFile = (Get-Item $packerFile).Name
    $KeyFile = (Get-Item $privateKey).Name
    Write-Host "Using Docker Desktop to build $packerFile into $AmiVersion"
    Write-Host "Working directory: $WorkDir"
    Push-Location $WorkDir
    $gitRepo = (git config --get remote.origin.url) -replace "https://.*@", "https://"
    $gitShortSha = (git rev-parse --short HEAD)
    $KeyCopied = $false
    $KeyDestination = Join-Path $WorkDir $KeyFile
    if( !(Test-Path $KeyDestination)){
        Write-Host "Copying key to $KeyDestination"
        Copy-Item -Path $privateKey -Destination $KeyDestination
        $KeyCopied = $true
    }

    $DOCKER_IMAGE = "hashicorp/packer:light"
    docker pull $DOCKER_IMAGE

    $JenkinsUsername = "jenkins"
    $JenkinsPassword = "H76YTPj#X!LWVe"
    $AwsAccessKeyId = (aws configure get default.aws_access_key_id)
    $AwsSecretKey = (aws configure get default.aws_secret_access_key)

    docker run "--env" "GIT_FILE=$packerFile" `
               "--env" "GIT_REPOSITORY=$gitRepo" `
               "--env" "GIT_SHA=$gitShortSha" `
               "--env" "JENKINS_PASSWORD=$JenkinsPassword" `
               "--env" "PACKER_PRIVATE_KEYFILE=$KeyFile" `
               "--env" "VERSION=$AmiVersion" `
               "--env" "AWS_ACCESS_KEY_ID=$AwsAccessKeyId" `
               "--env" "AWS_SECRET_ACCESS_KEY=$AwsSecretKey" `
               "--env" "AWS_DEFAULT_REGION=us-east-1" `
               "--volume" "${WorkDir}:/coveo_data" `
               "--workdir" "/coveo_data" `
               $DOCKER_IMAGE `
               "build" "-timestamp-ui" "$JsonFile"

    if($KeyCopied){
        Remove-Item $KeyDestination
    }
    Pop-Location
}
