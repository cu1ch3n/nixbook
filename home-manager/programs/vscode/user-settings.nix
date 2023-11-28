{
  editor = {
    detectIndentation = true;
    fontFamily = "'JetBrains Mono Light'";
    fontLigatures = true;
    formatOnPaste = false;
    minimap.enabled = false;
  };
  explorer.excludeGitIgnore = true;
  extensions.ignoreRecommendations = true;
  git = {
    autofetch = true;
    confirmSync = false;
  };
  haskell.manageHLS = "PATH";
  latex-input = {
    mappings = import ./latex-input.nix;
  };
  nix = {
    enableLanguageServer = true;
    serverPath = "nixd";
  };
  search.useParentIgnoreFiles = true;
  vsicons.dontShowNewVersionMessage = true;
  window = {
    titleBarStyle = "custom";
    zoomLevel = 1;
  };
  workbench = {
    colorTheme = "Atom One Dark";
    iconTheme = "vscode-icons";
  };
}
