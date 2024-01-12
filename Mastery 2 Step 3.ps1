# Remove temporary files
Write-Host "Removing temporary files..."
Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse

# Update Windows Defender
Write-Host "Updating Windows Defender..."
Update-MpSignature

# Block embedded files in Adobe Reader
Write-Host "Blocking embedded files in Adobe Reader..."
$ConfigFile = "C:\Program Files (x86)\Adobe\Reader DC\Reader\ProtectedModeWhitelistConfig.txt"
Set-Content -Path $ConfigFile -Value "EmbeddedFiles disabled"

# Enforce NTLMv2 and refuse NTLM and LM authentication
Write-Host "Enforcing NTLMv2 and refusing NTLM and LM authentication..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "NTLMv2AuthLevel" -Value 5
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNTLM" -Value 2

# Set screensaver inactivity timeout to 10 minutes
Write-Host "Setting screensaver inactivity timeout to 10 minutes..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value 600

# Disable advertising ID
Write-Host "Disabling advertising ID..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

# Output system information
Write-Host "System information:"
Write-Host "-------------------"
systeminfo | Select-String "Host Name", "OS Name", "OS Version", "System Manufacturer", "System Model"

# Output Windows version details
Write-Host "Windows version details:"
Write-Host "------------------------"
(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId

# Check available logs, size, and retention limit
Write-Host "Checking available logs, size, and retention limit..."
Get-WinEvent -ListLog * | Select-Object LogName, LogFilePath, MaximumSizeInBytes, Retention
