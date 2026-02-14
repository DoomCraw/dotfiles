Param (
    [switch]$All            = $false,
    [switch]$Dependencies   = $false,
    [switch]$Dotfiles       = $false,
    [switch]$VSCode         = $false,
    [switch]$WSL            = $false
)

$Global:dotfilesDir = "${HOME}\.dotfiles"

$wingetPackages = @(
        '7zip.7zip',
        'Alacritty.Alacritty',
        'Amazon.AWSCLI',
        'DEVCOM.JetBrainsMonoNerdFont',
        'Discord.Discord',
        'eza-community.eza',
        'Git.Git',
        'Google.Chrome',
        'Hashicorp.Terraform',
        'jqlang.jq',
        'junegunn.fzf',
        'Logseq.Logseq',
        'Microsoft.PowerShell',
        'Neovim.Neovim',
        'Notepad++.Notepad++',
        'Obsidian.Obsidian',
        'OpenJS.NodeJS.LTS',
        'Pritunl.PritunlClient',
        'qBittorrent.qBittorrent',
        'SlackTechnologies.Slack',
        'Starship.Starship',
        'sxyazi.yazi',
        'Tailscale.Tailscale',
        'Telegram.TelegramDesktop',
        'wez.wezterm',
        'Zig.Zig'
)

$vscodeExtensions = @(
    'bubbla.tortoise-theme',
    'codefaster.auto-code-formatter-for-react-v0-1',
    'eamodio.gitlens',
    'frhtylcn.pythonsnippets',
    'grafana.vscode-jsonnet',
    'hashicorp.terraform',
    'httpsterio.henna',
    'jdinhlife.gruvbox',
    'lelinpadhan.retro-green-theme-vscode',
    'mads-hartmann.bash-ide-vscode',
    'metaphore.kanagawa-vscode-color-theme',
    'ms-python.debugpy',
    'ms-python.python',
    'ms-python.vscode-pylance',
    'ms-python.vscode-python-envs',
    'ms-vscode-remote.remote-containers',
    'ms-vscode-remote.remote-ssh',
    'ms-vscode-remote.remote-ssh-edit',
    'ms-vscode-remote.remote-wsl',
    'ms-vscode-remote.vscode-remote-extensionpack',
    'ms-vscode.makefile-tools',
    'ms-vscode.powershell',
    'ms-vscode.remote-explorer',
    'ms-vscode.remote-server',
    'napmz.purple-green-theme',
    'redhat.ansible',
    'redhat.vscode-yaml',
    'sebbia.jsonnetng'
)


function Get-BinPath {
    param (
        [string]$Name
    )

    return (Get-ChildItem C:\ -Force -Filter $Name -File -ErrorAction SilentlyContinue -Recurse).DirectoryName -join ';'
}


function Update-Path ($path) {
    $Env:Path = $Env:Path + ";${path}"
}


function Get-Dotfiles {
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        Update-Path (Get-BinPath git.exe)
    }

    if (!(Test-Path $Global:dotfilesDir)) {
        git clone -q https://github.com/DoomCraw/dotfiles "${Global:dotfilesDir}"
    } else {
        Push-Location $Global:dotfilesDir\windows

        git pull origin master

        Pop-Location
    }
}


function Install-Dependencies {
    $wingetPackages | ForEach-Object {
        winget install --silent --accept-package-agreements --accept-source-agreements -e -s winget --id $PSItem
    }
    # For old programs installers
    # & msiexec.exe -i https://download.microsoft.com/download/748580b8-0e66-45c5-a4b0-dbd37a44e230/16BitInstallShieldSupport.msi
}


function Install-Dotfiles {
    Get-Dotfiles

    Push-Location $Global:dotfilesDir\windows

    $profileDir = (Split-Path $PROFILE -Parent)

    if (!(Test-Path $profileDir)) {
        New-Item -Path $profileDir -ItemType Directory
    }

    Copy-Item -Path ${PWD}\profile.ps1 -Destination $PROFILE -Force
    Copy-Item -Path ${PWD}\Home\** -Destination $HOME -Include ** -Recurse -Force

    if ((Test-Path 'C:\Program Files\PowerShell\7\pwsh.exe') -and $PSVersionTable.PSVersion.Major -le 5) {
        $pwshProfile = (& 'C:\Program Files\PowerShell\7\pwsh.exe' -c 'echo $PROFILE')
        $pwshProfileDir = (Split-Path $pwshProfile -Parent)

        if (!(Test-Path $pwshProfileDir)) {
            New-Item -Path $pwshProfileDir -ItemType Directory
        }

        Copy-Item -Path ${PWD}\profile.ps1 -Destination $pwshProfile -Force
    }

    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $powershellProfile = (& powershell.exe -NoLogo -Command 'echo $PROFILE')
        $powershellProfileDir = (Split-Path $powershellProfile -Parent)

        if (!(Test-Path $powershellProfileDir)) {
            New-Item -Path $powershellProfileDir -ItemType Directory
        }

        Copy-Item -Path ${PWD}\profile.ps1 -Destination $powershellProfile -Force
    }

    . $PROFILE
    # TODO: Refresh-Environment

    Pop-Location
}


function Install-VSCode {
    winget install --silent --accept-package-agreements --accept-source-agreements -e -s winget --id 'Microsoft.VisualStudioCode'

    if (!(Get-Command code.cmd -ErrorAction SilentlyContinue)) {
        Update-Path (Get-BinPath code.cmd) 
    }

    $vscodeExtensions | ForEach-Object {
        code --install-extension $PSItem
    }
}


function Install-WSL {
    Get-Dotfiles

    Push-Location $Global:dotfilesDir\windows
    
    . .\components\wsl\setup.ps1

    Pop-Location
}


# MAIN

# Install scoop
# Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"

if (!$Dependencies -and !$Dotfiles -and !$VSCode -and !$WSL) {
    $All = $true
}

if ($All -or $Dependencies) {
    Install-Dependencies
}

if ($All -or $Dotfiles) {
    Install-Dotfiles
}

if ($All -or $VSCode) {
    Install-VSCode
}

if ($All -or $WSL) {
    Install-WSL
}


Exit 0
