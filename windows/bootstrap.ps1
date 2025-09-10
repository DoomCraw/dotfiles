$profileDir = (Split-Path $PROFILE -Parent)

if (!(Test-Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory
}

Copy-Item -Path ${PSScriptRoot}\profile.ps1 -Destination $PROFILE -Force
Copy-Item -Path ${PSScriptRoot}\Home\** -Destination $HOME -Include ** -Recurse -Force

. $PROFILE
Refresh-Environment

Exit 0
