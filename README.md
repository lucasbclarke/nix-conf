### Nixos Configuration

This repository contains all of my configuration of nixos through the use of flakes.

Also in this repository is my configuration for home-manager which manages all programs that were previously managed in the 
[lucasbclarke/dotfiles](https://github.com/lucasbclarke/dotfiles). These configurations are located in the usr directory.


### NixConf: Declarative System Configuration

Manually configuring a development machine is error-prone, time-consuming, and is not reproducible. A simple change on one machine often requires tedious manual steps to replicate elsewhere.
Nixos solves this by configuring the entire system through declarative, reproducible code.

Features & Functionality:
Full System Definition: Manages OS packages, services, and user settings declaratively.
Home-Manager Integration: Provides a consistent, version-controlled experience for user-level applications and configurations.
Immutability Guarantee: Ensures that system state cannot drift from what is defined.

##TODO Figure out how to use nix run
Getting Started:
1. Prerequisites: A machine running NixOS.
2. Setup: git clone https://github.com/lucasbclarke/nix-conf
3. Apply Config: nixos-rebuild switch --flake .#hostname --impure.

Challenges:
Initially, managing package dependencies across different services proved complex and prone to errors with incorrect versions and dependencies. Switching to the Nix package management system 
allowed me to accurately manage dependencies, ensuring that services could reliably use a specific version of required libraries. This solidified my understanding of dependency resolution in
Nix's functional programming paradigms.
