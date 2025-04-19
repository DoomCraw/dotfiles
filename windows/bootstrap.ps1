Push-Location $PSScriptRoot
# Copy-Item -Force -Path .\functions.ps1 -Destination (Split-Path $PROFILE -Parent)
# Copy-Item -Force -Path .\aliases.ps1 -Destination (Split-Path $PROFILE -Parent)
Copy-Item -Force -Path .\profile.ps1 -Destination (Split-Path $PROFILE -Parent)
@'
. $(Split-Path $PROFILE -Parent)\profile.ps1
'@ | Out-File -Force -NoNewline -Encoding ascii -FilePath $PROFILE
# Copy-Item -Force -Path .wezterm.lua -Destination $HOME
# Copy-Item -Recurse -Force -Path .neovim -Destination $HOME
Copy-Item -Recurse -Force -Path .\AppData -Destination (Split-Path $env:APPDATA -Parent)
Pop-Location