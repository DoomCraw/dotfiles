wsl -d test -u root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath 'D:\git\personal\dotfiles\windows\components\wsl\firstboot.sh') `"$(${Env:USERNAME}.ToLower())`""
wsl -t test
wsl -d test -u root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath 'D:\git\personal\dotfiles\windows\components\wsl\resolvconf.sh')"
wsl -d test -u "$(${Env:USERNAME}.ToLower())" --shell-type standard /bin/bash -c 'cd ~; curl -fsSL https://raw.githubusercontent.com/DoomCraw/dotfiles/refs/heads/main/linux/setup.sh | sudo /bin/bash -'



wsl -d test -u root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath 'D:\git\personal\dotfiles\windows\components\wsl\firstboot.sh') `"$(${Env:USERNAME}.ToLower())`""
wsl -t test
wsl -d test -u "$(${Env:USERNAME}.ToLower())" --shell-type standard /bin/bash -c 'cd ~; curl -fsSL https://raw.githubusercontent.com/DoomCraw/dotfiles/refs/heads/main/linux/setup.sh | sudo /bin/bash -'
