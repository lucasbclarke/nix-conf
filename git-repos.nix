{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
sleep 10
sudo cp dotfiles/.zshrc ..
sleep 10
sudo cp dotfiles/.tmux.conf ..
sleep 10
sudo cp dotfiles/i3/config ~/.config/i3/config
sleep 10
sudo cp dotfiles/ghostty/config ~/.config/ghostty/config
sleep 10
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
sleep 10
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
''
