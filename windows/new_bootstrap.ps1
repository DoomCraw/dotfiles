$profileDir = (Split-Path $PROFILE -Parent)

if (!(Test-Path $profileDir -PathType Container)) {
    New-Item -Path $profileDir -ItemType Directory
}

Copy-Item -Path ${PSScriptRoot}\Home\* -Destination $HOME -Include ** -Recurse -Force
Copy-Item -Path ${PSScriptRoot}\PSProfile\*.ps1 -Destination $profileDir -Include ** -Recurse -Force

Push-Location $profileDir

Move-Item -Path profile.ps1 -Destination $PROFILE -Force

Pop-Location

. $PROFILE

Refresh-Environment
