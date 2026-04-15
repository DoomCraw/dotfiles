#!/bin/bash


test -d ~/.local/share/fonts || mkdir -p ~/.local/share/fonts


pushd ~/.local/share/fonts

wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip' -O JetBrainsMono.zip
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip' -O FiraCode.zip
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/BitstreamVeraSansMono.zip' -O BitstreamVeraSansMono.zip


for zip_file in *.zip; do
    unzip -of "${zip_file}"
done


rm -f *.zip

popd


fc-cache -fv


exit 0