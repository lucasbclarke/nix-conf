{ config, lib, pkgs, ... }:

let
  # Detect if we're running in a VM
  isVM = config.virtualisation.vmVariant.enable or false;
  
  # Detect if we have UEFI by checking for EFI partition
  hasUEFI = lib.any (fs: fs.fsType == "vfat" && lib.hasPrefix "/boot" fs.mountPoint) config.fileSystems;
  
  # Detect if we're on a system with secure boot
  hasSecureBoot = lib.any (fs: fs.fsType == "vfat" && lib.hasPrefix "/boot" fs.mountPoint) config.fileSystems;
  
  # Get the boot device from hardware-configuration.nix
  bootDevice = lib.head (lib.attrNames (lib.filterAttrs (name: value: value.device == "/dev/disk/by-label/nixos") config.fileSystems));
  
in {
  boot.loader = {
    # Use systemd-boot for UEFI systems (modern hardware)
    systemd-boot = {
      enable = lib.mkDefault (hasUEFI && !isVM);
      configurationLimit = 10;
      # Enable secure boot support if available
      secureBoot = lib.mkDefault hasSecureBoot;
    };
    
    # Use GRUB for legacy BIOS systems, VMs, or as fallback
    grub = {
      enable = lib.mkDefault (!hasUEFI || isVM);
      useOSProber = true;
      # Let hardware-configuration.nix set the devices
      devices = lib.mkDefault [];
      # Enable EFI support in GRUB if we have UEFI
      efiSupport = lib.mkDefault hasUEFI;
      # Enable secure boot support if available
      enableCryptodisk = true;
    };
    
    # EFI configuration
    efi = {
      canTouchEfiVariables = lib.mkDefault (hasUEFI && !isVM);
      # Set the EFI system partition
      efiSysMountPoint = lib.mkDefault "/boot/efi";
    };
  };
  
  # Additional boot options for better compatibility
  boot = {
    # Enable kernel modules for better hardware support
    kernelModules = [ "kvm-intel" "kvm-amd" ] ++ lib.optionals isVM [ "virtio" "virtio_pci" "virtio_net" ];
    
    # Kernel parameters for better compatibility
    kernelParams = lib.mkDefault [
      "quiet"
      "splash"
    ] ++ lib.optionals isVM [
      "console=ttyS0"
      "nokaslr"
    ];
    
    # Enable plymouth for better boot experience
    plymouth = {
      enable = lib.mkDefault (!isVM);
      theme = "breeze";
    };
  };
} 