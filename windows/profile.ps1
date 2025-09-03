# Import-Module posh-git
# Import-Module Terminal-Icons

## Environment
# TODO normalizew path and save in registry
$Env:Path = @(
    'C:\Windows\system32',
    'C:\Windows',
    'C:\Windows\System32\Wbem',
    'C:\Windows\System32\WindowsPowerShell\v1.0\',
    'C:\Program Files\Neovim\bin',
    'C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common',
    'C:\Windows\System32\OpenSSH\',
    'C:\Program Files\Git',
    'C:\Program Files\Git\cmd',
    'C:\Program Files\Git\bin',
    'C:\java\jdk-21.0.2\bin\',
    'C:\Program Files\Notepad++',
    'C:\Program Files\Tailscale\',
    'C:\Program Files\Oracle\VirtualBox',
    'C:\Program Files\Graphviz\bin',
    "${Env:USERPROFILE}\.local\bin",
    'C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\',
    'C:\Users\doomc\AppData\Local\Microsoft\WindowsApps',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\Scripts\',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\',
    'C:\Users\doomc\AppData\Local\Programs\Python\Launcher\',
    'C:\Users\doomc\AppData\Local\Programs\Microsoft VS Code\bin',
    (gci 'C:\Program Files\Git\' -Filter grep.exe -File -Recurse).DirectoryName
) -join ';'

# $Env:STARSHIP_CONFIG = "${Env:USERPROFILE}\.starship\starship.toml"

## Aliases
if (Test-Path Alias:\ls)   { rm Alias:\ls }
if (Test-Path Alias:\curl) { rm Alias:\curl }
if (Test-Path Alias:\kill) { rm Alias:\kill }

${function:grep}  = { & grep.exe --color @args }
${function:curl}  = { & curl.exe --ssl-no-revoke @args }
${function:which} = {$result = (Get-Command @args -ErrorAction SilentlyContinue); if ($result.Source -eq "") {$result.ResolvedCommandName} else {$result.Path}}
# ${function:ls}  = { & ls.exe --color @args }
# ${function:ll}  = { & ls.exe --color -la @args }
${function:ls}    = { & eza.exe -lA --icons=always @args }
${function:ll}    = { & eza.exe -lAT --icons=always @args }
${function:ll3}   = { & eza.exe -lAT --icons=always --group-directories-last -L 3 @args }
${function:l}     = { gci @args }
${function:unzip} = { Expand-Archive @args }
${function:\~}    = { cd $HOME }
${function:\..}   = { cd .. }
${function:...}   = { cd ../.. }
${function:....}  = { cd ../../.. }
${function:.....} = { cd ../../../.. }

function vim {
    if (which nvim.exe) {
        & nvim.exe @args
    } else {
        & vim.exe @args
    }
}

function kill ([string]$proc) {
    Get-Process $proc | Stop-Process -Force -ErrorAction SilentlyContinue
}

## Add functions
function Reset-NetworkSettings {
    $ipconfigPath=(Get-Command -Name ipconfig.exe).Path
    Start-Process -FilePath $ipconfigPath -ArgumentList '/renew' -NoNewWindow -Wait
    Start-Sleep -Millisecond 100
    Start-Process -FilePath $ipconfigPath -ArgumentList '/flushdns' -NoNewWindow -Wait
}

function Reload-Wsl {
    Stop-Process -Name pritunl -Force -ErrorAction SilentlyContinue
    Stop-Process -Name tailscale-ipn -Force -ErrorAction SilentlyContinue
    Stop-Service -Name pritunl -Force
    Stop-Service -Name tailscale -Force
    Start-Sleep -Millisecond 100
    & wsl --shutdown
    Stop-Service -Name WSLService -Force
    Start-Sleep -Millisecond 100
    Reset-NetworkSettings
    Start-Sleep -Millisecond 100
    Start-Service -Name WSLService
    Start-Sleep -Millisecond 100
    Start-Service -Name pritunl
}

function Test-PortConnection {
    param (
        [string]$HostName,
        [int]$Port,
        [int]$Timeout
    )
    $callback = $state = $null
    $TcpClient = New-Object System.Net.Sockets.TcpClient
    $TcpClient.BeginConnect($HostName,$Port,$callback,$state) | Out-Null
    Start-Sleep -Seconds $Timeout
    $result = $TcpClient.Connected
    $TcpClient.Close()
    $result
}

function Start-SSHTunnels {
    if (!(Test-PortConnection -HostName 127.0.0.1 -Port 1443 -Timeout 1) -and !(Test-PortConnection -HostName 127.0.0.1 -Port 2443 -Timeout 1)) {
        if ((Test-PortConnection -HostName vzaytsev-test.ascalon.ae -Port 22 -Timeout 1)) {
            $null = Start-Process -FilePath ssh.exe -ArgumentList '-o StrictHostKeyChecking=no -o ControlMaster=no -p 22 -N -C -L 127.0.0.1:1443:10.18.42.43:443 ubuntu@vzaytsev-test.ascalon.ae' -WindowStyle Hidden;
            Start-Sleep -Seconds 5;
    		$null = Start-Process -FilePath ssh.exe -ArgumentList '-o StrictHostKeyChecking=no -o ControlMaster=no -p 22 -N -C -L 127.0.0.1:2443:10.18.42.44:443 ubuntu@vzaytsev-test.ascalon.ae' -WindowStyle Hidden;
        } else {
            Write-Host 'Can''t start tunneling vzaytsev-test.ascalon.ae not available.'
        }	
    } else {
        Write-Host 'Tunnels already exists.'
    }
    Get-Process -Name ssh -ErrorAction SilentlyContinue
}

function Set-AWSEnvironment {
    $Env:AWS_DEFAULT_REGION="me-south-1"
    $Env:AWS_REGION="me-south-1"
    $Env:AWS_ACCESS_KEY_ID=(Read-Host -Prompt 'AWS_ACCESS_KEY_ID')
    $Env:AWS_SECRET_ACCESS_KEY=(Read-Host -Prompt 'AWS_SECRET_ACCESS_KEY')
}

## Map PSDrives to other registry hives
if (!(Test-Path HKCR:)) {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
}

## Customize the prompt
# function prompt {
#     $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
#     $principal = [Security.Principal.WindowsPrincipal] $identity
#     $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
# 
#     $prefix = $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
#                 elseif ($principal.IsInRole($adminRole)) { "[ADMIN]: " }
#                 else { '' })
#     $body = 'PS ' + $(Get-Location)
#     $suffix = $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
#     $prefix + $body + $suffix
# }

## Create $PSStyle if running on a version older than 7.2
## - Add other ANSI color definitions as needed

# if ($PSVersionTable.PSVersion.ToString() -lt '7.2.0') {
#     # define escape char since "`e" may not be supported
#     $esc = [char]0x1b
#     $PSStyle = [PSCustomObject]@{
#         Foreground = @{
#             Red = "${esc}[31m"
#             Green = "${esc}[32m"
#             Yellow = "${esc}[33m"
#             Blue = "${esc}[34m"
#             Magenta = "${esc}[35m"
#             BrightRed = "${esc}[91m"
#             BrightGreen = "${esc}[92m"
#             BrightYellow = "${esc}[93m"
#             BrightBlue = "${esc}[94m"
#             BrightMagenta = "${esc}[95m"
#         }
#         Background = @{
#             BrightBlack = "${esc}[100m"
#         }
#     }
# }

## Set PSReadLine options and keybindings
# $PSROptions = @{
#     ContinuationPrompt = '> '
#     Colors             = @{
#         Operator         = $PSStyle.Foreground.BrightBlue
#         Parameter        = $PSStyle.Foreground.BrightGreen
#         Selection        = $PSStyle.Background.BrightBlack
#         # InLinePrediction = $PSStyle.Foreground.BrightYellow + $PSStyle.Background.BrightBlack
#     }
# }
# Set-PSReadLineOption @PSROptions

## Bash-like hotkeys
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+b' -Function BackwardChar
Set-PSReadLineKeyHandler -Chord 'Alt+f' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Alt+b' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+e' -Function EndOfLine
Set-PSReadLineKeyHandler -Chord 'Enter' -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+j' -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+m' -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord 'Alt+Backspace' -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+p' -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord 'Ctrl+n' -Function NextHistory

Invoke-Expression (&C:\Users\doomc\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh init powershell -c ~/.oh-my-posh.json)
# Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
Set-Location D:\git\personal\dotfiles\windows
