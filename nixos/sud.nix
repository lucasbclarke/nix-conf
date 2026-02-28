{ pkgs }:

pkgs.writeShellScriptBin "sud"
''
$(which sudo) -E -s "$@"
''
