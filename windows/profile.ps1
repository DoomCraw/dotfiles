# Version: 1.0.0
# ############ ( ----------------     Environment    ----------------) ############
# TODO sync all dotfiles
# TODO double chekc and move to refreshenv
# TODO winact
# TODO refreshenv (Refresh-Environment from win2025 profile) add Install-Module posh-git
# TODO merge with win2025 profile
# TODO fzf/fd integration
# TODO: add scripts dir create wsl
# TODO: add scripts dir create vbox vm


# WSL2 TODO
# TODO Ansible:
#   - Dockerfile
#   - WorkSpace for VSCode
#   - PwSh autocompletion for ansible(wsl/venv)
#       https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7.6
# TODO ZSH:
#   - Dockerfile
#   - Personal WorkSpace

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
    'C:\Program Files\PowerShell\7',
    'C:\java\jdk-21.0.2\bin\',
    'C:\Program Files\Notepad++',
    'C:\Program Files\Tailscale\',
    'C:\Program Files\Oracle\VirtualBox',
    'C:\Program Files\WezTerm',
    "${Env:USERPROFILE}\.local\bin",
    'C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\',
    'C:\Users\doomc\AppData\Local\Microsoft\WindowsApps',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\Scripts\',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\',
    'C:\Users\doomc\AppData\Local\Programs\Python\Launcher\',
    'C:\Users\doomc\AppData\Local\Programs\Microsoft VS Code\bin'
) -join ';'

if (Test-Path 'C:\ProgramData\chocolatey\bin') { $Env:PATH = "${Env:PATH};C:\ProgramData\chocolatey\bin" }
if (Test-Path "${Env:USERPROFILE}\scripts") { $Env:PATH = "${Env:PATH};${Env:USERPROFILE}\scripts" }

$Env:HOSTS            = "${Env:WINDIR}\System32\drivers\etc\hosts"
$Env:STARSHIP_CONFIG  = "${Env:USERPROFILE}\.starship.toml"
$Env:DOTFILES         = "D:\git\personal\dotfiles"
$Env:SOFT             = "D:\soft" # ${HOME}\.local\bin
$Env:SOFT_PORTABLE    = "${Env:SOFT}\portable"
$Env:YANDEX_DISK      = 'D:\yandex_disk'
$Env:DEFAULT_WSL      = 'workspace'
$Env:SSH_PROXY        = 'valeriy.z@100.64.0.18' # 100.64.0.12
$Env:EDITOR           = foreach ($cmd in @('code.cmd', 'nvim.exe', 'vim.exe', 'pvim.exe', 'gvim.exe', 'helix.exe', 'notepad++.exe', 'notepad.exe')) {
  if (Get-Command $cmd -CommandType Application -ErrorAction SilentlyContinue) {
    $cmd
    break
  }
}
$Env:ANSIBLE_WSL      = ${Env:ANSIBLE_WSL} ?? ${Env:DEFAULT_WSL}
$Env:ANSIBLE_WSL_USER = 'valeriy.z' # "$(${Env:USERNAME}.ToLower())"
$Env:ANSIBLE_WSL_VENV = '~/.ansible-venv/bin/activate'
$Env:ANSIBLE_WSL_ROOT = '/mnt/d/git/job/admin-infrastructure/ansible'
# TODO: $Env:SSH_TUNS


# ############ ( ----------------     Aliases        ----------------) ############


if (Test-Path Alias:\ls)    { Remove-Item -Force -Path Alias:\ls    }
if (Test-Path Alias:\curl)  { Remove-Item -Force -Path Alias:\curl  }
if (Test-Path Alias:\kill)  { Remove-Item -Force -Path Alias:\kill  }
if (Test-Path Alias:\which) { Remove-Item -Force -Path Alias:\which }
if (Test-Path Alias:\diff)  { Remove-Item -Force -Path Alias:\diff  }
if (Test-Path Alias:\grep)  { Remove-Item -Force -Path Alias:\grep  }
if (Test-Path Alias:\vim)   { Remove-Item -Force -Path Alias:\vim   }

Set-Alias vim $Env:EDITOR
Set-Alias diff diff.exe

