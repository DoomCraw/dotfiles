# Install dependencies
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

$dotfilesDir = "${HOME}\.dotfiles"
git clone -q https://github.com/DoomCraw/dotfiles "${dotfilesDir}"

Push-Location ${dotfilesDir}\windows

. .\bootstrap.ps1
. .\personalize.ps1
. .\components\wsl\setup.ps1

Pop-Location


Exit 0