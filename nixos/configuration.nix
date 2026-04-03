{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  boot.loader.systemd-boot.configurationLimit = 10;
  system.nixos.label = "NixosI3";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.firewall.enable = false;

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  services.displayManager.defaultSession = "none+i3";

  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu i3status i3lock i3blocks rofi maim xclip
      ];
    };
    videoDrivers = [ "nvidia" ];
  };
  services.xserver.xkb.layout = "au";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.libinput.enable = true;

   users.users.lucas = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" "kvm" "libvirtd" "tty" ]; 
     shell = pkgs.zsh;
   };

  environment.systemPackages = with pkgs; [
    sqlite tealdeer fzf xdotool brave xfce4-exo xfce4-settings
    unzip arduino-cli discord gcc cloudflare-warp fastfetch dmenu
    pavucontrol vlc usbutils udiskie udisks samba libGL libGLU
    powersupply lunar-client file-roller jq pulseaudio
    lua-language-server xfce4-screenshooter gh cargo gnumake
    gcc-arm-embedded python3Packages.pip swig file clang-tools
    net-tools iproute2 blueman networkmanager bluez bluez-tools 
    dnsmasq dive podman-tui docker-compose freerdp
    dialog libnotify podman podman-compose ncdu gtk3 nss libxtst
    xdg-utils dpkg brasero networkmanagerapplet ripgrep inetutils
    brightnessctl playerctl quickshell mdhtml maim xclip typescript-language-server
    jdt-language-server openjdk dotool opencode lsof gimp firefox
    python314 teams-for-linux sops qutebrowser ciscoPacketTracer9
    virtualbox tailscale
    (import ./git-repos.nix {inherit pkgs;})
    (import ./sud.nix {inherit pkgs;})
    inputs.nixd.packages."${pkgs.stdenv.hostPlatform.system}".nixd
    inputs.nil.packages."${pkgs.stdenv.hostPlatform.system}".nil
  ];

  services.openssh.enable = true;


  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  security.polkit.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime ={
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

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
    pkgs.gutenprint
    pkgs.cups-bjnp
  ]; 
  
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  programs = {
    zsh.enable = true;
    git.enable = true;
    thunar = {
      enable = true;
      plugins = [
        pkgs.thunar-archive-plugin
        pkgs.thunar-volman
        pkgs.thunar-vcs-plugin
      ];
    };
    xfconf.enable = true;
  };
  
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.8"
    "cisco-packet-tracer-8.2.2"
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
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ]; 
  virtualisation.spiceUSBRedirection.enable = true;

  fonts = {
    fontconfig.enable = true;
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.logind.settings.Login.HandleLidSwitch = "ignore";

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "i3";

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

  programs.ssh.enableAskPassword = false;

  programs.gamemode.enable = true;

  services.tailscale.enable = true;
  
  system.stateVersion = "25.11"; 

}

