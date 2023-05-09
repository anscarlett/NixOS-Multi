{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    # python3
  ];

  #######################################################################
  ##  EMACS
  #######################################################################
  programs.emacs = {
    enable = true;
    package =
      pkgs.emacsPgtk;
    # fix duplicate desktop shortcut in kde
    # pkgs.emacsPgtk.overrideAttrs (finalAttrs: previoiusAttrs: {
    #   postFixup = ''rm $out/share/applications/emacsclient.desktop'';
    # });
    extraPackages = epkgs:
      with epkgs; [
        vterm
        emojify
        emacsql-sqlite
        # lsp-bridge
        # tree-sitter
        # pdf-tools
        # telega
      ];
    extraConfig = ''
      (setq treemacs-python-executable "${pkgs.python3}/bin/python")
    '';
  };

  #######################################################################
  ##  VSCODE
  #######################################################################
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      jnoortheen.nix-ide
      kamadorueda.alejandra
      editorconfig.editorconfig
      file-icons.file-icons
      golang.go
      mattn.lisp
      eamodio.gitlens
      ms-vscode.cmake-tools
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "editor.fontSize" = 13;
      "editor.fontFamily" = "'JetBrains Mono', 'Hack', 'Droid Sans Mono', monospace, 'Droid Sans Fallback'";
      "update.mode" = "none";
      # "workbench.colorTheme" = "Monokai";
      # "workbench.commandPalette.preserveInput" = true;
      # "workbench.editor.enablePreviewFromCodeNavigation" = true;
      # "workbench.iconTheme" = "vscode-icons";
    };
    # keybindings = [
    #   {
    #     key = "ctrl+m";
    #     command = "editor.action.clipboardCopyAction";
    #     when = "textInputFocus";
    #   }
    # ];
  };

  programs.pandoc = {
    enable = false;
  };
}
