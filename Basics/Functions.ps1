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