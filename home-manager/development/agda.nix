{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    (agda.withPackages (pkgs: with pkgs; [standard-library]))
    # inputs.agda-language-server.packages.${system}.default
  ];
}
