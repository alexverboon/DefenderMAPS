﻿# ----------------------------------------------------------
# Module Build and publishing
# v1.0, 01.08.2020
# Alex Verboon
# ----------------------------------------------------------
# Module Source
$ModuleName = "DefenderMAPS"
$ParentFolder = [IO.Directory]::GetParent($PSScriptRoot)
$ModuleSourceDir = "$ParentFolder" + "\$ModuleName"
Write-host "Module Source: $ModuleSourceDir" -ForegroundColor Green

# Local Repository
$LocalPSRepository = "C:\Dev\MyLocalRepo"
If (-not (Test-path -Path $LocalPSRepository -PathType Container))
{
    Write-Host "Creating Local Repository Folder" -ForegroundColor Yellow
    New-Item -Path "$LocalPSRepository"
}

# Repository Parameters
$param = @{
    Name = "LocalPSRepository"
    SourceLocation = "$LocalPSRepository"
    InstallationPolicy = "Trusted"
}

$Repos = Get-PSRepository -Name "LocalPSRepository"
If ($null -eq $Repos)
{
    Write-Host "Registering Local Repository" -ForegroundColor Yellow
    Register-PSRepository @param 
}
Else
{
    Write-Host "Local Repository 'LocalRepository' is present" -ForegroundColor Green
}

## Module Manifest Testing
$ModuleManifest = Get-ChildItem -Path "$ModuleSourceDir\*.psd1"
$TestManifest = Test-ModuleManifest -Path "$($ModuleManifest.FullName)"

## ScriptAnalyzer
#Install-Module -Name PSScriptAnalyzer -force -Scope CurrentUser
#Invoke-ScriptAnalyzer -Path "$ModuleSourceDir"

## Publish  Module into local repository
Write-host  "Publishing Module into local repository" -ForegroundColor Green
Publish-Module -Path "$ModuleSourceDir" -Repository "LocalPSRepository" -Verbose

## Install Module from local Repository
#Write-Host "Installing module " -ForegroundColor Green
#Find-module -Name "$ModuleName" -Repository "LocalPSRepository" | Install-Module -Scope CurrentUser -Force

Write-host  "Publishing Module into PSGallery" -ForegroundColor Green
$pskey = ""
Publish-Module -Path "$ModuleSourceDir" -NuGetApiKey $pskey  -Verbose 