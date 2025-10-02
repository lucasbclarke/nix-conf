{ config, pkgs, lib, inputs, ... }:

{
  environment.variables.EDITOR = "nvim";
  nixpkgs.config.allowUnsupportedSystem = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes 
  '';
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];
  
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/lucas/.config/sops/age/keys.txt";
  sops.secrets.example-key = { };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  time.hardwareClockInLocalTime = true;

  networking.hostName = "nixosGrub";
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
        waybar     
        wl-clipboard 
        grim slurp 
        wf-recorder 
        brightnessctl 
        playerctl  
        wmenu
        i3status
        swaynotificationcenter
      ];
  };
  security.polkit.enable = true;


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
  services.printing.drivers = [
    pkgs.cnijfilter2
    pkgs.gutenprint
    pkgs.cups-bjnp
  ];

  services.avahi = {
    enable = true; 
    nssmdns4 = true;
  };

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
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "vboxusers" ];
    shell = pkgs.zsh;
  };

  programs = {
    zsh.enable = true;
    git.enable = true;

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
     sqlite tldr fzf xdotool brave xfce.exo xfce.xfce4-settings
     unzip arduino-cli discord gcc cloudflare-warp neofetch
     pavucontrol vlc usbutils udiskie udisks samba sway wayland-scanner
     libGL libGLU powersupply lunar-client feh file-roller jq pulseaudio
     lua-language-server xfce.xfce4-screenshooter gh cargo gnumake
     gcc-arm-embedded python2 python3Packages.pip swig file clang-tools
     net-tools iproute2 blueman networkmanager bluez bluez-tools dnsmasq
     swaysettings sway-launcher-desktop jetbrains-mono dive podman-tui
     docker-compose freerdp dialog libnotify podman podman-compose
     xwayland ncdu gtk3 libnotify nss xorg.libXtst xdg-utils dpkg
     brasero inetutils sops 
     (import ./git-repos.nix {inherit pkgs;})
     (import ./sud.nix {inherit pkgs;})
     (import ./zls-repo.nix {inherit pkgs;})
     (import ./winapps-setup.nix {inherit pkgs;})
     (import ./hm-setup.nix {inherit pkgs;})
     inputs.winapps.packages."${pkgs.system}".winapps
     inputs.winapps.packages."${pkgs.system}".winapps-launcher
     inputs.nixd.packages."${pkgs.system}".nixd
     inputs.nil.packages."${pkgs.system}".nil
  ];

  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };
  services.udisks2.enable = true;

  services.cloudflare-warp.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["lucas"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  nix.settings = {
    substituters = [ "https://winapps.cachix.org/" ];
    trusted-public-keys = [ "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g=" ];
    trusted-users = [ "lucas" ]; # replace with your username
  };

  fonts = {
    fontconfig.enable = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  boot.blacklistedKernelModules = lib.mkForce [ ];
  boot.extraModprobeConfig = ''
    blacklist # cleared by NixOS config
  '';

  system.activationScripts.removeKvmBlacklist.text = ''
    rm -f /etc/modprobe.d/blacklist-kvm.conf
  '';
  boot.kernelModules = [ "kvm" "kvm_amd" ];

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
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # or false for proprietary driver
    nvidiaSettings = true;
  };

}
