if ((& wsl.exe --status).length -eq 0) {
    & wsl.exe --install --no-distribution
    Set-Registry 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' @{InstallWSL = "$((Get-Command powershell.exe).Source) -NoLogo -ExecutionPolicy Bypass -File `"${PSCommandPath}`""}
    Exit 0
}

$wsl_dir='D:\vms\wsl'
$wsl_name='workspace'
$wsl_image=@{
    "Uri"=("https://cloud-images.ubuntu.com",
        "releases/24.04/release-20250704",
        "ubuntu-24.04-server-cloudimg-amd64-root.tar.xz" -join "/")
    "OutFile"="${Env:TEMP}\ubuntu-24.04-wsl-root.tar.xz"
}

Invoke-WebRequest @wsl_image
if (!(Test-Path $wsl_dir)) {
    New-Item $wsl_dir -ItemType Directory
}

wsl --import $wsl_name $wsl_dir\$wsl_name $wsl_image.OutFile
wsl --set-default $wsl_name
wsl -d $wsl_name -u root --cd /root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath `"${PSScriptRoot}\firstboot.sh`") `"${Env:USERNAME.ToLower()}`""
wsl -t $wsl_name
wsl -d $wsl_name -u root /bin/bash -c "/bin/bash `$(wslpath `"${PSScriptRoot}\resolvconf.sh`")"
wsl -d $wsl_name -u ${Env:USERNAME.ToLower()} /bin/bash -c 'cd ~; curl -fsSL https://raw.githubusercontent.com/DoomCraw/dotfiles/refs/heads/main/linux/setup.sh | sudo /bin/bash -'

Remove-Item $wsl_image.OutFile -Force

Exit 0