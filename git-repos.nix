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
curl -L -o "zig-latest-linux-x86_64.tar.xz" "$(curl -s https://ziglang.org/download/index.json | jq -r '.master."x86_64-linux".tarball')"
mkdir zig-latest-linux-x86_64
tar -xf zig-latest-linux-x86_64.tar.xz --strip-components=1 -C zig-latest-linux-x86_64
sudo rm -rf /usr/bin/zig
sudo ln -s ~/zig-latest-linux-x86_64/zig /usr/bin/zig


if [ -d "$HOME/zls_source_temp" ]; then
    rm -rf "$HOME/zls_source_temp"
fi

git clone "https://github.com/zigtools/zls.git" "$HOME/zls_source_temp"

pushd "$HOME/zls_source_temp"
zig build
popd

ZLS_EXEC_PATH="$HOME/zls_source_temp/zig-out/bin/zls"

mkdir -p "$HOME/zig-latest-linux-x86_64/bin"
mv "$HOME/zls_source_temp/zig-out/bin/zls" "$HOME/zig-latest-linux-x86_64/bin/zls"

sudo rm -f /usr/bin/zls

sudo ln -s "$HOME/zig-latest-linux-x86_64/bin/zls" /usr/bin/zls

rm -rf "$HOME/zls_source_temp"
''
