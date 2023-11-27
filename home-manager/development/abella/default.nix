{ pkgs
, lib
, ...
}:
let
  merge = attrs: builtins.foldl' (x: y: x // y) { } (builtins.attrValues attrs);
in
{
  xdg.configFile = {
    # Abella
    "sublime-text/Packages/Abella".source = pkgs.fetchFromGitHub {
      owner = "JimmyZJX";
      repo = "SublimeAbella";
      rev = "a42909957d6028321c8964712e700c12ceac58b7";
      hash = "sha256-SnwTCjdI9jPvZLhraRUmLzt6zSf5wxxqxLXIVTSQWts=";
    };
    "sublime-text/Packages/User/Abella.sublime-settings".text = builtins.toJSON {
      "abella.exec" = "${pkgs.abella}/bin/abella";
      "proof_view_mode" = "panel";
    };
    # Sublime Text
    "sublime-text/Packages/User/Preferences.sublime-settings".text = builtins.toJSON (merge {
      ui = {
        margin = 4;
        gutter = true;
        drag_text = false;
        line_numbers = true;
        show_encoding = true;
        ui_separator = false;
        fold_buttons = false;
        highlight_line = true;
        scroll_past_end = true;
        hardware_acceleration = "opnegl";
      };
      font = {
        font_size = 14;
        font_face = "JetBrains Mono";
        font_options = [ "gray_antialias" ];
        theme_font_options = [ "gray_antialias" ];
      };
      format = {
        default_line_ending = "unix";
        ensure_newline_at_eof_on_save = true;
        trim_trailing_white_space_on_save = "all";
      };
      autoComplete = {
        auto_complete_delay = 0;
        auto_complete_trailing_symbols = true;
      };
      misc = {
        ignored_packages = [ "Vintage" ];
        file_exclude_patterns = import ./patterns.nix;
      };
    });
  };
  home.packages = with pkgs;
    with nur.repos.chen; [
      abella
      abella-modded
      sublime4
    ];
}
