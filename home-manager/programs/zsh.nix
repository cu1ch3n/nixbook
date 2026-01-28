{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "extract"
        "git"
        "sudo"
      ];
      theme = "robbyrussell";
    };

    shellAliases = { };

    initContent = ''
      [[ ! -r '/home/chen/.opam/opam-init/init.zsh' ]] || source '/home/chen/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
      
      # Configure opam for NixOS: disable sandboxing to allow access to Nix-provided build tools
      if command -v opam > /dev/null 2>&1; then
        # Disable opam sandboxing for NixOS compatibility
        opam option --global depext=false > /dev/null 2>&1 || true
        # Set sandbox to false to disable sandboxing
        opam option --global sandbox=false > /dev/null 2>&1 || true
      fi
    '';
  };
}
