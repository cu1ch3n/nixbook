{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "extract" "git" "sudo" ];
      theme = "robbyrussell";
    };

    shellAliases = {
    };

    # initExtra = ''
    #   [[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
    # '';
  };
}
