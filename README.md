### Nixos Configuration

This repository contains all of my configuration of nixos through the use of flakes. I have three varients, one for older hardware which use the GRUB bootloader, one for newer machines
using the SystemD bootloader, and one for virtual machines (which has a number of packagses removed that are not needed when running nixos in a virtual machine - such as virt-manager
and winapps).

Also in this repository is my configuration for home-manager which manages all programs that were previously managed in the 
[lucasbclarke/dotfiles](https://github.com/lucasbclarke/dotfiles). These configurations are located in the usr directory.
