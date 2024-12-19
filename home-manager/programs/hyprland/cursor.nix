{ pkgs, ... }:
let
  cursorThemeName = "Dracula-cursors";
  hyprcursorThemeName = "Dracula-hyprcursor";
  cursorSize = 24;
in
{
  home.file.".local/share/icons/${hyprcursorThemeName}".source = pkgs.dracula-hyprcursor;

  wayland.windowManager.hyprland.settings = {
    envd = [
      "XCURSOR_THEME, ${cursorThemeName}"
      "XCURSOR_SIZE, ${toString cursorSize}"
    ];

    exec-once = [
      "hyprctl setcursor ${hyprcursorThemeName} ${toString cursorSize}"
    ];
  };
}
