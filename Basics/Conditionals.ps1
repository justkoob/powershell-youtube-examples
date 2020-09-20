<#
.SYNOPSIS
  An example of using and creating conditional statements in powershell.
.DESCRIPTION
  Examples of conditional statement and how to use/create them.
.NOTES
  Author: justkoob
  Creation Date: 09/19/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
#>

# if else elseif
$folderPath = "C:\Temp"

if (Test-Path -Path $folderPath) {
	Write-Host "$folderPath exists"
}
else {
	Write-Host "$folderPath does not exist"
}

if (Test-Path -Path $folderPath) {
	Write-Host "$folderPath exists"
}
elseif (Test-Path -Path "$folderPath\NewFolder") {
	Write-Host "$folderPath\NewFolder exists"
}
else {
	Write-Host "$folderPath does not exist"
}

# switch
$letter = "A"
switch ($letter) {
	"A" { Write-Host "The letter is A."; break }
	"B" { Write-Host "The letter is B."; break }
	default { Write-Host "The letter is not A or B."; break }
}