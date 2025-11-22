{ config, pkgs, lib, inputs, ... }:
let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l ; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd 'sway --unsupported-gpu'";
        user = "lucas";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
    zsh
  '';

  environment.variables = {
    EDITOR = "nvim";
    # Force dark mode for GTK applications
    GTK_THEME = "Adwaita-dark";
    # Force dark mode for Qt applications
    QT_STYLE_OVERRIDE = "gtk2";
    # Set color scheme preference to dark
    COLORTERM = "truecolor";
    # Additional dark mode environment variables
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    QT_QPA_PLATFORMTHEME = "gtk2";
    # Additional dark mode settings
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1";
  };

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      nvidia-vaapi-driver
      intel-media-driver
    ];
  };

  sops.defaultSopsFile = /home/lucas/nix-conf/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/lucas/.config/sops/age/keys.txt";
  sops.secrets.example-key = { };

  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkForce false;

  time.hardwareClockInLocalTime = true;

  networking.hostName = "nixosSystemD";
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
      wrapperFeatures.gtk = true; 
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard 
        grim slurp 
        wf-recorder 
        brightnessctl 
        playerctl  
        i3status
        swaynotificationcenter
      ];
  };
  
  security.polkit.enable = true;

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  #services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";  # Fixed: removed leading zero (should be 1:0:0, not 01:0:0)

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };

  };

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
     unzip arduino-cli discord gcc cloudflare-warp fastfetch
     pavucontrol vlc usbutils udiskie udisks samba sway wayland-scanner
     libGL libGLU powersupply lunar-client feh file-roller jq pulseaudio
     lua-language-server xfce.xfce4-screenshooter gh cargo gnumake
     gcc-arm-embedded python3Packages.pip swig file clang-tools
     net-tools iproute2 blueman networkmanager bluez bluez-tools dnsmasq
     sway-launcher-desktop jetbrains-mono dive podman-tui
     docker-compose freerdp dialog libnotify podman podman-compose
     xwayland ncdu gtk3 libnotify nss xorg.libXtst xdg-utils dpkg
     brasero networkmanagerapplet ripgrep inetutils sops ghostscript
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
    trusted-users = [ "lucas" ]; 
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

  services.logind.settings.Login.HandleLidSwitch = "ignore";

  systemd.services.nixos-upgrade = {
    description = lib.mkForce "NixOS Upgrade (Flake)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ 
        "/run/current-system/sw/bin/nixos-rebuild"
        "switch"
        "--flake"
        "/home/lucas/nix-conf#nixosSystemD/"
        "--impure"
      ];
    };
  };


  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };

  system.stateVersion = "25.05";
}
