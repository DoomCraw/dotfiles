if ((& wsl.exe --status).length -eq 0) {
    & wsl.exe --install --no-distribution
    Set-Registry 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' @{InstallWSL = "$((Get-Command powershell.exe).Source) -NoLogo -ExecutionPolicy Bypass -File `"${PSCommandPath}`""}
    Exit 0
}

Exit 0