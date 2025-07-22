if (Test-Path Alias:\ls) { Remove-Item Alias:\ls }
if (Test-Path Alias:\curl) { Remove-Item Alias:\curl }
if (Test-Path Alias:\kill) { Remove-Item Alias:\kill }

${function:grep}  = { & grep.exe --color @args }
${function:curl}  = { & curl.exe --ssl-no-revoke @args }
${function:ls}    = { & ls.exe --color @args }
${function:ll}    = { & ls.exe --color -la @args }
${function:l}    = { Get-ChildItem @args }
${function:unzip} = { Expand-Archive @args }
${function:\~} = { Set-Location $HOME }
${function:\..} = { Set-Location .. }
${function:...} = { Set-Location ../.. }
${function:....} = { Set-Location ../../.. }
${function:.....} = { Set-Location ../../../.. }

function vim {
    if (Get-Command nvim.exe -ErrorAction SilentlyContinue) {
        & nvim.exe @args
    } else {
        & vim.exe @args
    }
}

function kill ([string]$proc) {
    Get-Process $proc | Stop-Process -Force -ErrorAction SilentlyContinue
}

function which([string]$name = "") {
    if ($name -eq "") {
        return ""
    } 
    Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition
}