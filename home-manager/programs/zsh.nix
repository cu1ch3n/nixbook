{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["extract" "git" "sudo"];
      theme = "robbyrussell";
    };

    shellAliases = {
    };

    # initExtra = ''
    #   [[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
    # '';

    # localVariables = {
    #   http_proxy = "http://127.0.0.1:7890";
    #   https_proxy = "http://127.0.0.1:7890";
    #   all_proxy = "socks5://127.0.0.1:7890";
    # };
  };
}
