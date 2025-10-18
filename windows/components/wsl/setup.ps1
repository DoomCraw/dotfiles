function Set-Registry {
    Param (
        [PSCustomObject]$Path,
        [System.Collections.Hashtable]$Keys
    )
    if (!(Test-Path $Path)) {
        New-Item -Force -Path $Path | Out-Null
    }
    $Keys.Keys | ForEach-Object {
        Set-ItemProperty -Force -Path $Path -Name $PSItem -Value $Keys[$PSItem] | Out-Null
    }
}


# Enable WSL
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
if ((Get-Volume).DriveLetter -eq 'D') {
    $imagesDir = 'D:\vms\images'
    $wslDir    = 'D:\vms\wsl'
} else {
    $imagesDir = "${Env:USERPROFILE}\Documents\vms\images"
    $wslDir    = "${Env:USERPROFILE}\Documents\vms\wsl"
}

$wslName   = 'workspace'
$wslImage  = @{
    OutFile = "${imagesDir}\ubuntu-24.04-server-cloudimg-amd64-root.tar.xz"
    Uri     = @(
        'https://cloud-images.ubuntu.com',
        'releases/24.04/release-20251001',
        'ubuntu-24.04-server-cloudimg-amd64-root.tar.xz'
    ) -join '/'
}

if (!(Test-Path $imagesDir)) {
    New-Item -Path $imagesDir -ItemType Directory
}

if (!(Test-Path $wslDir)) {
    New-Item -Path $wslDir -ItemType Directory
}

if (!(Test-Path $wslImage.OutFile)) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest @wslImage
}

Copy-Item -Path "${PSScriptRoot}\.wslconfig" -Destination "${Env:USERPROFILE}\.wslconfig" -Force
wsl --shutdown

wsl --import $wslName $wslDir\$wslName $wslImage.OutFile
wsl --set-default $wslName
wsl -d $wslName -u root --shell-type standard /bin/bash -c "/bin/bash `$(wslpath '${PSScriptRoot}\firstboot.sh') `"$(${Env:USERNAME}.ToLower())`" `"$(${Env:COMPUTERNAME}.ToLower())`""
wsl -t $wslName
wsl -d $wslName -u "$(${Env:USERNAME}.ToLower())" --shell-type standard /bin/bash -c 'cd ~; curl -fsSL https://raw.githubusercontent.com/DoomCraw/dotfiles/refs/heads/main/linux/setup.sh | sudo /bin/bash -'


Exit 0