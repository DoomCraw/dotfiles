if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
  if ((& wsl.exe --status).length -eq 0) {
      & wsl.exe --install --no-distribution
      Set-Registry 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' @{InstallWSL = "$((Get-Command powershell.exe).Source) -NoLogo -ExecutionPolicy Bypass -File `"${PSCommandPath}`""}
      Exit 0
  }
} else {
    Write-Host 'WSL not found on this system'
    Exit 1
}

# To deploy with cloud-init $HOME\.cloud-init\<vmname>.user-data
$wslDir   ='D:\vms\wsl'
$wslName  ='workspace'
$wslImage = @{
    OutFile = "${Env:TEMP}\ubuntu-24.04-wsl-root.tar.xz"
    Uri     = @(
        'https://cloud-images.ubuntu.com',
        'releases/24.04/release-20250704',
        'ubuntu-24.04-server-cloudimg-amd64-root.tar.xz'
    ) -join '/'
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest @wslImage
if (!(Test-Path $wslDir)) {
    New-Item -Path $wslDir -ItemType Directory
}

wsl --import $wslName $wslDir\$wslName $wslImage.OutFile
wsl --set-default $wslName
wsl -d $wslName -u root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath `"${PSScriptRoot}\firstboot.sh`") `"$(${Env:USERNAME}.ToLower())`""
wsl -t $wslName
wsl -d $wslName -u root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath `"${PSScriptRoot}\resolvconf.sh`")"
wsl -d $wslName -u "$(${Env:USERNAME}.ToLower())" --shell-type standard /bin/bash -c 'cd ~; curl -fsSL https://raw.githubusercontent.com/DoomCraw/dotfiles/refs/heads/main/linux/setup.sh | sudo /bin/bash -'

Remove-Item -Path $wslImage.OutFile -Force

Exit 0
