function Reset-NetworkSettings {
    $ipconfigPath=(Get-Command -Name ipconfig.exe).Path
    Start-Process -FilePath $ipconfigPath -ArgumentList '/renew' -NoNewWindow -Wait
    Start-Sleep -Millisecond 100
    Start-Process -FilePath $ipconfigPath -ArgumentList '/flushdns' -NoNewWindow -Wait
}

function Reload-Wsl {
    Stop-Process -Name pritunl -Force -ErrorAction SilentlyContinue
    Stop-Process -Name tailscale-ipn -Force -ErrorAction SilentlyContinue
    Stop-Service -Name pritunl -Force
    Stop-Service -Name tailscale -Force
    Start-Sleep -Millisecond 100
    & wsl --shutdown
    Stop-Service -Name WSLService -Force
    Start-Sleep -Millisecond 100
    Reset-NetworkSettings
    Start-Sleep -Millisecond 100
    Start-Service -Name WSLService
    Start-Sleep -Millisecond 100
    Start-Service -Name pritunl
}

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

function Test-PortConnection {
    param (
        [string]$HostName,
        [int]$Port,
        [int]$Timeout
    )
    $callback = $state = $null
    $TcpClient = New-Object System.Net.Sockets.TcpClient
    $TcpClient.BeginConnect($HostName,$Port,$callback,$state) | Out-Null
    Start-Sleep -Seconds $Timeout
    $result = $TcpClient.Connected
    $TcpClient.Close()
    $result
}

function Start-SSHTunnels {
    if (!(Test-PortConnection -HostName 127.0.0.1 -Port 1443 -Timeout 1) -and !(Test-PortConnection -HostName 127.0.0.1 -Port 2443 -Timeout 1)) {
        if ((Test-PortConnection -HostName vzaytsev-test.ascalon.ae -Port 22 -Timeout 1)) {
            $null = Start-Process -FilePath ssh.exe -ArgumentList '-o StrictHostKeyChecking=no -o ControlMaster=no -p 22 -N -C -L 127.0.0.1:1443:10.18.42.43:443 ubuntu@vzaytsev-test.ascalon.ae' -WindowStyle Hidden;
            Start-Sleep -Seconds 5;
    		$null = Start-Process -FilePath ssh.exe -ArgumentList '-o StrictHostKeyChecking=no -o ControlMaster=no -p 22 -N -C -L 127.0.0.1:2443:10.18.42.44:443 ubuntu@vzaytsev-test.ascalon.ae' -WindowStyle Hidden;
        } else {
            Write-Host 'Can''t start tunneling vzaytsev-test.ascalon.ae not available.'
        }	
    } else {
        Write-Host 'Tunnels already exists.'
    }
    Get-Process -Name ssh -ErrorAction SilentlyContinue
}

function Set-AWSEnvironment {
    $Env:AWS_ACCESS_KEY_ID=(Read-Host -Prompt 'AWS_ACCESS_KEY_ID')
    $Env:AWS_SECRET_ACCESS_KEY=(Read-Host -Prompt 'AWS_SECRET_ACCESS_KEY')
}