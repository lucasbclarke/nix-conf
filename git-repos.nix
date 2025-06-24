{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
sudo cp dotfiles/.zshrc ~/
sudo cp dotfiles/.tmux.conf ~/
sudo cp -r dotfiles/.tmux ~/
mkdir ~/.config/sway/
sudo cp dotfiles/sway/config ~/.config/sway/
mkdir ~/.config/ghostty/
sudo cp dotfiles/ghostty/config ~/.config/ghostty/config
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/game-project ~/code/projects/zig/game-project/
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/nvim ~/.config/nvim
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/raylib-repo
sudo mv raylib-repo/raylib .
sudo mv raylib-repo/raylib-zig .
curl https://ziglang.org/download/0.14.1/zig-x86_64-linux-0.14.1.tar.xz -o zig-x86_64-linux-0.14.1.tar.xz
tar -xf zig-x86_64-linux-0.14.1.tar.xz
sudo ln -s ~/zig-x86_64-linux-0.14.1/zig /usr/bin/zig
reboot
''
