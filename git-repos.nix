{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
sudo cp dotfiles/.zshrc ~/
sudo cp dotfiles/.tmux.conf ~/
sudo cp -r dotfiles/.tmux ~/
sudo cp dotfiles/i3/config ~/.config/i3/
mkdir ~/.config/ghostty/
sudo cp dotfiles/ghostty/config ~/.config/ghostty/config
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/nvim ~/.config/nvim
curl https://ziglang.org/download/0.14.1/zig-x86_64-linux-0.14.1.tar.xz -o zig-x86_64-linux-0.14.1.tar.xz
tar -xf zig-x86_64-linux-0.14.1.tar.xz
sudo ln -s ~/zig-x86_64-linux-0.14.1/zig /usr/bin/zig
reboot
''
