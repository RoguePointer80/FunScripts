function Grant-CloudOps
{
param (
    [string]$env = "dev",
    [string]$username = "CloudOpsAutomation"
 )
$ssmNames = @{
    dev = "/dev/ops/OAuth/CloudOpsAutomation/clientSecret";
    qa = "/qa/ops/OAuth/CloudOpsAutomation/clientSecret"
}
$authServers = @{
    dev = "https://platformdev.cloud.coveo.com/oauth/token?grant_type=client_credentials";
    qa = "https://platformqa.cloud.coveo.com/oauth/token?grant_type=client_credentials"
}
Write-Host "environment is $env"
$ssmParam = $ssmNames[$env]
$authServerUri = $authServers[$env]
Write-Host "ssm is $ssmParam and server is $authServerUri"
$clientSecret = ((aws ssm get-parameter --region us-east-1 --name $ssmParam --with-decryption) | ConvertFrom-Json).Parameter.Value
Write-Host "got secret $clientSecret"
$pair = "$($username):$($clientSecret)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{
    Authorization = $basicAuthValue
}
$reply = Invoke-WebRequest -Uri $authServerUri -Method Post -Headers $headers
Write-Host "Status code: $($reply.StatusCode)."
$replyObj = ConvertFrom-Json $reply.Content
Write-Output $replyObj.access_token
}