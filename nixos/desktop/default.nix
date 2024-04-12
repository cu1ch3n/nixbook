{ pkgs
, inputs
, ...
}:
{
  imports = [ ./fonts.nix ];

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    # displayManager.sddm.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    libinput.enable = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # };
}
