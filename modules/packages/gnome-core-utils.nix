{ pkgs, ... }: with pkgs; [
    ## GNOME Core Apps
    # baobab      # disk usage analyzer
    cheese       # photo booth
    # eog         # image viewer
    epiphany     # web browser
    # gedit       # text editor
    # simple-scan # document scanner
    totem        # video player
    # yelp        # help viewer
    evince       # document viewer
    # file-roller # archive manager
    geary        # email client
    seahorse     # password manager

    ## GNOME Utilities
    # gnome-calculator
    # gnome-calendar
    # gnome-characters
    gnome-clocks
    # gnome-contacts
    # gnome-font-viewer
    # gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-tour
    # pkgs.xterm # DO NOT REMOVE! (this is a rescue-package)
    # gnome-screenshot
    # gnome-system-monitor
    gnome-weather
    # gnome-disk-utility
    # gnome-connections
  ]