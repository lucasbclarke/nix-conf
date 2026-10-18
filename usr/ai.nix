{ config, lib, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # Pi coding-agent CLI (from the pi flake). Provides `pi`, which the
  # interactive-subagents tmux children also invoke by name, so it must be on PATH.
  pi = inputs.pi.packages.${system}.default;

  # Diagram rendering for the learn "visualize" skill / mermaid-maker /
  # svg-maker subagents. nixpkgs mermaid-cli bundles a working Chromium and
  # exports PUPPETEER_EXECUTABLE_PATH in its wrapper; librsvg provides
  # rsvg-convert (used by svg-maker).
  mermaid-cli = pkgs.mermaid-cli;
  chromium = pkgs.chromium;
  librsvg = pkgs.librsvg;
in
{
  home.packages = [
    pi
    mermaid-cli
    chromium
    librsvg
  ];

  home.sessionVariables = {
    # Fallback in case mermaid-cli's wrapper env is not enough for the
    # custom puppeteer config the visual-tools extension writes.
    PUPPETEER_EXECUTABLE_PATH = "${chromium}/bin/chromium";
  };

  # The visual-tools extension hardcodes its renderer to
  # <extension>/node_modules/.bin/mmdc. Point that at the nixpkgs mermaid-cli
  # so no `npm install` is required and rendering uses the bundled Chromium.
  home.file."learn/.pi/extensions/visual-tools/node_modules/.bin/mmdc".source =
    "${mermaid-cli}/bin/mmdc";
}
