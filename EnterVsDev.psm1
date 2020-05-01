function Enter-VsDev
{
    Import-Module 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
    Enter-VsDevShell -SetDefaultWindowTitle -InstallPath 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise' -StartInPath $pwd.Path
}