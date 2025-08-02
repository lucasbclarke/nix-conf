{ config, lib, pkgs, ... }:

let
  # Detect if we're running in a VM
  isVM = config.virtualisation.vmVariant.enable or false;
  
  # Detect if we have UEFI by checking for EFI partition
  hasUEFI = lib.any (fs: fs.fsType == "vfat" && lib.hasPrefix "/boot" fs.mountPoint) (lib.attrValues config.fileSystems);
  
in {
  boot.loader = {
    # Use systemd-boot for UEFI systems (modern hardware)
    systemd-boot = {
      enable = lib.mkDefault (hasUEFI && !isVM);
      configurationLimit = 10;
    };
    
    # Use GRUB for legacy BIOS systems, VMs, or as fallback
    grub = {
      enable = lib.mkDefault (!hasUEFI || isVM);
      useOSProber = true;
      # Default devices - will be overridden by hardware-configuration.nix if it exists
      devices = lib.mkDefault [ "/dev/sda" "/dev/vda" ];
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
    
    # Enable plymouth for better boot experience
    plymouth = {
      enable = lib.mkDefault (!isVM);
      theme = "breeze";
    };
  };
} 