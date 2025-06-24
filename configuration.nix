{ config, pkgs, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes 
  '';
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

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
      #config = {
      #  modifier = "Mod4";
      #  terminal = "ghostty";
      #  startup = [{
      #    command = "brave"; 
      #  }];
      #};
  };


  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
    };

  #  windowManager.i3 = {
  #    enable = true;
  #    extraPackages = with pkgs; [
  #      dmenu #application launcher most people use
  #      i3status # gives you the default i3 status bar
  #      i3lock #default i3 screen locker
  #      i3blocks #if you are planning on using i3blocks over i3status
  #    ];
  #  };
  };


#  services.displayManager = {
#      enable = true;
#      defaultSession = "sway";
#  };

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
  hardware.pulseaudio.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" ];
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
    thunar.enable = true;
    thunderbird.enable = true;

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

  environment.systemPackages = with pkgs; [
     ghostty sqlite tldr fzf xdotool brave xfce.exo xfce.xfce4-settings
     unzip arduino-ide discord zls gcc cloudflare-warp neofetch
     simple-scan pavucontrol screenkey vokoscreen-ng vlc usbutils
     udiskie udisks samba sway wayland-scanner libGL libGLU
     (import ./git-repos.nix {inherit pkgs;})
     (import ./sud.nix {inherit pkgs;})
     (import ./ohmyzsh.nix {inherit pkgs;})
  ];

  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };
  services.udisks2.enable = true;

  services.cloudflare-warp.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11";

}
