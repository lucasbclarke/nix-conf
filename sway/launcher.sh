#!/run/current-system/sw/bin/zsh

# Simple list of applications including our custom scripts
apps="thunar
blueman
virt-manager
pavucontrol
printer-settings
nm-connection-editor
file-roller
vlc
lunarclient
steam
kiwix
gimp
firefox
excel
word
powerpoint
windows
outlook
explorer
notepad
onedrive"

# Show menu and get selection
selection=$(echo "$apps" | wofi --show dmenu --prompt "Launch:")

# Execute based on selection
case "$selection" in
    "thunar")
        exec thunar
        ;;
    "blueman")
        exec blueman-manager
        ;;
    "virt-manager")
        exec virt-manager
        ;;
    "pavucontrol")
        exec pavucontrol
        ;;

    "printer-settings")
        exec system-config-printer
        ;;
    "nm-connection-editor")
        exec nm-connection-editor
        ;;
    "file-roller")
        exec file-roller
        ;;
    "vlc")
        exec vlc
        ;;
    "lunarclient")
        exec lunarclient
        ;;
    "steam")
        exec steam
        ;;
    "winboat")
        exec winboat
        ;;
    "kiwix")
        exec kiwix-desktop
        ;;
    "gimp")
        exec gimp
        ;;
    "firefox")
        exec firefox
        ;;
    "excel")
        exec /usr/bin/excel
        ;;
    "word")
        exec /usr/bin/word
        ;;
    "powerpoint")
        exec /usr/bin/powerpoint
        ;;
    "windows")
        exec /usr/bin/windows
        ;;
    "outlook")
        exec /usr/bin/outlook
        ;;
    "explorer")
        exec /usr/bin/explorer
        ;;
    "notepad")
        exec /usr/bin/notepad
        ;;
    "onedrive")
        exec /usr/bin/onedrive
        ;;
esac
