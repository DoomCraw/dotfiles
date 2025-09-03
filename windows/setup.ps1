# Install dependencies
@(
    '7zip.7zip',
    'Alacritty.Alacritty',
    'Discord.Discord',
    'Git.Git',
    'Google.Chrome',
    'Hashicorp.Terraform',
    'Microsoft.VisualStudioCode',
    'Neovim.Neovim',
    'Notepad++.Notepad++',
    'Pritunl.PritunlClient',
    'Starship.Starship',
    'SlackTechnologies.Slack',
    'Tailscale.Tailscale',
    'Telegram.TelegramDesktop',
    'Zig.Zig',
    'qBittorrent.qBittorrent',
    'wez.wezterm'
) |
ForEach-Object {
    winget install --silent --accept-package-agreements --accept-source-agreements -e -s winget --id $PSItem
}

# Bootstrap dotfiles
git clone https://github.com/DoomCraw/dotfiles.git "${HOME}\.dotfiles"
$dotfilesDir="${HOME}\.dotfiles\windows" 
$profilePath = (Split-Path $PROFILE -Parent)
if (!(Test-Path $profilePath)) {
  New-Item $profilePath -ItemType Directory -Force
  Copy-Item -Path ${dotfilesDir}\profile\* -Destination $profilePath -Include ** -Recurse -Force
  Copy-Item -Path ${dotfilesDir} -Destination $HOME -Include ** -Exclude setup.ps1,profile -Recurse -Force
}

# . "${dotfilesDir}\bootstrap.ps1"
. "${dotfilesDir}\wsl\setup.ps1"

# ############ ( ----------------     Registry    ----------------) ############


if ($Registry -or $All) {
  . "${dotfilesDir}\setup\registry.ps1"
}

# ############ ( ----------------     Services    ----------------) ############
# Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\OneSyncSvc -Name Start -Value 4
# Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\PhoneSvc -Name Start -Value 4


if ($Registry -or $All) {
  . "${dotfilesDir}\setup\services.ps1"
}

# ############ ( ---------------- Scheduled Tasks ----------------) ############


if ($Registry -or $All) {
  . "${dotfilesDir}\setup\scheduled_tasks.ps1"
}


Exit 0
