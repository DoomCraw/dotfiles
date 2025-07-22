# Install dependencies
@(
    '7zip.7zip',
    'Alacritty.Alacritty',
    'Git.Git',
    'Google.Chrome',
    'Hashicorp.Terraform',
    'Microsoft.VisualStudioCode',
    'Neovim.Neovim',
    'Notepad++.Notepad++',
    'Pritunl.PritunlClient',
    'Starship.Starship',
    'Tailscale.Tailscale',
    'Zig.Zig',
    'qBittorrent.qBittorrent',
    'wez.wezterm'
) | 
ForEach-Object {
    winget install -e -s winget --id $PSItem
}

# Bootstrap dotfiles
git clone https://github.com/DoomCraw/dotfiles.git "${HOME}\.dotfiles"
. "${HOME}\.dotfiles\windows\bootstrap.ps1"
. "${HOME}\.dotfiles\windows\wsl\setup.ps1"

# TODO: Registry, services, etc.

Exit 0