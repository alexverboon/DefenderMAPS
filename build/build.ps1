

$param = @{
    Name = "LocalPSRepository"
    SourceLocation = "C:\Dev\MyLocalRepo"
    InstallationPolicy = "Trusted"
}
Register-PSRepository @param

Publish-Module -Path "C:\Temp\DefenderMaps" -Repository "LocalPSRepository"

Publish-Module -Path "C:\temp\DefenderMaps" -NuGetApiKey ###