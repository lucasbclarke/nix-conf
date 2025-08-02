# Universal NixOS Configuration

This NixOS configuration is designed to work automatically on any machine, whether it's a physical computer, virtual machine, laptop, or desktop. It automatically detects the appropriate bootloader and hardware configuration.

## How It Works

### Automatic Bootloader Detection

The configuration automatically detects and configures the appropriate bootloader:

- **UEFI Systems**: Uses `systemd-boot` for modern UEFI-based systems
- **Legacy BIOS Systems**: Uses `GRUB` for older BIOS-based systems
- **Virtual Machines**: Automatically uses GRUB with appropriate VM-specific settings

### Hardware Detection

The system automatically detects:
- Whether it's running in a VM
- CPU architecture (Intel/AMD)
- Whether it's a laptop or desktop
- Available hardware features (UEFI, secure boot, etc.)

### Key Files

- `configuration.nix` - Main configuration file
- `bootloader.nix` - Automatic bootloader detection and configuration
- `hardware-detection.nix` - Hardware-specific configurations
- `hardware-configuration.nix` - Machine-specific hardware config (auto-generated)

## Usage

### On a New Machine

1. Copy all files to `/etc/nixos/`
2. Generate hardware configuration:
   ```bash
   nixos-generate-config
   ```
3. Build and switch:
   ```bash
   nixos-rebuild switch
   ```

### What Gets Automatically Configured

#### Bootloader
- **UEFI systems**: systemd-boot with secure boot support
- **Legacy systems**: GRUB with OS prober
- **VMs**: GRUB with virtio support

#### Hardware Support
- CPU microcode updates
- Graphics drivers and OpenGL
- Sound (PipeWire by default)
- Bluetooth (on physical hardware)
- Power management (on laptops)
- Virtualization support (KVM, libvirtd)

#### Kernel Modules
- Common modules for all systems
- VM-specific modules (virtio) when in VMs
- Laptop-specific modules when on laptops

## Benefits

1. **Universal Compatibility**: Works on any x86_64 machine
2. **No Manual Configuration**: Automatically detects hardware
3. **VM-Friendly**: Special optimizations for virtual machines
4. **Secure**: Supports secure boot and TPM when available
5. **Performance**: Optimized settings for different hardware types

## Troubleshooting

### If Bootloader Doesn't Work

The system will automatically fall back to GRUB if systemd-boot fails. If you need to manually specify a bootloader:

1. Edit `bootloader.nix`
2. Override the detection logic
3. Rebuild the system

### VM Issues

If you encounter issues in VMs:
- The system automatically detects VM environments
- Uses appropriate kernel parameters and modules
- Disables hardware-specific features that don't work in VMs

### Hardware-Specific Issues

If certain hardware doesn't work:
- Check `hardware-detection.nix` for relevant settings
- Add machine-specific configurations to `hardware-configuration.nix`
- The system will merge configurations automatically

## Customization

To add machine-specific configurations:

1. **Hardware-specific**: Add to `hardware-configuration.nix`
2. **Boot-specific**: Modify `bootloader.nix`
3. **General settings**: Add to `configuration.nix`

The system uses `lib.mkDefault` and `lib.mkIf` to ensure your customizations take precedence while maintaining compatibility. 