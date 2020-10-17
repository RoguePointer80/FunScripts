function Get-Shell
{
    param (
        [Parameter(Mandatory=$true)][string]$toolname
    )

    Write-Host "All your commands will be prefixed with ""$toolname"". Type ""exit"" to break out ➡️🚪."
    do{
        $cmdSuffix  = Read-Host "🐚 ${toolname} ❓"
        if($cmdSuffix -eq "exit")
        {
            break;
        }
        Invoke-Expression "$toolname $cmdSuffix"
    }while($true)
    Write-Host '👋 👋'
}
