{ config, lib, pkgs, ... }:

let
  # Detect system type
  isVM = config.virtualisation.vmVariant.enable or false;
  isLaptop = lib.any (fs: fs.fsType == "vfat" && lib.hasPrefix "/boot" fs.mountPoint) config.fileSystems;
  
  # Detect CPU architecture
  isIntel = lib.hasPrefix "x86_64" config.nixpkgs.hostPlatform.system;
  isAMD = lib.hasPrefix "x86_64" config.nixpkgs.hostPlatform.system;
  
in {
  # Hardware-specific configurations
  hardware = {
    # Enable common hardware support
    enableRedistributableFirmware = true;
    
    # CPU microcode updates
    cpu.intel.updateMicrocode = lib.mkDefault isIntel;
    cpu.amd.updateMicrocode = lib.mkDefault isAMD;
    
    # Graphics support
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    
    # Sound support
    pulseaudio = {
      enable = lib.mkDefault (!config.services.pipewire.enable);
      support32Bit = true;
    };
    
    # Bluetooth support (only on physical hardware)
    bluetooth = {
      enable = lib.mkDefault (!isVM);
      powerOnBoot = lib.mkDefault (!isVM);
    };
    
    # Sensor support for laptops
    sensor.iio.enable = lib.mkDefault isLaptop;
    
    # TPM support (only if available)
    # tpm2.enable = lib.mkDefault (!isVM);
  };
  
  # Virtualization support
  virtualisation = {
    # Enable libvirtd for VM management
    libvirtd = {
      enable = lib.mkDefault (!isVM);
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };
  
  # Power management for laptops
  powerManagement = {
    enable = lib.mkDefault isLaptop;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  
  # Services that should only run on physical hardware
  # services = {
  #   # Hardware monitoring
  #   lm_sensors = {
  #     enable = lib.mkDefault (!isVM);
  #   };
  #   
  #   # Automatic suspend for laptops
  #   logind = {
  #     lidSwitch = lib.mkIf isLaptop "suspend";
  #     lidSwitchExternalPower = lib.mkIf isLaptop "suspend";
  #   };
  #   
  #   # Thermal management
  #   thermald.enable = lib.mkDefault isLaptop;
  # };
  
  # Kernel modules for better hardware support
  boot = {
    kernelModules = [
      # Common modules
      "fuse"
      "kvm-intel"
      "kvm-amd"
      "vhost_net"
      "vhost_vsock"
    ] ++ lib.optionals isVM [
      # VM-specific modules
      "virtio"
      "virtio_pci"
      "virtio_net"
      "virtio_blk"
      "virtio_scsi"
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
    ] ++ lib.optionals isLaptop [
      # Laptop-specific modules
      "thinkpad_acpi"
      "tp_smapi"
      "acpi_call"
    ];
    
    # Kernel parameters for better compatibility
    kernelParams = [
      # Common parameters
      "quiet"
      "splash"
      "i915.enable_guc=2"
      "i915.enable_fbc=1"
    ] ++ lib.optionals isVM [
      # VM-specific parameters
      "console=ttyS0"
      "nokaslr"
      "noapic"
      "nopci"
    ] ++ lib.optionals isLaptop [
      # Laptop-specific parameters
      "acpi_osi=Linux"
      "acpi_backlight=vendor"
    ];
  };
} 