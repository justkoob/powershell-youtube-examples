#requires -Version 5.1
#requires -RunAsAdministrator

<#
.SYNOPSIS
  An example of how to use an external data source (csv) for pester test cases.
.DESCRIPTION
  Using a csv file for input for pester test cases to check acl access
  and audit permissions assigned to a directory.
.NOTES
  Author: justkoob
  Creation Date: 09/16/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
#>

using namespace System.Collections

$config = Import-Csv -Path "$PSScriptRoot\Acl.csv"

$arrayList = [ArrayList]::new()

foreach ($row in $config) {
	$hashset = @{}

	foreach ($property in $row.PSObject.Properties) {
		$hashset.Add($property.Name, $property.Value)
	}

	$arrayList.Add($hashset) | Out-Null
}

Describe "Acl" {
	It "'<RuleType>' for '<Path>' should be '<IdentityReference>' - '<AccessControlType><AuditFlags>' - '<FileSystemRights>'" -TestCases $arrayList {
		param (
			[string]$RuleType,
			[string]$Path,
			[string]$Owner,
			[string]$FileSystemRights,
			[string]$AccessControlType,
			[string]$AuditFlags,
			[string]$IdentityReference,
			[string]$IsInherited,
			[string]$InheritanceFlags,
			[string]$PropagationFlags
		)

		$acl = Get-Acl -Path $Path -Audit -ErrorAction SilentlyContinue

		$acl | Should Not Be $null

		if ($RuleType -eq "FileSystemAccessRule") {
			$rule = $acl.Access | Where-Object {
				$_.FileSystemRights -eq $FileSystemRights -and
				$_.AccessControlType -eq $AccessControlType -and
				$_.IdentityReference -eq $IdentityReference
			}

			$acl.Owner | Should Be $Owner
			$rule.AccessControlType | Should Be $AccessControlType
		}
		else {
			$rule = $acl.Audit | Where-Object {
				$_.FileSystemRights -eq $FileSystemRights -and
				$_.AuditFlags -eq $AuditFlags -and
				$_.IdentityReference -eq $IdentityReference
			}

			$rule.AuditFlags | Should Be $AuditFlags
		}

		$rule.IdentityReference | Should Be $IdentityReference
		$rule.IsInherited | Should Be $IsInherited
		$rule.InheritanceFlags | Should Be $InheritanceFlags
		$rule.PropagationFlags | Should Be $PropagationFlags
	}
}