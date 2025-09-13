{ pkgs }:

pkgs.writeShellScriptBin "zls-repo"
''
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
