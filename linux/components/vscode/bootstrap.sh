#!/bin/bash


vscode_extensions=(
    "bubbla.tortoise-theme"
    "codefaster.auto-code-formatter-for-react-v0-1"
    "eamodio.gitlens"
    "frhtylcn.pythonsnippets"
    "grafana.vscode-jsonnet"
    "hashicorp.terraform"
    "httpsterio.henna"
    "jdinhlife.gruvbox"
    "lelinpadhan.retro-green-theme-vscode"
    "mads-hartmann.bash-ide-vscode"
    "metaphore.kanagawa-vscode-color-theme"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-ssh-edit"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode-remote.vscode-remote-extensionpack"
    "ms-vscode.makefile-tools"
    "ms-vscode.powershell"
    "ms-vscode.remote-explorer"
    "ms-vscode.remote-server"
    "napmz.purple-green-theme"
    "redhat.ansible"
    "redhat.vscode-yaml"
    "sebbia.jsonnetng"
)


for vscode_extension in ${vscode_extensions[@]}; do
    code --install-extension "${vscode_extension}"
done


exit 0