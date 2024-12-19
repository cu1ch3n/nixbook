{ pkgs, inputs, ... }:
{
  imports = [
    ./cursor.nix
  ];

  home.packages = with pkgs; [
    wlogout
    dracula-hyprcursor
    swaynotificationcenter
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "fuzzel";

      exec-once = [
        "swaync &"
        "fcitx5"
        "1password"
      ];

      monitor = [
        "eDP-1, 1920x1200@60, 0x0, 1"
        "DP-1, 1920x1080@60, 1920x0, 1"
        ", preferred, auto, 1"
      ];

      # turn off the laptop display when closing the lid
      bindl = [
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 1920x1200@60, 0x0, 1\""
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bind =
        [
          ", Print, exec, grimblast copy area"
          "$mod SHIFT, return, exec, $terminal"
          "$mod, P, exec, $menu"
          "$mod SHIFT, C, killactive, "
          "$mod SHIFT, Q, exec, wlogout"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, SPACE, fullscreen, 1"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      general = {
        gaps_in = 3;
        gaps_out = 3;

        "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
        "col.inactive_border" = "rgba(44475aaa)";
        "col.nogroup_border" = "rgba(282a36dd)";
        "col.nogroup_border_active" = "rgb(bd93f9) rgb(44475a) 90deg";
        no_border_on_floating = false;
        border_size = 2;

        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 60;
          offset = "1 2";
          render_power = 3;
          scale = 0.97;
          color = "rgba(1E202966)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      group = {
        groupbar = {
          "col.active" = "rgb(bd93f9) rgb(44475a) 90deg";
          "col.inactive" = "rgba(282a36dd)";
        };
      };

      windowrulev2 = "bordercolor rgb(ff5555),xwayland:1";

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };
    };
  };

  programs.swaylock = {
    enable = true;
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts = [
      {
        timeout = 10 * 60;
        command = "swaylock -f";
      }
      {
        timeout = 11 * 60;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
    ];
  };
}
