function Grant-CloudOps
{
param (
    [string]$clientSecret,
    [string]$username = "CloudOpsAutomation",
    [string]$authServerUri = "https://platformdev.cloud.coveo.com/oauth/token?grant_type=client_credentials"
 )
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