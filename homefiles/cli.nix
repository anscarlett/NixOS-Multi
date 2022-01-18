{ config, pkgs, ... }:

{
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.emacs.d/bin"
  ];

  home.shellAliases = {
    l = "ls";
    cat = "bat";
    ps = "ps -ef";
    rm = "${pkgs.trash-cli}/bin/trash-put";
    rm-list = "${pkgs.trash-cli}/bin/trash-list";
    rm-empty = "${pkgs.trash-cli}/bin/trash-empty";
    # sudo = "sudo -E";
    ip = "ip --color=auto";
    myip = "curl ip.sb";

    gu = "gitui";
    ee = "emacs -nw";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \\
    export https_proxy=http://127.0.0.1:20171";
    journalctl-last = "journalctl -p err..alert --since \"50 min ago\"";

    nswitch = "sudo -E nixos-rebuild switch --flake ~/.dotworld#$(hostname)";
    nboot = "sudo -E nixos-rebuild boot --flake ~/.dotworld#$(hostname)";
    nupgrade = "sudo -E nixos-rebuild boot --flake ~/.dotworld#$(hostname) \\
    --recreate-lock-file";
  };

  home.file = {
    # ".vimrc".source = ./vimrc;

    ".inputrc".text = ''
      set completion-ignore-case on
      # Show all tab-completion options on first <tab>
      set show-all-if-ambiguous on
      $if Bash
          # In bash only, enable "magic space" so that typing space
          # will show completions. i.e. !!_ (where _ is space)
          # will expand !! for you.
          Space: magic-space
      $endif
    '';

  };

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ../others/wezterm.lua;
  };

  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status";
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      addp = "add --patch";
      comp = "commit --patch";
      co = "checkout";
      ci = "commit";
      ca = "commit -a -m";
      lg = "log --graph --decorate --all --oneline";
    };
  };

  programs.gh = {
    enable = false;
    enableGitCredentialHelper = true;
  };

  programs.exa = {
    enable = true;
    # ll, la, lla, lt ...
    enableAliases = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.aria2 = {
    enable = true;
  };

  programs.lf = {
    enable = true;
  };

  # z: autojump
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # C-r: history search
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.skim = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = false;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      # disable "It took xxs"
      cmd_duration.disabled = true;
    };
  };

  programs.nix-index = {
    enable = false;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bash = {
    enable = true;
    # shellAliases = {
    # };
    # bashrcExtra = ''
    # '';
  };

  programs.fish = {
    enable = false;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };
    shellAliases = {
      history = "history 0";
    };
    initExtra = ''
      bindkey -e
      setopt no_nomatch
    '';
  };

  programs.tmux = {
    enable = false;
    extraConfig = ''
      # Set the prefix.
      # set -g prefix M-a

      # Close the current session.
      bind -n M-q kill-session

      # Close the current pane.
      bind -n M-w kill-pane
    '';
  };

}