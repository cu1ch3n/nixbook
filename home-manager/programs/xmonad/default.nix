{
  xsession = {
    enable = true;
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hsPkgs: with hsPkgs; [
          dbus
          monad-logger
          xmobar
        ];
        config = ./config.hs;
      };
    };
  };
}
