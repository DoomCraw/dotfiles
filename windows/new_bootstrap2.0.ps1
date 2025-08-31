$profileDir = (Split-Path $PROFILE -Parent)

if (!(Test-Path $profileDir)) {
    New-Item $profileDir -ItemType Directory
}

Copy-Item ${PSScriptRoot}\profile.ps1 $PROFILE -Force
Copy-Item ${PSScriptRoot}\Home\* $HOME -Include ** -Recurse -Force

. $PROFILE
Refresh-Environment

Exit 0
