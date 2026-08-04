{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  defaultCustom = builtins.toFile "default.custom.yaml" ''
    patch:
      schema_list:
        - schema: rime_ice
      "menu/page_size": 9
  '';
in
stdenvNoCC.mkDerivation (_: {
  pname = "rime-ice";
  version = "2026.06.30";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "6810e8916d160498620a16fef2135956fecbd485";
    hash = "sha256-HReBFYih39ohqZ2UAX6wPjjh0KuIauJPSOjk6ZXidss=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/rime-data
    cp -r * $out/share/rime-data
    install -m 0644 ${defaultCustom} \
      $out/share/rime-data/default.custom.yaml
    runHook postInstall
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chen ];
  };
})
