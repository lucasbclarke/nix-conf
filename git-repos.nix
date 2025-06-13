{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
sudo cp dotfiles/.zshrc ~/
sudo cp dotfiles/.tmux.conf ~/
sudo cp dotfiles/.tmux ~/
sudo cp dotfiles/i3/config ~/.config/i3/
mkdir ~/.config/ghostty/
sudo cp dotfiles/ghostty/config ~/.config/ghostty/config
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
''
