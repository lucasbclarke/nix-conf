#!/run/current-system/sw/bin/zsh

# Simple list of applications including our custom scripts
apps="excel
word
powerpoint
windows
outlook
explorer
notepad
onedrive
visual-studio
vivi
thunar
blueman
virtualbox
pavucontrol
printer-settings
nm-connection-editor
sway-settings
file-roller
vlc
lunarclient"

# Show menu and get selection
selection=$(echo "$apps" | wofi --show dmenu --prompt "Launch:")

# Execute based on selection
case "$selection" in
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
    "visual-studio")
        exec /usr/bin/visual-studio
        ;;
    "vivi")
        exec /usr/bin/vivi
        ;;
    "thunar")
        exec thunar
        ;;
    "blueman")
        exec blueman-manager
        ;;
    "virtualbox")
        exec VirtualBox
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
    "sway-settings")
        exec swaysettings
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
esac
