Push-Location (Split-Path $PROFILE -Parent)

"functions","aliases","exports","input","completion","powerconfig","virtualbox","wsl","psmodules","prompt" | 
ForEach-Object {
    Invoke-Expression ". .\${PSItem}.ps1"
}

Pop-Location