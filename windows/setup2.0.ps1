# Install dependencies
@(
    '7zip.7zip',
    'Git.Git',
    'Google.Chrome',
    'Neovim.Neovim',
    'Notepad++.Notepad++',
    'Pritunl.PritunlClient',
    'Starship.Starship',
    'Tailscale.Tailscale',
    'Discord.Discord',
    'Telegram.TelegramDesktop',
    'SlackTechnologies.Slack',
    'Zig.Zig',
    'qBittorrent.qBittorrent',
    'wez.wezterm'
) |
ForEach-Object {
    winget install --silent --accept-package-agreements --accept-source-agreements -e -s winget --id $PSItem
}

Exit 0
