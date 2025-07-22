# Install dependencies
@(
    'Alacritty.Alacritty',
    'Git.Git',
    'Microsoft.VisualStudioCode',
    'Neovim.Neovim',
    'Notepad++.Notepad++',
    'qBittorrent.qBittorrent',
    'Starship.Starship',
    'wez.wezterm',
    'Zig.Zig',
    'Hashicorp.Terraform',
    '7zip.7zip'
) | 
ForEach-Object {
    winget install -e -s winget --id $PSItem
}

# Bootstrap dotfiles
git clone https://github.com/DoomCraw/dotfiles.git "${HOME}\.dotfiles"
. "${HOME}\.dotfiles\bootstrap.ps1"
. "${HOME}\.dotfiles\wsl\setup.ps1"

Exit 0