# ############ ( ----------------     Environment    ----------------) ############
# TODO double chekc and move to bootstrap.ps1


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
    'C:\Program Files\Git\usr\bin',
    'C:\Program Files\Git\mingw64\bin',
    'C:\java\jdk-21.0.2\bin\',
    'C:\Program Files\Notepad++',
    'C:\Program Files\Tailscale\',
    'C:\Program Files\Oracle\VirtualBox',
    "${Env:USERPROFILE}\.local\bin",
    'C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\',
    'C:\Users\doomc\AppData\Local\Microsoft\WindowsApps',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\Scripts\',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\',
    'C:\Users\doomc\AppData\Local\Programs\Python\Launcher\',
    'C:\Users\doomc\AppData\Local\Programs\Microsoft VS Code\bin'
) -join ';'

$Env:EDITOR          = 'nvim.exe'
$Env:HOSTS           = "${Env:WINDIR}\System32\drivers\etc\hosts"
$Env:STARSHIP_CONFIG = "${Env:USERPROFILE}\.starship.toml"


# ############ ( ----------------     Aliases        ----------------) ############


if (Test-Path Alias:\ls)    { Remove-Item Alias:\ls }
if (Test-Path Alias:\curl)  { Remove-Item Alias:\curl }
if (Test-Path Alias:\kill)  { Remove-Item Alias:\kill }
if (Test-Path Alias:\which) { Remove-Item Alias:\which }
if (Test-Path Alias:\grep)  { Remove-Item Alias:\grep }

${function:grep}  = { & grep.exe --color -Ei @args }
${function:curl}  = { & curl.exe --ssl-no-revoke @args }
${function:which} = {$result = (Get-Command @args -ErrorAction SilentlyContinue); if ($result.Source -eq "") {$result.ResolvedCommandName} else {$result.Path}}
${function:ls}    = { & eza.exe --group-directories-first --icons=always @args }
${function:ll}    = { & eza.exe -la --group-directories-first --icons=always @args }
${function:llr}   = { & eza.exe -lAT --group-directories-first --icons=always @args }
${function:ll3}   = { & eza.exe -lAT --group-directories-first --icons=always -L 3 @args }
${function:l}     = { Get-ChildItem @args -Force }
${function:unzip} = { Expand-Archive @args }
${function:\~}    = { Set-Location $HOME }
${function:\..}   = { Set-Location .. }
${function:...}   = { Set-Location ../.. }
${function:....}  = { Set-Location ../../.. }
${function:.....} = { Set-Location ../../../.. }

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


# ############ ( ----------------     Functions      ----------------) ############


function Reset-NetworkAdapters {
    $ipconfigPath = (which ipconfig.exe)
    Start-Process -FilePath $ipconfigPath -ArgumentList '/renew' -NoNewWindow -Wait
    Start-Sleep -Millisecond 100
    Start-Process -FilePath $ipconfigPath -ArgumentList '/flushdns' -NoNewWindow -Wait
}

function Reset-Wsl {
    Get-Process tailscale-ipn,pritunl -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue | Out-Null
    Get-Service Tailscale,pritunl -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue | Out-Null
    & wsl.exe --shutdown
    Stop-Service WSLService -Force
    Reset-NetworkAdapters
    Start-Service WSLService
    Start-Service pritunl
}

function Test-PortConnection {
    Param (
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

function Add-SSHTunnel {
    Param(
        [string]$LocalHost                                  = '127.0.0.1',
        [Parameter(mandatory=$true)][string]$LocalPort,
        [Parameter(mandatory=$true)][string]$RemoteHost,
        [Parameter(mandatory=$true)][string]$RemotePort,
        [string]$ProxyUser                                  = 'valeriy.z',
        [string]$ProxyHost                                  = '100.64.0.18', # 100.64.0.12
        [string]$ProxyPort                                  = 22
    )
    # TODO - $Env:SSH_TUNELS_PIDS
    $sshTunnel = @{
        FilePath          = (which powershell.exe)
        WindowStyle       = 'Hidden'
        PassThru          = $true
        UseNewEnvironment = $true
        ArgumentList      = @(
            "-NoLogo -NoProfile -NonInteractive"
            "-Command `'& $((Get-Command ssh.exe).Path)"
            "-o StrictHostKeyChecking=no"
            "-o ControlMaster=no"
            "-o ServerAliveInterval=60"
            "-o ExitOnForwardFailure=yes"
            "-p ${ProxyPort}"
            "-nCNTL ${LocalHost}:${LocalPort}:${RemoteHost}:${RemotePort}" 
            "${ProxyUser}@${ProxyHost}`'"
        ) -join ' '
    }

    if (!(Test-PortConnection -HostName $LocalHost -Port $LocalPort -Timeout 1)) {
        Start-Process @sshTunnel
    }
}

function Set-AWSEnvironment {
    $Env:AWS_REGION             = 'me-south-1'
    $Env:AWS_DEFAULT_REGION     = 'me-south-1'
    $Env:AWS_ACCESS_KEY_ID      = (Read-Host -Prompt 'AWS_ACCESS_KEY_ID')
    $Env:AWS_SECRET_ACCESS_KEY  = (Read-Host -Prompt 'AWS_SECRET_ACCESS_KEY')
}

function ConvertTo-WSLPath {
    Param(
        [Parameter(Mandatory=$true)][string]$Path
    )
    return "/mnt/$(((Get-Item $Path).FullName.Split('\') -join '/').ToLower().Replace(':',''))"
}


# ############ ( ----------------     PSDrives       ----------------) ############


if (!(Test-Path HKCR:)) {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
}

# ############ ( ----------------     KeyMapping     ----------------) ############
## Bash-style keymapping


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


# ############ ( ----------------     Prompt         ----------------) ############


Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
