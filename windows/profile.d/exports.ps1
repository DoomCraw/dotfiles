$Env:EDITOR = 'nvim.exe'
$Env:HOSTS = "${Env:WINDIR}\System32\drivers\etc\hosts"
$Env:PATH = @(
    'C:\Windows\system32',
    'C:\Windows',
    'C:\Windows\System32\Wbem',
    'C:\Windows\System32\WindowsPowerShell\v1.0\',
    'C:\Program Files\Neovim\bin',
    'C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common',
    'C:\Windows\System32\OpenSSH',
    'C:\Program Files\Git',
    'C:\Program Files\Git\cmd',
    'C:\Program Files\Git\bin',
    'C:\Program Files\Git\usr\bin',
    'C:\Program Files\Git\mingw64\bin',
    'C:\java\jdk-21.0.2\bin',
    'C:\Program Files\Notepad++',
    'C:\Program Files\Tailscale',
    'C:\Program Files\Oracle\VirtualBox',
    'C:\Program Files\starship\bin',
    'C:\Program Files\Graphviz\bin',
    'C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit',
    'C:\Users\doomc\AppData\Local\Microsoft\WindowsApps',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312\Scripts',
    'C:\Users\doomc\AppData\Local\Programs\Python\Python312',
    'C:\Users\doomc\AppData\Local\Programs\Python\Launcher',
    'C:\Users\doomc\AppData\Local\Programs\Microsoft VS Code\bin'
) -join ';'
$Env:STARSHIP_CONFIG = "${Env:USERPROFILE}\.starship\starship.toml"