{ config, pkgs, ...}:

{
    
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # new for nix 24:
    xkb = {
      layout = "ch";
      variant = "";
    };
    # remove some default apps
    excludePackages = [pkgs.xterm];
  };


  programs.dconf = {
    enable = true;
    profiles = {
      user = {
        databases = [ {
          settings = {
            "org/gnome/shell/extensions/Battery-Health-Charging" = {
              amend-power-indicator = false;
              bal-end-threshold = "75";
              bal-start-threshold = "60";
              ful-end-threshold = "95";
              ful-start-threshold = "85";
              max-end-threshold = "50";
              max-start-threshold = "40";
              current-bal-end-threshold = "75";
              current-bal-start-threshold = "60";
              current-ful-end-threshold = "95";
              current-ful-start-threshold = "85";
              current-max-end-threshold = "50";
              current-max-start-threshold = "40";
              default-threshold = false;
              charging-mode = "max";
              ctl-path = "/usr/local/bin/batteryhealthchargingctl-tim";
              force-discharge-enabled = true;
              force-discharge-feature = true;
              indicator-position-max = "3";
              show-battery-panel2 = false;
              show-preferences = true;
              show-quickmenu-subtitle = true;
              show-system-indicator = false;
              show-notifications = false;
            };
            "org/gnome/shell/extensions/dash-to-dock" = {
              dock-position = "BOTTOM";
              apply-custom-theme = false;
              autohide-in-fullscreen = false;
              background-opacity = "0.8";
              click-action = "previews";
              dash-max-icon-size = "48";
              dock-fixed = false;
              height-fraction = "0.9";
              intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
              middle-click-action="launch";
              multi-monitor=true;
              preferred-monitor="-2";
              preferred-monitor-by-connector="eDP-1";
              preview-size-scale="0.0";
              require-pressure-to-show=true;
              scroll-action="cycle-windows";
              shift-click-action="minimize";
              shift-middle-click-action="launch";
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding = "<Control><Alt>t";
              command = "blackbox";
              # command = "kgx";
              name = "Open Terminal";
            };
            "org/gnome/mutter" = {
              dynamic-worksaces = true;
              edge-tiling = true;
              workspaces-only-on-primary = true;
            };
            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              ];
            };
            "org/gnome/desktop/privacy" = {
              disable-camera=true;
              disable-microphone=true;
            };
            "org/gnome/desktop/interface" = {
              color-scheme="prefer-dark";
              locate-pointer=true;
              show-battery-percentage=true;
            };
            "org/gnome/desktop/background" = {
              color-shading-type="solid";
              picture-uri="file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
              picture-uri-dark="file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
              primary-color="#77767B";
              secondary-color="#000000";
            };
            "org/gnome/shell" = {
              "enabled-extensions" = [
                "dash-to-dock@micxgx.gmail.com"
                "Vitals@CoreCoding.com"
                "gsconnect@andyholmes.github.io"
                "Battery-Health-Charging@maniacx.github.com"
              ];
            };
            "org/gnome/shell/extensions/vitals" = {
              "hot-sensors" = [
                  "__fan_avg__" 
                  "__temperature_avg__"
                  "_battery_time_left_"
              ];
            };
          };
        }];
      };
    };
  };
  
}