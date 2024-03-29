{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    networkmanager
    networkmanagerapplet
    alsaTools
    alsaUtils
    xorg.xmodmap
    direnv
    lorri
    st
    arandr
    lxappearance
    arc-theme
    moka-icon-theme
    xfce.thunar
    teams
    texlive.combined.scheme-full
  ];
  targets.genericLinux = {
    enable = true;
    extraXdgDataDirs = [ "/usr/share" "/usr/local/share" ];
  };
  services = { gnome-keyring.enable = true; };
  xdg.configFile.xmodmap = {
    text = ''
      clear lock
      clear control
      clear mod3

      ! swap escape and caps lock
      keysym Escape = Caps_Lock
      keysym Caps_Lock = Escape
      add lock = Caps_Lock

      ! map Ctrl_R to Hyper_R, and use it as mod key for i3
      keycode 105 = Hyper_R
      add mod3 = Hyper_R
      add control = Control_L
    '';
    target = "xmodmap";
  };
  gtk = {
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = {
      package = pkgs.moka-icon-theme;
      name = "Moka";
    };
  };
  programs = {
    # gnome-terminal.enable = true;
    rofi = {
      enable = true;
      theme = "Arc-Dark";
    };
    i3status-rust = {
      enable = true;
      bars = {
        top = {
          # settings.theme.name = "nord-dark";
          settings.theme.name = "gruvbox-dark";
          icons = "awesome";
          blocks = [
            {
              block = "sound";
              format = "{output_name} {volume}";
              on_click = "pavucontrol --tab=3";
              mappings = {
                "alsa_output.pci-0000_00_1b.0.analog-stereo" = "speaker";
              };
            }
            {
              block = "cpu";
              interval = 1;
              format = "{utilization} {barchart}";
            }
            {
              block = "memory";
              format_mem = "{mem_used}/{mem_total}({mem_used_percents})";
              display_type = "memory";
              icons = true;
              interval = 1;
              warning_mem = 80;
              critical_mem = 95;
            }
            {
              block = "networkmanager";
              on_click = "nm-connection-editor";
            }
            {
              block = "time";
              format = "%a %d/%m %R";
              interval = 1;
            }

          ];
        };
      };
    };
  };
  xsession = {
    enable = true;
    #initExtra = ''xmodmap $XDG_CONFIG_HOME/xmodmap
    #  exec --no-startup-id xsetroot -solid "#333333"'';
    initExtra = "xmodmap $XDG_CONFIG_HOME/xmodmap";
    windowManager.i3 = let
      ws_web = "1:";
      ws_code = "2:";
      ws_terminal = "3:";
      ws_teams = "4:";
    in {
      enable = true;
      config = rec {
        bars = [{
          fonts = {
            names = [ "Hack" "FontAwesome" ];
            size = 12.0;
          };
          position = "top";
          workspaceButtons = true;
          workspaceNumbers = false;
          statusCommand =
            "i3status-rs $HOME/.config/i3status-rust/config-top.toml";
        }];
        fonts = {
          names = [ "Hack" "FontAwesome" ];
          size = 12.0;
        };
        startup = [{
          command =
            "exec xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output Virtual-2 --off --output Virtual-3 --off --output Virtual-4 --off";
        }];
        assigns = {
          ${ws_web} = [{ class = "^Nightly$"; }];
          ${ws_code} = [{ class = "^Emacs$"; }];
          ${ws_terminal} = [ ];
          ${ws_teams} = [ ];
        };
        modifier = "Mod3";
        terminal = "st -f 'Hack Nerd Font:size=12'";
        keybindings = lib.mkOptionDefault {
          "${modifier}+F1" = "exec firefox";
          "${modifier}+F2" = "exec emacs";
          "${modifier}+q" = "kill";
          "${modifier}+d" =
            "exec --no-startup-id rofi -modi 'window#ssh#drun' -show drun";

          "${modifier}+1" = "workspace ${ws_web}";
          "${modifier}+Shift+1" = "move container to workspace ${ws_web}";

          "${modifier}+2" = "workspace ${ws_code}";
          "${modifier}+Shift+2" = "move container to workspace ${ws_code}";

          "${modifier}+3" = "workspace ${ws_terminal}";
          "${modifier}+Shift+3" = "move container to workspace ${ws_terminal}";

          "${modifier}+4" = "workspace ${ws_teams}";
          "${modifier}+Shift+4" = "move container to workspace ${ws_teams}";
        };
      };
    };
  };
}
