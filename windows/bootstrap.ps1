$PROFILE_PATH=(Split-Path $PROFILE -Parent)
$APPDATA_DIR_PATH=(Split-Path $env:APPDATA -Parent)

Push-Location $PSScriptRoot

if (!(Test-Path $PROFILE_PATH -ErroAction SilentlyContinue)) {
    New-Item -Force -ItemType Directory -Path "${PROFILE_PATH}"
}

Copy-Item -Force -Exclude "bootstrap.ps1" -Path ".\*.ps1" -Destination "${PROFILE_PATH}"

Copy-Item -Recurse -Force -Path ".\AppData\*" -Destination "${APPDATA_DIR_PATH}"

@'
. ${PROFILE_PATH}\profile.ps1
'@ | Out-File -Force -NoNewline -Encoding ascii -FilePath $PROFILE

Pop-Location

Exit 0
