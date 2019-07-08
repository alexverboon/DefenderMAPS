
function Test-MapsConnection
{
<#
.Synopsis
   Test-MapsConnection
.DESCRIPTION
   Use Test-MapsConnection to verify that your client can 
   communicate with the Windows Defender Antivirus cloud service

.EXAMPLE
   Test-MapsConnection

   The above command verifies connectivity with the Windows Defender
   Antivirus cloud service (MAPS)

#>
    [CmdletBinding()]
    Param
    ()

    Begin
    {
        If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] “Administrator”))
        {
            Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
            Break
        }
    }
    Process
    {
    # Find the current most recent path of the Defender mpcmdrun.exe
    $DefenderPlatformPath = "C:\ProgramData\Microsoft\Windows Defender\Platform"
    Write-Verbose "Defender Platform Path: $DefenderPlatformPath\..."
    $mpcmdrunpath = (Get-ChildItem  -Path "$DefenderPlatformPath\*\mpcmdrun.exe" | Select-Object * -Last 1).FullName

        If ([string]::IsNullOrEmpty($mpcmdrunpath))
        {
            Write-Warning "Unable to locate mpcmdrun.exe in path $DefenderPlatformPath\..."
            $MAPSConnectivity = $false
        }
    Else
        {
            Write-Verbose "Defender mpcmdrun path: $mpcmdrunpath"

            $cmdArg =  "-validatemapsconnection"
            $CheckResult = Start-Process -FilePath "$mpcmdrunpath" -ArgumentList "$cmdArg" -WindowStyle Hidden -PassThru -Wait 
	    # $CheckResult.ExitCode
            $MAPSConnectivity = switch ($CheckResult.ExitCode)
            {
                0 { $true}
                default {$false}
            }
        }
    }
    End
    {
	    If ($MAPSConnectivity -eq "True")
	    {
	        Write-verbose "ValidateMapsConnection successfully established a connection to MAPS"
	    }
        Else
        {
            
            $MapsErrorDetail = ($CheckResult.ExitCode).ToString()

            Write-Verbose "ValidateMapsConnection failed: $MapsErrorDetail"
        }
    $MAPSConnectivity
    }
}