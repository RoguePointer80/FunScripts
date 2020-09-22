function Enter-VsDev
{
    Import-Module 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
    Enter-VsDevShell -SetDefaultWindowTitle -InstallPath 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise' -StartInPath $pwd.Path -DevCmdArguments '-arch=x64 -no_logo'
}

function covb
{
    param(
    [string] $buildTarget = "Build",
    [string] $buildConfiguration = "Debug"
  )
  Write-Host "msbuild /t:$buildTarget /p:BuildTarget=$buildConfiguration /p:UseJunctions=False /p:RegisterDlls=False /p:UnitTests=True /nologo /nodeReuse:False -consoleloggerparameters:Summary;ForceNoAlign -verbosity:minimal -fileLogger -flp:verbosity=normal;LogFile=msbuild.$buildTarget.log"
  msbuild /t:$buildTarget /p:BuildTarget=$buildConfiguration /p:UseJunctions=False /p:RegisterDlls=False /p:UnitTests=True /nologo /nodeReuse:False "-consoleloggerparameters:Summary;ForceNoAlign" -verbosity:minimal -fileLogger "-flp:verbosity=normal;LogFile=msbuild.$buildTarget.log"
}