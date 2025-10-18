Param (
    [switch]$All            = $false,
    [switch]$Dependencies   = $false,
    [switch]$Dotfiles       = $false,
    [switch]$WSL            = $false
)

$Global:dotfilesDir = "${HOME}\.dotfiles"

function Update-Path ($path) {
    $Env:Path = $Env:Path + ";${path}"
}


function Get-Dotfiles {
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        Update-Path "C:\Program Files\Git\cmd"
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
    @(
        '7zip.7zip',
        'Alacritty.Alacritty',
        'Amazon.AWSCLI',
        'Discord.Discord',
        'eza-community.eza',
        'Git.Git',
        'Google.Chrome',
        'Hashicorp.Terraform',
        'jqlang.jq',
        'junegunn.fzf',
        'Microsoft.PowerShell',
        'Microsoft.VisualStudioCode',
        'Neovim.Neovim',
        'Notepad++.Notepad++',
        'Pritunl.PritunlClient',
        'qBittorrent.qBittorrent',
        'SlackTechnologies.Slack',
        'Starship.Starship',
        'sxyazi.yazi',
        'Tailscale.Tailscale',
        'Telegram.TelegramDesktop',
        'wez.wezterm',
        'Zig.Zig'
    ) |
    ForEach-Object {
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

    if (Test-Path 'C:\Program Files\PowerShell\7\pwsh.exe') {
        $pwshProfile = (& 'C:\Program Files\PowerShell\7\pwsh.exe' -c 'echo $PROFILE')
        $pwshProfileDir = (Split-Path $pwshProfile -Parent)

        if (!(Test-Path $pwshProfileDir)) {
            New-Item -Path $pwshProfileDir -ItemType Directory
        }

        Copy-Item -Path ${PWD}\profile.ps1 -Destination $pwshProfile -Force
    }

    . $PROFILE
    Refresh-Environment

    Pop-Location
}


function Install-WSL {
    Get-Dotfiles

    Push-Location $Global:dotfilesDir\windows
    
    . .\components\wsl\setup.ps1

    Pop-Location
}


# MAIN


if ($All -or $Dependencies) {
    Install-Dependencies
}

if ($All -or $Dotfiles) {
    Install-Dotfiles
}

if ($All -or $WSL) {
    Install-WSL
}


Exit 0