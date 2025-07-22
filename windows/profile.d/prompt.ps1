function prompt {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    $prefix = $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
                elseif ($principal.IsInRole($adminRole)) { "[ADMIN]: " }
                else { '' })
    $body = 'PS ' + $(Get-Location)
    $suffix = $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
    $prefix + $body + $suffix
}

## Create $PSStyle if running on a version older than 7.2
## - Add other ANSI color definitions as needed

if ($PSVersionTable.PSVersion.ToString() -lt '7.2.0') {
    # define escape char since "`e" may not be supported
    $esc = [char]0x1b
    $PSStyle = [PSCustomObject]@{
        Foreground = @{
            Red = "${esc}[31m"
            Green = "${esc}[32m"
            Yellow = "${esc}[33m"
            Blue = "${esc}[34m"
            Magenta = "${esc}[35m"
            BrightRed = "${esc}[91m"
            BrightGreen = "${esc}[92m"
            BrightYellow = "${esc}[93m"
            BrightBlue = "${esc}[94m"
            BrightMagenta = "${esc}[95m"
        }
        Background = @{
            BrightBlack = "${esc}[100m"
        }
    }
}

## Set PSReadLine options and keybindings
$PSROptions = @{
    ContinuationPrompt = '> '
    Colors             = @{
        Operator         = $PSStyle.Foreground.BrightBlue
        Parameter        = $PSStyle.Foreground.BrightGreen
        Selection        = $PSStyle.Background.BrightBlack
        # InLinePrediction = $PSStyle.Foreground.BrightYellow + $PSStyle.Background.BrightBlack
    }
}
Set-PSReadLineOption @PSROptions

Invoke-Expression "& starship.exe init powershell"