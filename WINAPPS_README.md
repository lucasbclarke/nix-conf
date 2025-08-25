# WinApps Configuration for NixOS

This directory contains NixOS configuration scripts for WinApps, a system that allows you to run Windows applications seamlessly on Linux.

## 📁 Files

- **`winapps.nix`** - Main installation and configuration script
- **`winapps-test.nix`** - Test script to verify installation
- **`WINAPPS_README.md`** - This documentation file

## 🚀 Quick Start

After rebuilding your NixOS configuration, you'll have access to these commands:

### 1. Install and Configure WinApps
```bash
winapps-setup
```

This script will:
- Install WinApps packages via nix profile
- Install FreeRDP dependency
- Create configuration files
- Start Windows container (if available)
- Run WinApps setup
- Create convenience scripts

### 2. Test Your Installation
```bash
winapps-test
```

This will verify that everything is working correctly.

### 3. Use WinApps
```bash
# Launch Office applications
winapps-launch word      # Microsoft Word
winapps-launch excel     # Microsoft Excel
winapps-launch powerpoint # Microsoft PowerPoint
winapps-launch outlook   # Microsoft Outlook

# Launch Windows tools
winapps-launch explorer  # Windows Explorer
winapps-launch cmd       # Command Prompt
winapps-launch windows   # Full Windows Desktop

# Show available applications
winapps-desktop
```

## 🔧 Manual Commands

If you prefer to use the commands directly:

```bash
# Office applications
winapps word-o365
winapps excel-o365
winapps powerpoint-o365
winapps outlook-o365
winapps onenote-o365
winapps access
winapps publisher-o365

# Windows tools
winapps explorer
winapps cmd
winapps powershell
winapps iexplorer
winapps windows
```

## ⚙️ Configuration

The main configuration file is located at `~/.config/winapps/winapps.conf`.

**Important:** You need to edit this file with your actual Windows credentials:

```bash
nano ~/.config/winapps/winapps.conf
```

Update these lines:
```bash
RDP_USER="your-windows-username"
RDP_PASS="your-windows-password"
```

## 🐳 Windows Container

This configuration assumes you're using Podman with a Windows container. The script will:

1. Check if the container is running
2. Start it if needed using `podman compose up -d`
3. Wait for it to be ready before proceeding

Make sure your Windows container is properly configured in `~/winapps/compose.yaml`.

## 📱 Available Applications

### Officially Supported (13 applications):
- **Microsoft Office 365**: Word, Excel, PowerPoint, Outlook, OneNote, Access, Publisher
- **Windows Tools**: Explorer, Command Prompt, PowerShell, Internet Explorer
- **Windows Desktop**: Full Windows RDP session

### Detected Applications (64 total):
The system detects many more Windows applications, but only the officially supported ones are automatically configured. You can access all applications through the Windows Desktop.

## 🛠️ Troubleshooting

### Common Issues:

1. **"Application not found" error**
   - Run `winapps-setup` to reconfigure
   - Check if Windows container is running: `podman ps`

2. **Permission denied errors**
   - Run `chmod -R 755 ~/.local/share/winapps/`
   - Check file ownership

3. **RDP connection failures**
   - Verify Windows credentials in `~/.config/winapps/winapps.conf`
   - Check if Windows container is accessible
   - Ensure FreeRDP is installed

4. **Applications not appearing in desktop**
   - Run `winapps-setup --user --setupAllOfficiallySupportedApps`
   - Check `~/.local/share/applications/` directory

### Logs:
- WinApps logs: `~/.local/share/winapps/winapps.log`
- FreeRDP logs: `~/.local/share/winapps/FreeRDP_*.log`

## 🔄 Rebuilding NixOS

After making changes to these files, rebuild your NixOS configuration:

```bash
sudo nixos-rebuild switch
```

## 📚 Additional Resources

- [WinApps GitHub Repository](https://github.com/winapps-org/winapps)
- [WinApps Documentation](https://github.com/winapps-org/winapps#readme)
- [FreeRDP Documentation](https://github.com/FreeRDP/FreeRDP)

## 🎯 What This Configuration Achieves

This setup provides:

1. **Seamless Windows Application Integration** - Run Windows apps alongside Linux apps
2. **Microsoft Office 365 Support** - Full Office suite functionality
3. **Windows System Tools** - Access to Windows utilities
4. **Desktop Integration** - Applications appear in your Linux desktop environment
5. **Automated Setup** - One-command installation and configuration
6. **Testing Tools** - Verify everything is working correctly

## 🚨 Security Notes

- The configuration file contains your Windows password - ensure it has restricted permissions (600)
- WinApps runs Windows applications in a containerized environment
- Your Linux home directory is accessible from Windows via RDP

## 🔍 Verification Commands

```bash
# Check if commands are available
which winapps
which winapps-launcher
which xfreerdp

# Check configuration
ls -la ~/.config/winapps/
cat ~/.config/winapps/winapps.conf

# Check applications
ls -la ~/.local/share/applications/ | grep -E "(word|excel|powerpoint|windows)"

# Check container status
podman ps | grep WinApps

# Run comprehensive test
winapps-test
```

## 🎉 Success Indicators

You'll know everything is working when:

- ✅ `winapps-setup` completes without errors
- ✅ `winapps-test` shows all tests passing
- ✅ Office applications launch successfully
- ✅ Windows desktop is accessible
- ✅ Applications appear in your desktop environment

---

**Note:** This configuration is designed for NixOS and assumes you have Podman configured for Windows containers. Adjust the configuration as needed for your specific setup. 