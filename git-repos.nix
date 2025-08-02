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
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/nvim ~/.config/nvim
curl -L -o "zig-latest-linux-x86_64.tar.xz" "$(curl -s https://ziglang.org/download/index.json | jq -r '.master."x86_64-linux".tarball')"
mkdir zig-latest-linux-x86_64
tar -xf zig-latest-linux-x86_64.tar.xz --strip-components=1 -C zig-latest-linux-x86_64
sudo rm -rf /usr/bin/zig
sudo ln -s ~/zig-latest-linux-x86_64/zig /usr/bin/zig
reboot
''
