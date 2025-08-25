{ pkgs }:

pkgs.writeShellScriptBin "winapps-test"
''
#!/usr/bin/env bash

echo "🧪 WinApps Test Script"
echo "======================"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to test command availability
test_command() {
    local cmd="$1"
    local description="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $description ($cmd)"
        return 0
    else
        echo -e "${RED}✗${NC} $description ($cmd) - NOT FOUND"
        return 1
    fi
}

# Function to test file existence
test_file() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description - NOT FOUND"
        return 1
    fi
}

# Function to test directory existence
test_directory() {
    local dir="$1"
    local description="$2"
    
    if [[ -d "$dir" ]]; then
        echo -e "${GREEN}✓${NC} $description"
        return 0
    else
        echo -e "${RED}✗${NC} $description - NOT FOUND"
        return 1
    fi
}

echo ""
echo "Testing WinApps Installation..."
echo "=============================="

# Test 1: Command availability
echo ""
echo "1. Command Availability:"
test_command "winapps" "WinApps main command"
test_command "winapps-launcher" "WinApps launcher"
test_command "winapps-setup" "WinApps setup command"
test_command "xfreerdp" "FreeRDP client"
test_command "winapps-launch" "WinApps convenience launcher"
test_command "winapps-desktop" "WinApps desktop integration"

# Test 2: Configuration files
echo ""
echo "2. Configuration Files:"
test_file "$HOME/.config/winapps/winapps.conf" "WinApps configuration file"
test_directory "$HOME/.config/winapps" "WinApps config directory"

# Test 3: Application directories
echo ""
echo "3. Application Directories:"
test_directory "$HOME/.local/share/winapps" "WinApps data directory"
test_directory "$HOME/.local/share/applications" "Applications directory"

# Test 4: Check for specific applications
echo ""
echo "4. Available Applications:"
if ls "$HOME/.local/share/applications"/*.desktop 2>/dev/null | grep -q "word-o365"; then
    echo -e "${GREEN}✓${NC} Microsoft Word (word-o365)"
else
    echo -e "${RED}✗${NC} Microsoft Word - NOT FOUND"
fi

if ls "$HOME/.local/share/applications"/*.desktop 2>/dev/null | grep -q "excel-o365"; then
    echo -e "${GREEN}✓${NC} Microsoft Excel (excel-o365)"
else
    echo -e "${RED}✗${NC} Microsoft Excel - NOT FOUND"
fi

if ls "$HOME/.local/share/applications"/*.desktop 2>/dev/null | grep -q "powerpoint-o365"; then
    echo -e "${GREEN}✓${NC} Microsoft PowerPoint (powerpoint-o365)"
else
    echo -e "${RED}✗${NC} Microsoft PowerPoint - NOT FOUND"
fi

if ls "$HOME/.local/share/applications"/*.desktop 2>/dev/null | grep -q "windows"; then
    echo -e "${GREEN}✓${NC} Windows Desktop (windows)"
else
    echo -e "${RED}✗${NC} Windows Desktop - NOT FOUND"
fi

# Test 5: Windows container status
echo ""
echo "5. Windows Container Status:"
if podman ps | grep -q "WinApps"; then
    echo -e "${GREEN}✓${NC} Windows container is running"
    echo "   Container details:"
    podman ps | grep "WinApps" | while read -r line; do
        echo "   $line"
    done
else
    echo -e "${YELLOW}⚠${NC} Windows container is not running"
    echo "   You may need to start it with: cd ~/winapps && podman compose up -d"
fi

# Test 6: Test basic WinApps functionality
echo ""
echo "6. Basic Functionality Test:"
echo "   Testing WinApps help command..."
if timeout 5 winapps --help &>/dev/null; then
    echo -e "${GREEN}✓${NC} WinApps responds to commands"
else
    echo -e "${YELLOW}⚠${NC} WinApps command test timed out (this may be normal)"
fi

# Summary
echo ""
echo "================================"
echo "Test Summary:"
echo "================================"

# Count successes and failures
success_count=0
total_count=0

# Count command tests
for cmd in "winapps" "winapps-launcher" "winapps-setup" "xfreerdp" "winapps-launch" "winapps-desktop"; do
    if command -v "$cmd" &> /dev/null; then
        ((success_count++))
    fi
    ((total_count++))
done

# Count file tests
for file in "$HOME/.config/winapps/winapps.conf"; do
    if [[ -f "$file" ]]; then
        ((success_count++))
    fi
    ((total_count++))
done

# Count directory tests
for dir in "$HOME/.config/winapps" "$HOME/.local/share/winapps" "$HOME/.local/share/applications"; do
    if [[ -d "$dir" ]]; then
        ((success_count++))
    fi
    ((total_count++))
done

# Count application tests
for app in "word-o365" "excel-o365" "powerpoint-o365" "windows"; do
    if ls "$HOME/.local/share/applications"/*.desktop 2>/dev/null | grep -q "$app"; then
        ((success_count++))
    fi
    ((total_count++))
done

# Container test
if podman ps | grep -q "WinApps"; then
    ((success_count++))
fi
((total_count++))

echo ""
echo "Results: $success_count/$total_count tests passed"

if [[ $success_count -eq $total_count ]]; then
    echo -e "${GREEN}🎉 All tests passed! WinApps is fully configured.${NC}"
elif [[ $success_count -gt $((total_count / 2)) ]]; then
    echo -e "${YELLOW}⚠ Most tests passed. WinApps is mostly configured.${NC}"
else
    echo -e "${RED}❌ Many tests failed. WinApps may need reconfiguration.${NC}"
fi

echo ""
echo "Next steps:"
echo "  • Edit ~/.config/winapps/winapps.conf with your Windows credentials"
echo "  • Use 'winapps-launch word' to test Microsoft Word"
echo "  • Use 'winapps-launch windows' to access Windows desktop"
echo "  • Run 'winapps-setup' if you need to reconfigure"
'' 