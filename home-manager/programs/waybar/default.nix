{
  programs.waybar = {
    enable = true;

    settings = {
      primary = {
        mode = "dock";
        layer = "top";
        position = "top";
        height = 30;
        margin = "6";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "disk"
          "memory"
          "cpu"
          "temperature"
          "tray"
          "pulseaudio"
          "clock"
        ];

        clock = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
        };

        pulseaudio = {
          "format" = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon}";
          "format-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
            ];
          };
          scroll-step = 5;
          on-click = "pavucontrol";
          ignored-sinks = [ "Easy Effects Sink" ];
        };

        "wlr/workspaces" = {
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          all-outputs = true;
        };
      };
    };
  };
}