${function:halt}              = { Stop-Computer }
${function:reboot}            = { Restart-Computer }
${function:vpnzstop}          = { Get-Service Tailscale,pritunl,zapret | Stop-Service }
${function:vpnzstart}         = { Get-Service Tailscale,pritunl,zapret | Start-Service }
${function:zrestart}          = { Get-Service zapret | Restart-Service }
${function:grep}              = { & grep.exe --color -Ei @args }
${function:curl}              = { & curl.exe --ssl-no-revoke @args }
${function:which}             = { $result = (Get-Command @args -ErrorAction SilentlyContinue); if ($result.Source -eq "") {$result.ResolvedCommandName} else {$result.Path} }
${function:ls}                = { & eza.exe --group-directories-first --icons=always @args }
${function:ll}                = { & eza.exe -la --group-directories-first --icons=always @args }
${function:llr}               = { & eza.exe -lAT --group-directories-first --icons=always @args }
${function:ll2}               = { & eza.exe -lAT --group-directories-first --icons=always -L 2 @args }
${function:ll3}               = { & eza.exe -lAT --group-directories-first --icons=always -L 3 @args }
${function:l}                 = { Get-ChildItem @args -Force }
${function:cll}               = { cls; ll }
${function:cllr}              = { cls; llr }
${function:cll2}              = { cls; ll2 }
${function:cll3}              = { cls; ll3 }
${function:df}                = { Get-Volume | Where-Object {$_.DriveLetter -ne $null -and $_.FileSystemType -eq 'NTFS'} }
${function:unzip}             = { Expand-Archive @args }
${function:tss}               = { tailscale switch ((tailscale switch --list | Select-String -NotMatch '(Account|\*)$' | Out-String) -replace '\r\n','').Split(' ')[0] }
${function:rnt}               = { Get-Process pritunl,tailscale-ipn -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue; Get-Service Tailscale,pritunl | Stop-Service; ipconfig.exe /renew; ipconfig.exe /flushdns; }
${function:dof}               = { Set-Location ${Env:DOTFILES} }
${function:psd}               = { Get-PSDrive | Where-Object {$_.Provider.ToString() -eq 'Microsoft.PowerShell.Core\FileSystem'} | select Name, Root }
${function:gkill}             = { Get-Process Gothic2 | Stop-Process -Force -ErrorAction SilentlyContinue }
${function:gstart}            = { & C:\Users\doomc\Desktop\d\gm\Gothic2.lnk }
${function:Edit-Profile}      = { vim $PROFILE }
${function:Edit-Hosts}        = { sudo vim $Env:HOSTS }
${function:Reload-Profile}    = { & $PROFILE }
${function:docs}              = { pushd ${HOME}\Documents }
${function:dows}              = { pushd ${HOME}\Downloads }
${function:dotfiles}          = { pushd ${Env:DOTFILES} }
${function:zapret}            = { pushd "${Env:SOFT_PORTABLE}\zapret-discord-youtube-1.9.8b" }
${function:dotfiles-update}   = { & ${Env:DOTFILES}\windows\setup.ps1 -Dotfiles }
${function:start-wsl}         = { & wsl -d ${Env:DEFAULT_WSL} }
${function:stop-wsl}          = { & wsl -t ${Env:DEFAULT_WSL} }
${function:sudome}            = { sudo (Get-Process -Id $PID).ProcessName }
${function:ansible}           = { & wsl -d ${Env:ANSIBLE_WSL} -u "${Env:ANSIBLE_WSL_USER}" --shell-type standard /bin/bash -c "source ${Env:ANSIBLE_WSL_VENV}; cd ${Env:ANSIBLE_WSL_ROOT}; ansible ${args}; deactivate" }
${function:ansible-playbook}  = { & wsl -d ${Env:ANSIBLE_WSL} -u "${Env:ANSIBLE_WSL_USER}" --shell-type standard /bin/bash -c "source ${Env:ANSIBLE_WSL_VENV}; cd ${Env:ANSIBLE_WSL_ROOT}; ansible-playbook ${args}; deactivate;" }
${function:ansible-inventory} = { & wsl -d ${Env:ANSIBLE_WSL} -u "${Env:ANSIBLE_WSL_USER}" --shell-type standard /bin/bash -c "source ${Env:ANSIBLE_WSL_VENV}; cd ${Env:ANSIBLE_WSL_ROOT}; ansible-inventory ${args}; deactivate;" }
${function:ansible-docs}      = { & wsl -d ${Env:ANSIBLE_WSL} -u "${Env:ANSIBLE_WSL_USER}" --shell-type standard /bin/bash -c "source ${Env:ANSIBLE_WSL_VENV}; cd ${Env:ANSIBLE_WSL_ROOT}; ansible-docs ${args}; deactivate;" }
${function:home}              = { Set-Location $HOME }
${function:\~}                = { Set-Location $HOME }
${function:\..}               = { Set-Location .. }
${function:...}               = { Set-Location ../.. }
${function:....}              = { Set-Location ../../.. }
${function:.....}             = { Set-Location ../../../.. }

