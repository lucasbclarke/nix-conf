{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
sudo cp dotfiles/.zshrc ..
sudo cp dotfiles/.tmux.conf ..
sudo cp dotfiles/i3/config ~/.config/i3/config
sudo cp dotfiles/ghostty/config ~/.config/ghostty/config
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
''
