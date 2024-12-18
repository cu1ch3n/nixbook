{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.python3.withPackages (
      ps: with ps; [
        requests
        pygobject3
      ]
    ))
    # master.jetbrains.pycharm-community
  ];
}
