<#
.SYNOPSIS
  An example of using and creating objects in powershell.
.DESCRIPTION
  Examples of objects, types, and how to use/create them.
.NOTES
  Author: justkoob
  Creation Date: 09/18/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
#>

# Strings
[string]$string = "Hello World!"
"$string My name is justkoob!"
Write-Host "$string My name is justkoob!"
$string = $string + "My name is justkoob!"
$string

# Integers
[int]$int = 0
$int + 1

# Using objects that are returned
$folder = Get-Item -Path "C:\Temp"
$folder.FullName

# Custom objects
$pencil = [PSCustomObject]@{
  TypeName = "Pencil"
  EraserMaterial = "Rubber"
  EraserColor = "White"
  LeadColor = "Red"
  Color = "Yellow"
}

$pencil.TypeName
$pencil.EraserMaterial
$pencil.EraserColor
$pencil.LeadColor
$pencil.Color

$pencil