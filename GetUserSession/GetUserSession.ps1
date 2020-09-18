function Get-UserSession {
	[CmdLetBinding(DefaultParameterSetName = "Default")]
	param (
		[string]$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = "Active")]
		[switch]$Active,
		[switch]$Console,
		[Parameter(ParameterSetName = "Disconnected")]
		[switch]$Disconnected
	)

	$sessions = (&"query" user /SERVER:$ComputerName) -replace "^[\s]USERNAME[\s]+SESSIONNAME.*$", "" -replace "[\s]{2,}", "," -replace ">", "" |
		ConvertFrom-Csv -Delimiter "," -Header "Username", "SessionName", "Id", "State", "IdleTime", "LogonTime"

	foreach ($session in $sessions) {
		Add-Member -InputObject $session -MemberType NoteProperty -Name "ComputerName" -Value $ComputerName
	}

	if ($Active) {
		$sessions = $sessions | Where-Object { $_.State -eq "Active" }
	}
	elseif ($Disconnected) {
		$sessions = $sessions | Where-Object { $_.State -eq "Disc" }
	}

	if ($Console) {
		$sessions = $sessions | Where-Object { $_.SessionName -eq "console" }
	}
	
	return $sessions
}

Get-UserSession