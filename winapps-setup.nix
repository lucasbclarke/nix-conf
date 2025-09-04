{ pkgs }:

pkgs.writeShellScriptBin "winapps-setup"
''
cd ~
${pkgs.git}/bin/git clone https://github.com/winapps-org/winapps.git
sudo cp -r ~/dotfiles/winapps/. /usr/bin/.
''
