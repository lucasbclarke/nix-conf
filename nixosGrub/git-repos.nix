{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/nvim ~/.config/nvim
curl -L -o "zig-latest-linux-x86_64.tar.xz" "$(curl -s https://ziglang.org/download/index.json | jq -r '.master."x86_64-linux".tarball')"
mkdir zig-latest-linux-x86_64
tar -xf zig-latest-linux-x86_64.tar.xz --strip-components=1 -C zig-latest-linux-x86_64
sudo rm -rf /usr/bin/zig
sudo ln -s ~/zig-latest-linux-x86_64/zig /usr/bin/zig
sudo cp /etc/nixos/hardware-configuration.nix ~/nix-conf/nixosVm/hardware-configuration.nix
''
