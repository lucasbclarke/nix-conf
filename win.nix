{ pkgs }:

pkgs.writeShellScriptBin "win"
''
podman compose --file ~/winapps/compose.yaml up
''
