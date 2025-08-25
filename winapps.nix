{ pkgs }:

pkgs.writeShellScriptBin "winapps-setup"
''
#!/usr/bin/env bash

set -e

echo "🚀 WinApps Installation and Configuration Script"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check if we're on NixOS
if [[ ! -f /etc/os-release ]] || ! grep -q "nixos" /etc/os-release; then
    print_error "This script is designed for NixOS"
    exit 1
fi

print_status "Starting WinApps installation and configuration..."

# Step 1: Install WinApps packages via nix profile
print_status "Installing WinApps packages..."
if ! command -v winapps &> /dev/null; then
    print_status "Installing WinApps from flake..."
    nix profile install github:winapps-org/winapps#winapps
    print_success "WinApps package installed"
else
    print_success "WinApps package already installed"
fi

if ! command -v winapps-launcher &> /dev/null; then
    print_status "Installing WinApps Launcher from flake..."
    nix profile install github:winapps-org/winapps#winapps-launcher
    print_success "WinApps Launcher package installed"
else
    print_success "WinApps Launcher package already installed"
fi

# Step 2: Install FreeRDP if not present
print_status "Checking FreeRDP installation..."
if ! command -v xfreerdp &> /dev/null; then
    print_status "Installing FreeRDP..."
    nix profile install nixpkgs#freerdp
    print_success "FreeRDP installed"
else
    print_success "FreeRDP already installed"
fi

# Step 3: Create configuration directory
print_status "Creating WinApps configuration directory..."
mkdir -p ~/.config/winapps
print_success "Configuration directory created"

# Step 4: Create WinApps configuration file
print_status "Creating WinApps configuration file..."
cat > ~/.config/winapps/winapps.conf << 'EOF'
##################################
#   WINAPPS CONFIGURATION FILE   #
##################################

# INSTRUCTIONS
# - Leading and trailing whitespace are ignored.
# - Empty lines are ignored.
# - Lines starting with '#' are ignored.
# - All characters following a '#' are ignored.

# [WINDOWS USERNAME]
RDP_USER="lucas"

# [WINDOWS PASSWORD]
# NOTES:
# - If using FreeRDP v3.9.0 or greater, you *have* to set a password
RDP_PASS="lucas"

# [WINDOWS DOMAIN]
# DEFAULT VALUE: '' (BLANK)
RDP_DOMAIN=""

# [WINDOWS IPV4 ADDRESS]
# NOTES:
# - If using 'libvirt', 'RDP_IP' will be determined by WinApps at runtime if left unspecified.
# DEFAULT VALUE:
# - 'docker': '127.0.0.1'
# - 'podman': '127.0.0.1'
# - 'libvirt': '' (BLANK)
RDP_IP="127.0.0.1"

# [VM NAME]
# NOTES:
# - Only applicable when using 'libvirt'
# - The libvirt VM name must match so that WinApps can determine VM IP, start the VM, etc.
# DEFAULT VALUE: 'RDPWindows'
VM_NAME="RDPWindows"

# [WINAPPS BACKEND]
# DEFAULT VALUE: 'docker'
# VALID VALUES:
# - 'docker'
# - 'podman'
# - 'libvirt'
# - 'manual'
WAFLAVOR="podman"

# [DISPLAY SCALING FACTOR]
# NOTES:
# - If an unsupported value is specified, a warning will be displayed.
# - If an unsupported value is specified, WinApps will use the closest supported value.
# DEFAULT VALUE: '100'
# VALID VALUES:
# - '100'
# - '140'
# - '180'
RDP_SCALE="100"

# [MOUNTING REMOVABLE PATHS FOR FILES]
# NOTES:
# - By default, `udisks` (which you most likely have installed) uses /run/media for mounting removable devices.
#   This improves compatibility with most desktop environments (DEs).
# ATTENTION: The Filesystem Hierarchy Standard (FHS) recommends /media instead. Verify your system's configuration.
# - To manually mount devices, you may optionally use /mnt.
# REFERENCE: https://wiki.archlinux.org/title/Udisks#Mount_to_/media
REMOVABLE_MEDIA="/run/media"

# [ADDITIONAL FREERDP FLAGS & ARGUMENTS]
# NOTES:
# - You can try adding /network:lan to these flags in order to increase performance, however, some users have faced issues with this.
# DEFAULT VALUE: '/cert:tofu /sound /microphone +home-drive'
# VALID VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"

# [DEBUG WINAPPS]
# NOTES:
# - Creates and appends to ~/.local/share/winapps/winapps.log when running WinApps.
# DEFAULT VALUE: 'true'
# VALID VALUES:
# - 'true'
# - 'false'
DEBUG="true"

# [AUTOMATICALLY PAUSE WINDOWS]
# NOTES:
# - This is currently INCOMPATIBLE with 'docker' and 'manual'.
# - See https://github.com/dockur/windows/issues/674
# DEFAULT VALUE: 'off'
# VALID VALUES:
# - 'on'
# - 'off'
AUTOPAUSE="off"
EOF

print_success "Configuration file created"

# Step 5: Set proper permissions on configuration file
print_status "Setting configuration file permissions..."
chmod 600 ~/.config/winapps/winapps.conf
print_success "Configuration file permissions set"

# Step 6: Check if Windows container is running
print_status "Checking Windows container status..."
if podman ps | grep -q "WinApps"; then
    print_success "Windows container is running"
else
    print_warning "Windows container is not running"
    print_status "Starting Windows container..."
    cd ~/winapps
    podman compose --file compose.yaml up -d
    print_success "Windows container started"
