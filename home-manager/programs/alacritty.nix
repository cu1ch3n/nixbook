{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        padding = {
          x = 12;
          y = 12;
        };
        opacity = 0.9;
      };
      font = {
        normal = {
          family = "Hack";
          style = "Regular";
        };
        bold = {
          family = "Hack";
          style = "Bold";
        };
        italic = {
          family = "Hack";
          style = "Italic";
        };
        size = 12;
      };
      cursor.style = "Block";
      general.live_config_reload = true;
    };
  };
}