function touch ($file) {"" | Out-File $file -NoNewLine -Encoding ASCII}

function term_set_title ($title) { if ((which wezterm.exe) -and ($Env:WEZTERM_PANE)) {& wezterm.exe cli set-tab-title "$title"} }

function kill ([string]$proc) {
    Get-Process $proc | Stop-Process -Force -ErrorAction SilentlyContinue
}

function ff ([string]$name) {
    Get-ChildItem .\ -Filter "*${name}*" -Recurse -Force -ErrorAction SilentlyContinue | select -ExpandProperty FullName
}

function llf ([string]$name = '') {
    if ($name -eq '') {$name = '*'}
    $res = Get-ChildItem .\ -Filter "*${name}*" -Recurse -Force -File -ErrorAction SilentlyContinue | select -ExpandProperty FullName
    if ($res.length -eq 0) {
        $res = ff $name
    }
    $res
}

# TODO: finding files in preordered dirs
# function lle ([string]$ext) {
#     gci $Env:SEARCH_EXTS -Recurse --Force -File- Filter "$filter" -ErrorAction SilentlyContinue | select FullName
# }

function sudo {
    if ($args.length -gt 1) {
        Start-Process $args[0] -ArgumentList $args[1..($args.length - 1)] -Verb RunAs -WindowStyle Maximized
    } else { 
        Start-Process $args[0] -Verb RunAs -WindowStyle Maximized
    }
}


# ############ ( ----------------     Functions      ----------------) ############


function syncfiles { # TODO: add megasync support
    param (
        [string]$subcommand = ''
    )

    switch ($subcommand) {
        'pull' { Copy-Item -Path ${Env:YANDEX_DISK}\*.kdbx -Destination $HOME\Documents }
        'push' { Copy-Item -Path $HOME\Documents\*.kdbx -Destination ${Env:YANDEX_DISK} }
        Default { Write-Host -Object 'No files to sync.' }
    }
}

Set-Alias msync syncfiles


function Update-Profile {
  # TODO: Update-Profile should update profile file from inet
  # TODO: Update-Profile should update env vars and Refresh-Environment
  $dotfiles_profile = "${Env:DOTFILES}\windows\profile.ps1"
  if (diff -q $PROFILE $dotfiles_profile) {
      cp $PROFILE $dotfiles_profile
      Write-Host 'Profile updated.'
  } else {
      Write-Host 'Nothing to update.'
  }
}


