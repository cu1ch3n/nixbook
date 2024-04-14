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
    formatterPath = "alejandra";
    serverPath = "nixd";
  };
  search.useParentIgnoreFiles = true;
  vsicons.dontShowNewVersionMessage = true;
  window = {
    autoDetectColorScheme = true;
    titleBarStyle = "custom";
    zoomLevel = 1;
  };
  workbench = {
    preferredLightColorTheme = "Atom One Light";
    preferredDarkColorTheme = "Atom One Dark";
    colorTheme = "Atom One Light";
    iconTheme = "vscode-icons";
  };
}
