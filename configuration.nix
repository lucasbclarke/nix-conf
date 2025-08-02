{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnsupportedSystem = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes 
  '';
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Universal boot configuration that works on any machine
  boot.loader = {
    # Enable EFI support if available
    efi.canTouchEfiVariables = lib.mkDefault true;
    
    # Use systemd-boot for UEFI systems (modern approach)
    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 10;
      editor = false; # Disable editor for security
    };
    
    # Fallback to GRUB for legacy BIOS systems or when systemd-boot is not available
    grub = {
      enable = lib.mkDefault false;
      # Automatically detect devices - no hardcoded paths
      devices = lib.mkDefault [];
      useOSProber = lib.mkDefault true;
      # Enable GRUB if systemd-boot is not available
      enable = lib.mkIf (!config.boot.loader.systemd-boot.enable) true;
    };
  };

  # Remove the specialisation section as it's no longer needed
  # The configuration above will automatically adapt to the system

  time.hardwareClockInLocalTime = true;

  networking.hostName = "nixos";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # To support GTK apps under Wayland
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wofi       # or bemenu, fuzzel — your choice
        waybar     # for a status bar
        mako       # Wayland-native notification daemon
        wl-clipboard # for clipboard functionality
        grim slurp # for screenshots
        wf-recorder # for screen recording (optional)
        brightnessctl # for brightness key support
        playerctl  # for media control
        wmenu
        i3status
      ];
  };


  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
    };

  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.system-config-printer.enable = true;
  services.samba.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.lucas = {
    isNormalUser = true;
    description = "lucas";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    git.enable = true;
    tmux.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-vcs-plugin
      ];
    };

    xfconf.enable = true;

    thunderbird.enable = true;
    wshowkeys.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  systemd.services.sway = {
    description = "Sway Wayland Compositor";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
  };


  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.8"
  ];

  environment.systemPackages = with pkgs; [
     ghostty sqlite tldr fzf xdotool brave xfce.exo xfce.xfce4-settings
     unzip arduino-cli discord gcc cloudflare-warp neofetch
     pavucontrol vlc usbutils udiskie udisks samba wf-recorder
     sway wayland-scanner libGL libGLU powersupply lunar-client
     feh file-roller jq pulseaudio lua-language-server xfce.xfce4-screenshooter
     gh cargo gnumake gcc-arm-embedded python2 python2Packages.pip
     swig file
     (import ./git-repos.nix {inherit pkgs;})
     (import ./sud.nix {inherit pkgs;})
     (import ./ohmyzsh.nix {inherit pkgs;})
     (import ./zls-repo.nix {inherit pkgs;})
  ];

  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };
  services.udisks2.enable = true;

  services.cloudflare-warp.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["your_username"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "24.11";

}
