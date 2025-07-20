# Software installation
winget install -s winget -e --id Alacritty.Alacritty
winget install -s winget -e --id Notepad++.Notepad++
winget install -s winget -e --id 7zip.7zip
winget install -s winget -e --id Zig.Zig
winget install -s winget -e --id Git.Git
winget install -s winget -e --id Neovim.Neovim
winget install -s winget -e --id qBittorrent.qBittorrent
winget install -e -s winget --id Microsoft.VisualStudioCode
winget install -e -s winget --id wez.wezterm

# Terraform

# Registry parameters
Set-Registry


# Power profile config
& powercfg.exe

# Services
# Bootstrap dotfiles
git clone repo $HOME\.dotfiles
$HOME\.dotfiles\bootstrap.ps1
$HOME\.dotfiles\wsl\setup.ps1
# Install Alacritty themes TODO: Move to bootstrap.ps1
# Install lazyvim TODO: Move to bootstrap.ps1
git clone 

Exit 0
