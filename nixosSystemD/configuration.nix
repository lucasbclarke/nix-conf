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
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --time --cmd 'sway --unsupported-gpu'";
        user = "lucas";
      };
    };
  };
  systemd.services.greetd = {
    after = [ "systemd-user-sessions.service" ];
    before = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';

  environment.variables = {
    QT_STYLE_OVERRIDE = "gtk2";
    QT_QPA_PLATFORMTHEME = "gtk2";
  };

  nixpkgs.config.allowUnsupportedSystem = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes 
  '';

  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
    ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      nvidia-vaapi-driver
      intel-media-driver
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.intel-vaapi-driver
    ];
  };

  sops.defaultSopsFile = /home/lucas/nix-conf/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/lucas/.config/sops/age/keys.txt";
  sops.secrets."fileshare/username" = {};
  sops.secrets."fileshare/password" = {};

  boot.loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = lib.mkForce false;

      systemd-boot = {
          enable = lib.mkForce true;
          configurationLimit = 1;
          graceful = true;              
          extraInstallCommands = ''
            echo 'auto-entries 0' >> /boot/loader/loader.conf
            ${pkgs.gnused}/bin/sed -i 's/^title NixOS$/title   "Nixos  "/' /boot/loader/entries/nixos-*.conf
          '';
      };
  };

  system.nixos.label = "NixosSway";

  # Kernel parameters for quiet boot
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.udev.log-priority=3"
    "systemd.show_status=false"
    "vt.global_cursor_default=0"
  ];

  # Systemd console settings
  boot.consoleLogLevel = 3;

  time.hardwareClockInLocalTime = true;

  networking.hostName = "nixosSystemD";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 41641 ]; # Default Tailscale port
    trustedInterfaces = [ "tailscale0" ]; # Trust Tailscale traffic natively
  };

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

  security.polkit.enable = true;


  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
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
    # pkgs.cnijfilter2  # Temporarily disabled due to C23 compilation issues
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
    wireplumber.enable = true;
    wireplumber.extraConfig = {
        "51-bluez.conf" = {
          "monitor.bluez.properties" = {
              "bluez5.autoswitch-profile" = false;
          };
        };
    };
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.lucas = {
    isNormalUser = true;
    description = "lucas";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirtd" "tty" "dialout" ];
    shell = pkgs.zsh;
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        zlib
        gtk3
        libX11
        libXext
        libXcursor
        libXrandr
        libXi
        libXinerama
        libXScrnSaver
        libXtst
        fontconfig
        freetype
        libgcc
        pipewire
        libpulseaudio
      ];
    };
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
    thunderbird.enable = true;
    wshowkeys.enable = true;
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
     sqlite tealdeer fzf xdotool brave xfce4-exo xfce4-settings
     unzip arduino-cli arduino-ide discord gcc cloudflare-warp fastfetch dmenu
     pavucontrol vlc usbutils udiskie udisks samba sway wayland-scanner
     libGL libGLU powersupply lunar-client file-roller jq pulseaudio
     lua-language-server xfce4-screenshooter gh cargo gnumake
     gcc-arm-embedded python3Packages.pip swig file clang-tools
     net-tools iproute2 blueman networkmanager bluez bluez-tools dnsmasq
     sway-launcher-desktop dive podman-tui
     docker-compose freerdp dialog podman podman-compose
     xwayland ncdu gtk3 nss libxtst xdg-utils dpkg
     brasero networkmanagerapplet ripgrep inetutils sops ghostscript
     pciutils btop swaylock swayidle wl-clipboard grim slurp (wf-recorder.override { ffmpeg_8 = ffmpeg_8; })
     brightnessctl playerctl swaynotificationcenter quickshell mdhtml
     typescript-language-server jdt-language-server openjdk dotool opencode
     lsof kiwix libnotify gimp firefox python314 virtualbox wlr-randr 
     tailscale efibootmgr appimage-run lmstudio nil vial todoist blender
     uv delta python314Packages.pynvim zip nodejs_26 wakeonlan rustdesk-flutter
     dig kdePackages.gwenview wev qemu wshowkeys ghostty inputs.devenv.packages.${pkgs.system}.devenv
     yazi cifs-utils kdePackages.qtdeclarative
     (import ./git-repos.nix {inherit pkgs;})
     (import ./sud.nix {inherit pkgs;})
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
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ]; # Enables virtiofsd
  virtualisation.spiceUSBRedirection.enable = true;

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

  boot.blacklistedKernelModules = lib.mkForce [ "nouveau" ];
  boot.extraModprobeConfig = ''
    blacklist nouveau
  '';

  system.activationScripts.removeKvmBlacklist.text = ''
    rm -f /etc/modprobe.d/blacklist-kvm.conf
  '';

  services.openssh.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "sway";

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

  # Remove Steam's broken bundled libaudio.so that segfaults with PipeWire/PulseAudio.
  # Steam may restore this file on update; if so, remove it again or run:
  #   rm ~/.local/share/Steam/ubuntu12_32/libaudio.so
  systemd.tmpfiles.rules = [
    "r /home/lucas/.local/share/Steam/ubuntu12_32/libaudio.so"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      libgcc
      glib
      pipewire
      libpulseaudio
      libX11
      libXext
      libXfixes
      libXrandr
      libXrender
      libXtst
      libXcursor
      libXi
      libXinerama
      libXScrnSaver
      fontconfig
      freetype
      pango
      cairo
      gtk3
    ];
  };

  programs.gamemode.enable = true;
  
  services.tailscale.useRoutingFeatures = "client";
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-routes=false" ];
  };
  
  system.stateVersion = "26.05";
  services.udev = {
  
    packages = with pkgs; [
      qmk
      qmk-udev-rules # the only relevant
      qmk_hid
      via
      vial
    ]; # packages
  
  }; # udev

  systemd.services.numlock-tty = {
  description = "Enable NumLock on TTYs";
  wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "numlock-tty" ''
        for tty in /dev/tty{1..6}; do
          ${pkgs.kbd}/bin/setleds -D +num < "$tty"
        done
      '';
    };
  };

  services.syncthing = {
    enable = true;
    user = "lucas";
    dataDir = "/home/lucas/.local/state/syncthing/";
    configDir = "/home/lucas/.config/syncthing";
  };
  
    
  sops.templates."smb-dwelling-creds" = {
    content = ''
      username=${config.sops.placeholder."fileshare/username"}
      password=${config.sops.placeholder."fileshare/password"}
    '';
    path = "/etc/nixos/smb-secrets";
    owner = "root";
    group = "root";
    mode = "0600";
  };

  boot.supportedFilesystems = [ "cifs" ];

  fileSystems."/mnt/fileshare" = {
    device = "//dwelling.tplinkdns.com/g";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s";
    in [
      "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100,vers=1.0"
    ];

  };

}