fi

# Step 7: Wait for container to be ready
print_status "Waiting for Windows container to be ready..."
sleep 10

# Step 8: Run WinApps setup
print_status "Running WinApps setup..."
if command -v winapps-setup &> /dev/null; then
    # Fix permissions first
    mkdir -p ~/.local/share/winapps
    chmod -R 755 ~/.local/share/winapps/ 2>/dev/null || true
    
    # Run the setup
    winapps-setup --user --setupAllOfficiallySupportedApps
    print_success "WinApps setup completed"
else
    print_error "winapps-setup command not found"
    exit 1
fi

# Step 9: Create convenience scripts
print_status "Creating convenience scripts..."

# Create winapps-launch script
cat > ~/.local/bin/winapps-launch << 'EOF'
#!/usr/bin/env bash
# WinApps Launcher - Quick access to Windows applications

case "$1" in
    "word"|"Word")
        winapps word-o365
        ;;
    "excel"|"Excel")
        winapps excel-o365
        ;;
    "powerpoint"|"PowerPoint"|"ppt")
        winapps powerpoint-o365
        ;;
    "outlook"|"Outlook")
        winapps outlook-o365
        ;;
    "onenote"|"OneNote")
        winapps onenote-o365
        ;;
    "access"|"Access")
        winapps access
        ;;
    "publisher"|"Publisher")
        winapps publisher-o365
        ;;
    "explorer"|"Explorer")
        winapps explorer
        ;;
    "cmd"|"Command"|"CommandPrompt")
        winapps cmd
        ;;
    "powershell"|"PowerShell")
        winapps powershell
        ;;
    "ie"|"InternetExplorer")
        winapps iexplorer
        ;;
    "windows"|"Windows"|"desktop")
        winapps windows
        ;;
    "help"|"-h"|"--help")
        echo "WinApps Launcher - Available applications:"
        echo "  word, excel, powerpoint, outlook, onenote, access, publisher"
        echo "  explorer, cmd, powershell, ie, windows"
        echo ""
        echo "Usage: winapps-launch <application>"
        echo "Example: winapps-launch word"
        ;;
    *)
        echo "Unknown application: $1"
        echo "Use 'winapps-launch help' for available options"
        exit 1
        ;;
esac
EOF

chmod +x ~/.local/bin/winapps-launch
print_success "Convenience script created: winapps-launch"

# Step 10: Create desktop integration script
print_status "Creating desktop integration script..."
cat > ~/.local/bin/winapps-desktop << 'EOF'
#!/usr/bin/env bash
# WinApps Desktop Integration

echo "🖥️  WinApps Desktop Integration"
echo "================================"

# Check if applications directory exists
if [[ ! -d ~/.local/share/applications ]]; then
    echo "Creating applications directory..."
    mkdir -p ~/.local/share/applications
fi

# List available WinApps applications
echo ""
echo "Available WinApps applications:"
echo "==============================="
ls ~/.local/share/applications/*.desktop 2>/dev/null | grep -v "userapp\|mimeapps" | while read -r app; do
    app_name=$(basename "$app" .desktop)
    echo "  ✅ $app_name"
done

echo ""
echo "To launch applications:"
echo "  winapps-launch word      # Launch Microsoft Word"
echo "  winapps-launch excel     # Launch Microsoft Excel"
echo "  winapps-launch windows   # Launch Windows Desktop"
echo ""
echo "Or use the winapps command directly:"
echo "  winapps word-o365"
echo "  winapps excel-o365"
echo "  winapps windows"
EOF

chmod +x ~/.local/bin/winapps-desktop
print_success "Desktop integration script created: winapps-desktop"

# Step 11: Final verification
print_status "Performing final verification..."

# Check if main commands work
if command -v winapps &> /dev/null; then
    print_success "✓ winapps command available"
else
    print_error "✗ winapps command not found"
fi

if command -v winapps-launcher &> /dev/null; then
    print_success "✓ winapps-launcher command available"
else
    print_error "✗ winapps-launcher command not found"
fi

if command -v xfreerdp &> /dev/null; then
    print_success "✓ FreeRDP available"
else
    print_error "✗ FreeRDP not found"
fi

# Check configuration
if [[ -f ~/.config/winapps/winapps.conf ]]; then
    print_success "✓ Configuration file exists"
else
    print_error "✗ Configuration file missing"
fi

# Check if applications were created
if ls ~/.local/share/applications/*.desktop 2>/dev/null | grep -q "word-o365"; then
    print_success "✓ Office applications configured"
else
    print_warning "⚠ Office applications may not be fully configured"
fi

echo ""
echo "🎉 WinApps Installation Complete!"
echo "================================"
echo ""
echo "What's available:"
echo "  • Microsoft Office 365 applications"
echo "  • Windows system tools"
echo "  • Full Windows desktop access"
echo ""
echo "Quick start:"
echo "  winapps-launch word      # Launch Microsoft Word"
echo "  winapps-launch excel     # Launch Microsoft Excel"
echo "  winapps-launch windows   # Access full Windows desktop"
echo "  winapps-desktop          # Show available applications"
echo ""
echo "Configuration:"
echo "  • Config file: ~/.config/winapps/winapps.conf"
echo "  • Logs: ~/.local/share/winapps/winapps.log"
echo "  • Applications: ~/.local/share/applications/"
echo ""
echo "Note: You may need to edit ~/.config/winapps/winapps.conf"
echo "      to set your actual Windows username and password."
echo ""
print_success "Installation completed successfully!"
'' 