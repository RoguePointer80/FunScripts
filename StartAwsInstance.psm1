function Start-AwsInstance
{
param (
    [string]$ami = $( Read-Host "Specify AMI to start" ),
    [switch]$verbose,
    [switch]$connect,
    [string]$user = "jenkins"
 )
$WellKnownAmis = @{ cglbaselib = "ami-068dd53e06b56b941";
                    core = "ami-00c65c8297612fd83";
                    windows2019  = "ami-08dd25c657c5ee0f0"}
if($WellKnownAmis.ContainsKey($ami)) {
    $ami = $WellKnownAmis[$ami]
}

Write-Host "Starting EC2 instance for AMI $ami"

$filename = [System.IO.Path]::GetRandomFileName()
$proc = Start-Process -FilePath "aws" -Wait -NoNewWindow -PassThru -RedirectStandardOutput $filename -ArgumentList ("ec2 run-instances "+ `
 "--image-id $ami "+ `
 "--count 1 "+ `
 "--instance-type m5.2xlarge "+ `
 "--key-name dev-packer-keypair "+ `
 "--security-group-ids sg-4adfc73e "+ `
 "--subnet-id subnet-e64148ae "+ `
 "--iam-instance-profile Name=ndev-jenkins-agent " + `
 "--tag-specifications ResourceType=instance,Tags=[{Key=coveo:owner,Value=frivard@coveo.com},{Key=Name,Value=frivard-temp},{Key=coveo:schedule-default,Value=false},{Key=coveo:schedule-disabled,Value=true}]")

$instanceAddr = ""
$instanceId = ""
$launchTime = Get-Date
$content = Get-Content -Path $filename
if($proc.ExitCode -eq 0){
    $js = Get-Content -Path $filename | ConvertFrom-Json
    $instanceId = $js.Instances[0].InstanceId
    $instanceAddr = $js.Instances[0].PrivateIpAddress
    if($verbose){
        Write-Output $js.Instances[0]
    }
    else
    {
        $output = [pscustomobject]@{ID=$instanceId; IP=$instanceAddr}
        Write-Output $output
    }
} else {
    Write-Host "return code was $($proc.ExitCode)"
    Write-Host "stdout: $content"
}
Remove-Item $filename

if($connect){
    $instanceReady = $false
    $attempts = 1;
    while(($attempts -le 10) -and (-not $instanceReady)){
        $attemptTime = Get-Date
        Write-Host "[$attemptTime] Attempt $attempts..."
        $instanceReady = Test-NetConnection -ComputerName $instanceAddr -Port 22 -InformationLevel Quiet
        $attempts = $attempts + 1
    }
    if($instanceReady) {
        $delayToReady = (Get-Date).Subtract($launchTime)
        Write-Host "Ready!"
        $sessionStart = Get-Date
        ssh $user@$instanceAddr
        $sessionDuration = (Get-Date).Subtract($sessionStart)
        Write-Host "SSH session to instance $instanceId at $instanceAddr terminated. It took $delayToReady to get connected. Session lasted $sessionDuration."
    }
    else {
        Write-Host "Timed out!"
    }
}

}
