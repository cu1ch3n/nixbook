{
  editor = {
    detectIndentation = true;
    fontFamily = "Iosevka, 'JetBrains Mono Light'";
    fontLigatures = true;
    formatOnPaste = false;
    minimap.enabled = false;
    stickyScroll.enabled = false;
    unicodeHighlight.ambiguousCharacters = false;
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
    formatterPath = [
      "nix"
      "fmt"
      "--"
      "-"
    ]; # using flakes with `formatter = pkgs.alejandra;`
    serverPath = "nil";
    serverSettings = {
      nil = {
        formatting = {
          command = [ "alejandra" ];
        };
      };
    };
  };
  search.useParentIgnoreFiles = true;
  vsicons.dontShowNewVersionMessage = true;
  window = {
    titleBarStyle = "custom";
    zoomLevel = 1;
  };
  workbench = {
    colorTheme = "Ayu Light";
    iconTheme = "vscode-icons";
  };
  breadcrumbs = {
    enabled = false;
  };
  latex-workshop = {
    formatting = {
      latex = "latexindent";
      latexindent.args = [
        "-c"
        "%DIR%/"
        "%TMPFILE%"
        "-m"
        "-l"
        "%WORKSPACE_FOLDER%/latexindent.yaml"
      ];
    };
    latex.tools = [
      {
        name = "latexmk";
        command = "latexmk";
        args = [
          "--shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "-pdf"
          "-outdir=%OUTDIR%"
          "%DOC%"
        ];
        env =
          {
          };
      }
      {
        name = "lualatexmk";
        command = "latexmk";
        args = [
          "--shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "-lualatex"
          "-outdir=%OUTDIR%"
          "%DOC%"
        ];
        env =
          {
          };
      }
      {
        name = "xelatexmk";
        command = "latexmk";
        args = [
          "--shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "-xelatex"
          "-outdir=%OUTDIR%"
          "%DOC%"
        ];
        env =
          {
          };
      }
      {
        name = "latexmk_rconly";
        command = "latexmk";
        args = [
          "%DOC%"
        ];
        env =
          {
          };
      }
      {
        name = "pdflatex";
        command = "pdflatex";
        args = [
          "--shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "%DOC%"
        ];
        env =
          {
          };
      }
      {
        name = "bibtex";
        command = "bibtex";
        args = [
          "%DOCFILE%"
        ];
        env =
          {
          };
      }
      {
        name = "rnw2tex";
        command = "Rscript";
        args = [
          "-e"
          "knitr::opts_knit$set(concordance = TRUE); knitr::knit('%DOCFILE_EXT%')"
        ];
        env =
          {
          };
      }
      {
        name = "jnw2tex";
        command = "julia";
        args = [
          "-e"
          "using Weave; weave(\"%DOC_EXT%\", doctype=\"tex\")"
        ];
        env =
          {
          };
      }
      {
        name = "jnw2texminted";
        command = "julia";
        args = [
          "-e"
          "using Weave; weave(\"%DOC_EXT%\", doctype=\"texminted\")"
        ];
        env =
          {
          };
      }
      {
        name = "pnw2tex";
        command = "pweave";
        args = [
          "-f"
          "tex"
          "%DOC_EXT%"
        ];
        env =
          {
          };
      }
      {
        name = "pnw2texminted";
        command = "pweave";
        args = [
          "-f"
          "texminted"
          "%DOC_EXT%"
        ];
        env =
          {
          };
      }
      {
        name = "tectonic";
        command = "tectonic";
        args = [
          "--synctex"
          "--keep-logs"
          "%DOC%.tex"
        ];
        env =
          {
          };
      }
    ];
    latex.autoBuild.run = "never";
  };
}
