## Variables
$disabledServices = @(
    'RasMan',
    'RasAuto',
    'LanmanServer',
    'LanmanWorkstation',
    'spooler'
)

$enabledServices = @(
    'ssh-agent'
)


# ############ ( ----------------     System      ----------------) ############
Disable-MMAgent -MemoryCompression


# ############ ( ----------------     Registry    ----------------) ############

# Yandex Disk config
Set-ItemProperty 'HKCU:\Software\Yandex\Yandex.Disk.2' -Force -Name RootFolder -Value 'D:\yandex_disk'

# AutoLogon disable
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Force -Name AutoAdminLogon -Value 0
Remove-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Force -Name DefaultUserName
Remove-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Force -Name DefaultPassword

# Enable dark mode (theme)
Set-ItemProperty 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Force -Name AppsUseLightTheme -Value 0
Set-ItemProperty 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Force -Name SystemUsesLightTheme -Value 0

# Screen
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Force -Name NoLockScreen -Value 1

# Disable Windows AutoUpdates
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Force -Name DoNotConnectToWindowsUpdateInternetLocations -Value 1
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Force -Name UpdateServiceUrl -Value ''
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Force -Name UpdateServiceUrlAlternate -Value ''
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Force -Name WUServer -Value 'http://192.168.200.201'
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Force -Name WUStatusServer -Value 'http://192.168.200.201'

Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force -Name NoAutoUpdate -Value 1
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force -Name AUOptions -Value 3
Set-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force -Name UseWUServer -Value 1

# Enable TLS 1.2 for DotNet
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Force -Name SchUseStrongCrypto -Value 1
Set-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Force -Name SchUseStrongCrypto -Value 1

# Disable RMB popup menu "Show more options"
Set-ItemProperty 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Force -Name '(Default)' -Value ''

# Restart explorer.exe to apply registry tweaks
Stop-Process explorer -Force


# ############ ( ----------------     Services    ----------------) ############

Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\OneSyncSvc -Force -Name Start -Value 4
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\PhoneSvc -Force -Name Start -Value 4

$disabledServices | ForEach-Object {
    Get-Service $PSItem | Set-Service -StartupType Disabled
    Get-Service $PSItem | Stop-Service -Force -ErrorAction SilentlyContinue
}

$enabledServices | ForEach-Object {
    Get-Service $PSItem | Set-Service -StartupType Automatic
    Get-Service $PSItem | Start-Service -ErrorAction SilentlyContinue
}


# ############ ( ---------------- Scheduled Tasks ----------------) ############
