<#
.SYNOPSIS
  An example of iterating through objects in powershell.
.DESCRIPTION
  Examples of different iteration statements and how to use them.
.NOTES
  Author: justkoob
  Creation Date: 09/20/2020
  Find me on YouTube: https://www.youtube.com/channel/UCJoqffHqDCoSp-hxGdp1K9A
#>

# foreach
$folderPath = "C:\Temp1"

$items = Get-ChildItem -Path $folderPath -Recurse

foreach ($item in $items) {
  if ($item.PSIsContainer) {
    Write-Host "$($item.FullName) is a directory."
  }
  else {
    Write-Host "$($item.FullName) is a file."
  }
}

# for
for ($i = 0; $i -lt 5; $i++) {
  Write-Host $i
}

$items.Count

for ($i = 0; $i -lt $items.Count; $i++) {
  Write-Host ($items[$i]).FullName
}

# while
$i = 0

while ($i -lt 5) {
  Write-Host $i
  $i++
}