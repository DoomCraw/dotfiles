$PROFILE_PATH=(Split-Path $PROFILE -Parent)

Push-Location $PSScriptRoot

if (!(Test-Path $PROFILE_PATH)) {
    New-Item "${PROFILE_PATH}" -ItemType Directory -Force
}

Copy-Item -Path .\* -Destination $HOME -Exclude profile.d,wsl,bootstrap.ps1,setup.ps1 -Include ** -Recurse -Force
Copy-Item -Path .\profile.d\* -Destination $PROFILE_PATH -Include ** -Recurse -Force

'. "$(Split-Path $PROFILE -Parent)\profile.ps1"' | 
Out-File -FilePath $PROFILE -Force -Encoding ascii -NoNewline

if (!(Test-Path "${HOME}\AppData\Roaming\alacritty\themes")) {
    git clone -q https://github.com/alacritty/alacritty-theme "${HOME}\AppData\Roaming\alacritty\themes"
}

if (!(Test-Path "${Env:LOCALAPPDATA}\nvim")) {
    git clone -q https://github.com/LazyVim/starter "${Env:LOCALAPPDATA}\nvim"
    # TODO: add lazyvim configs
}

Pop-Location

. $PROFILE

Refresh-Environment

Exit 0