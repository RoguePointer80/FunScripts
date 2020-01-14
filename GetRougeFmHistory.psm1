function Get-RougeFmHistory
{
    $resp = Invoke-WebRequest -Uri "https://rp.iheartradio.ca/callsign/CITEFM?pageSize=50&page=1"
    $songs = ($resp.Content | ConvertFrom-Json).songs
    Write-Output ($songs | Select-Object -Property @{Name="date"; Expression={[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddMilliSeconds($_.datetime))}}, song, artist)
}
