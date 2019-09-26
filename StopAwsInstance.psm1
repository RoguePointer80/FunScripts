function Stop-AwsInstance
{
param (
    [string]$instance = $( Read-Host "Instance ID to terminate" )
 )
write-output "Terminating EC2 instance $instance"
$filename = [System.IO.Path]::GetRandomFileName()
$proc = Start-Process -FilePath "aws" -NoNewWindow -PassThru -Wait -RedirectStandardOutput $filename -ArgumentList "ec2 terminate-instances --instance-ids $instance"
$content = Get-Content -Path $filename
if($proc.ExitCode -eq 0){
    $js = Get-Content -Path $filename | ConvertFrom-Json
    $firstInstance = $js.TerminatingInstances[0].CurrentState
    Write-Host "code $($js.TerminatingInstances[0].CurrentState.Code) : $($js.TerminatingInstances[0].CurrentState.Name) "
} else {
    Write-Host "return code was $($proc.ExitCode)"
    Write-Host "stdout: $content"
}
Remove-Item $filename
}