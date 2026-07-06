#!/bin/zsh
# Install PowerShell Core to MacOSX

RED=""
GREEN=""
BLUE=""
YELLOW=""
NC=""

info () {}
error () {}
warn () {}
success () {}

info "MacOS ${RELEASE} ${VERSION} detected."
info "PowerShell Core will be installed using brew."
brew install pwsh
if [[ $? -eq 0 ]]; then
    success "PowerShell Core installed."
else
    error "PowerShell Core can't installed using brew. Brew error code: $?."
fi

exit 0