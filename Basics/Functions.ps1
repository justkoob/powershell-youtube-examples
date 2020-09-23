using namespace System.Collections
using namespace Microsoft.Win32

<#
.SYNOPSIS
  An example of functions in powershell.
.DESCRIPTION
  Example of different functions (methods) and how to use them.
.NOTES
  Author: justkoob
  Creation Date: 09/21/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
  Find me on Github: https://www.github.com/justkoob
#>

# Basic example
function New-NameValuePair {
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [string]$Value = "None"
  )
    Write-Verbose "Creating hashtable for Name: $Name; Value: $Value."

    $obj = @{
      $Name = $Value
    }

    Write-Verbose "Returning hashtable for Name: $Name; Value: $Value.`n"
    return $obj
}

New-NameValuePair -Name "MyName1" -Value "MyValue"
New-NameValuePair -Name "MyName2"

# Advanced examples
<#
.SYNOPSIS
  Converts registry keys to an array of ps custom objects.
.DESCRIPTION
  Takes a RegistryKey array and adds to a reference object 'ArrayList'.
.NOTES
  Author: justkoob
  Creation Date: 09/22/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
  Find me on Github: https://www.github.com/justkoob
#>
function ConvertFrom-ApplicationRegistryKey {
  [CmdLetBinding(DefaultParameterSetName = "Default")]
  param(
    # InputObject to be used for creating ps custom objects
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [RegistryKey[]]$InputObject,
    # Reference object ArrayList
    [Parameter(Mandatory = $true)]
    [AllowEmptyCollection()]
    [ArrayList][ref]$ArrayList
  )
  begin {
  }
  process {
    foreach ($key in $InputObject) {
      
      $keyType = "32-bit"

      if ([Environment]::Is64BitOperatingSystem -and
        $key.Name -notmatch "WOW6432Node") {
          $keyType = "64-bit"
      }

      $obj = [PSCustomObject]@{
        DisplayName = $key.GetValue("DisplayName")
        InstallLocation = $key.GetValue("InstallLocation")
        DisplayVersion = $key.GetValue("DisplayVersion")
        InstallDate = $key.GetValue("InstallDate")
        UninstallString = $key.GetValue("UninstallString")
        Type = $keyType
      }

      $arrayList.Add($obj) | Out-Null
    }
  }
  end {
  }
}

<#
.SYNOPSIS
  Retrieves a list of installed applications that match provided 'Name'.
.DESCRIPTION
  Using provided 'Name' retrieves a list of installed applications from the registry.
.NOTES
  Author: justkoob
  Creation Date: 09/22/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
  Find me on Github: https://www.github.com/justkoob
#>
function Get-ApplicationInstall {
  [CmdLetBinding(DefaultParameterSetName = "Default")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [switch]$Latest
  )
  begin {
    Write-Verbose "begin - Get-InstalledApplication"
    $arrayList = [ArrayList]::new()
  }
  process {
    Write-Verbose "process - Get-InstalledApplication"

    # [Environment]::Is64BitOperatingSystem - https://docs.microsoft.com/en-us/dotnet/api/system.environment.is64bitoperatingsystem?view=netcore-3.1
    if ([Environment]::Is64BitOperatingSystem) {
      Write-Verbose "Is64BitOperatingSystem: $([Environment]::Is64BitOperatingSystem)"
      Write-Verbose "Retrieving 32-bit application installs"
      Get-ChildItem -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
        Where-Object { $_.GetValue("DisplayName") -like "$Name*" } |
        ConvertFrom-ApplicationRegistryKey -ArrayList ([ref]$arrayList)
    }

    Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" |
      Where-Object { $_.GetValue("DisplayName") -like "$Name*" } |
      ConvertFrom-ApplicationRegistryKey -ArrayList ([ref]$arrayList)

    if ($Latest) {
      $arrayList = $arrayList |
        Sort-Object -Property "DisplayVersion" -Descending |
        Select-Object -First 1
    }

    return $arrayList
  }
  end {
    Write-Verbose "end - Get-InstalledApplication"
  }
}

Get-ApplicationInstall -Name "Microsoft 365"