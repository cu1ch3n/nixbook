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
  };
}
