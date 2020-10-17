<#
.Synopsis
Used to place a user specific Z:\ drive mapping batch file on a remote machine.

.Description
Used to place a user specific Z:\ drive mapping batch file on a remote machine.

.Parameter ComputerName
Set a remote machine name to place the software on.

.Notes
Will overwrite existing files of the same name.


#>
function New-ZDriveBat {
[cmdletbinding()]
param(
	[Parameter()]
	[string]$ComputerName=$(read-host -prompt "Enter Remote System Number")
)
Process {
		
		$User = Invoke-Command -ComputerName $ComputerName -ScriptBlock {(Get-WMIObject -class Win32_ComputerSystem | select -expand username).split('\')}
		$User = $User[1]
		$Path = Get-ADUser -Identity $User -Properties HomeDirectory | select -expand HomeDirectory
		Set-Content -Path "\\$ComputerName\c$\Users\$User\Desktop\Map Z Drive.bat" -Value @"
		@echo off
		cls
		title Map Z:\ Drive
		echo Mapping Z:\ Drive
		echo.
		Net Use Z: $Path /Persistent:yes
		title Z:\ Drive Mapped
		echo Z:\ Drive Mapped
		echo.
		Pause
"@		
}}
