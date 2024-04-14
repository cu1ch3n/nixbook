{pkgs, ...}: {
  home.packages = with pkgs; [
    (wechat-uos.override {
      uosLicense = pkgs.fetchurl {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/license.tar.gz?h=wechat-uos-bwrap";
        hash = "sha256-U3YAecGltY8vo9Xv/h7TUjlZCyiIQdgSIp705VstvWk=";
      };
    })
  ];
}
