{ pkgs }:

pkgs.writeShellScriptBin "git-repos"
''
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/dotfiles
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/code
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/personal-website
${pkgs.git}/bin/git clone https://github.com/lucasbclarke/aoc
''
