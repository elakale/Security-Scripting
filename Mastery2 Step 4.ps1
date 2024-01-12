# Remove temporary files
Write-Host "Removing temporary files..."
Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse

# Update Windows Defender
Write-Host "Updating Windows Defender..."
Update-MpSignature

# Start Windows Defender Scan
Write-Host "Starting Windows Defender Scan..."
Start-MpScan -ScanType QuickScan

# Add AppLocker and block regedit
Write-Host "Adding AppLocker and blocking regedit..."
$RulePath = "C:\Windows\System32\AppLocker\"
$PolicyPath = Join-Path $RulePath -ChildPath "Policy.xml"

Set-AppLockerPolicy -XmlPolicy $PolicyPath
New-AppLockerPolicy -RuleType File -Action Deny -User Everyone -Path "C:\Windows\regedit.exe"

# Disable automatic Windows Updates
Write-Host "Disabling automatic Windows Updates..."
$Service = Get-Service -Name "wuauserv"
Stop-Service $Service
Set-Service $Service -StartupType Disabled

# Enable Windows Defender Firewall
Write-Host "Enabling Windows Defender Firewall..."
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

# Enable Windows Defender Antivirus
Write-Host "Enabling Windows Defender Antivirus..."
Set-MpPreference -DisableRealtimeMonitoring $false

# Output system information
Write-Host "System information:"
Write-Host "-------------------"
systeminfo | Select-String "Host Name", "OS Name", "OS Version", "System Manufacturer", "System Model"

# Deny RDP Connections
Write-Host "Denying RDP Connections..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1

# Output Windows version details
Write-Host "Windows version details:"
Write-Host "------------------------"
(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId

# Check available logs, size, and retention limit
Write-Host "Checking available logs, size, and retention limit..."
Get-WinEvent -ListLog * | Select-Object LogName, LogFilePath, MaximumSizeInBytes, Retention