function Clear-SavedGames {
  Get-ChildItem -Path .\ `
    -File `
    -Exclude 'steam_autocloud.vdf' `
      | Sort-Object -Descending -Property LastWriteTime `
      | Select-Object -Skip 10 `
      | Remove-Item -Force
}


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
        [string]$ProxyUser                                  = "$($Env:SSH_PROXY.Split('@')[0])",
        [string]$ProxyHost                                  = "$($Env:SSH_PROXY.Split('@')[1])",
        [string]$ProxyPort                                  = 22
    )
    # TODO - $Env:SSH_TUNELS_PIDS
    $sshTunnel = @{
        FilePath          = (which cmd.exe)
        WindowStyle       = 'Hidden'
        PassThru          = $true
        UseNewEnvironment = $true
        ArgumentList      = @(
            "/c"
            "$(which ssh.exe)"
            "-o ConnectionAttempts=2"
            "-o ConnectTimeout=5"
            "-o StrictHostKeyChecking=no"
            "-o ControlMaster=no"
            "-o ServerAliveCountMax=3"
            "-o ServerAliveInterval=15"
            "-o ExitOnForwardFailure=yes"
            "-p ${ProxyPort}"
            "-nCNTL ${LocalHost}:${LocalPort}:${RemoteHost}:${RemotePort}" 
            "${ProxyUser}@${ProxyHost}"
        ) -join ' '
    }

    if (!(Test-PortConnection -HostName $LocalHost -Port $LocalPort -Timeout 1)) {
        $parent_pid = (Start-Process @sshTunnel | Get-Process).Id
    }
}

Set-Alias -Name sshtun -Value Add-SSHTunnel
# TODO: tunup
# TODO: tundown
# TODO: tun
# TODO: tunsel/tunselect


function Set-AWSEnvironment {
    $Env:AWS_REGION             = 'ap-southeast-1'
    $Env:AWS_DEFAULT_REGION     = 'ap-southeast-1'
    $Env:AWS_ACCESS_KEY_ID      = (Read-Host -Prompt 'AWS_ACCESS_KEY_ID' -MaskInput)
    $Env:AWS_SECRET_ACCESS_KEY  = (Read-Host -Prompt 'AWS_SECRET_ACCESS_KEY' -MaskInput)
}

function Set-NexusEnvironment {
    $Env:NEXUS_USER = (Read-Host -Prompt 'NEXUS_USER' -MaskInput)
    $Env:NEXUS_PASS = (Read-Host -Prompt 'NEXUS_PASS' -MaskInput)
}

function curl_nexus {
    curl -k -u "${NEXUS_USER}:${NEXUS_PASS}" @args
}

function ConvertTo-WSLPath {
    Param(
        [Parameter(Mandatory=$true)][string]$Path
    )
    return "/mnt/$(((Get-Item $Path).FullName.Split('\') -join '/').ToLower().Replace(':',''))"
}


# Ansible make role
function mkrole ($rolename) {
    if ((Split-Path $(pwd) -Leaf) -eq 'roles') {
        $fullpath = ".\$rolename"
    } else {
        $fullpath = ".\roles\$rolename"
    }
    if (!(Test-Path $fullpath)) { $null = mkdir $fullpath }
    pushd $fullpath
    'defaults','files','handlers','tasks','templates' | ForEach-Object {
        if (!(Test-Path $_)) {
            $null = mkdir $_
        }
    }
    'defaults\main.yml','handlers\main.yml','tasks\main.yml' | ForEach-Object {
        if (!(Test-Path $_)) {
            New-Item $_ -ItemType File
        }
    }
    popd
}


# ############ ( ----------------        RDP         ----------------) ############


# function rdp ([string] $server, [string] $port='3389') {
#     if (!(& cmdkey.exe /list | Where-Object {$PSItem -match $server})) {
#         $username = Read-Host -Prompt 'Username'
#         $password = Read-Host -Prompt 'Password' -MaskInput
#         & cmdkey.exe /generic:TERMSRV/$server /user:$username /pass:$password
#         $username = $password = $null
#     }
#     & mstsc.exe /v:$server:$port /f
# }


# function rdp_autocomplete {
#     & cmdkey.exe /list | `
#         ForEach-Object {
#             if ($PSItem -match 'target=TERMSRV') {
#                 $RDPServer = $PSItem.Split('=')[1].Replace('TERMSRV/','')
#                 Write-Host $RDPServer
#             }
#         }
# }


# ############ ( ----------------        SSH         ----------------) ############


# $gist_profile_url='https://gist.githubusercontent.com/backerman/2c91d31d7a805460f93fe10bdfa0ffb0/raw/cc3a4ce6fd6466ccfa86382a8b9584f608504c07/profile-snippet-sshargcomplete.ps1'
# if (Test-Connection 'gist.githubusercontent.com' -TimeoutSeconds 2 -Count 1 -Delay 5) {
#     Update-Profile $gist_profile_url
# }


# ############ ( ----------------     PSDrives       ----------------) ############


if (!(Test-Path HKCR:)) {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
}

$map_disks = @{
    'R' = 'D:\git';
    'W' = 'D:\Downloads';
    'I' = 'D:\iso';
    'O' = "${HOME}\Documents";
    'Y' = "${Env:YANDEX_DISK}"
}

$map_disks.Keys | ForEach-Object -Process {
    $letter    = $PSItem
    $directory = $map_disks[$PSItem]
    if ((Test-Path $directory) -and !(Test-Path "${letter}:")) {
        $null = New-PSDrive -Name $letter -Root $directory -PSProvider FileSystem
    }
} -End {
    $map_disks = $letter = $directory = $null
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


# ############ ( ----------------     Modules        ----------------) ############


# Import-Module posh-git
# Import-Module Terminal-Icons

# # choco.exe autocompletion
# $ChocolateyProfile = "${Env:ChocolateyInstall}\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#     Import-Module "$ChocolateyProfile"
# }


# ############ ( ----------------     Prompt         ----------------) ############


Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
term_set_title "pwsh"