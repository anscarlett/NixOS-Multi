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
    beep = "echo -en \"\\007\"";
    rm = "${pkgs.trash-cli}/bin/trash-put";
    rm-list = "${pkgs.trash-cli}/bin/trash-list";
    rm-empty = "${pkgs.trash-cli}/bin/trash-empty";
    ip = "ip --color=auto";
    ipsb = "curl ip.sb";
    ipinfo = "curl ipinfo.io";

    ee = "emacs -nw";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \\
    export https_proxy=http://127.0.0.1:20171";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";

    nse = "nix search nixpkgs";
    nix-repl-pkgs = "nix repl '<nixpkgs>'";
    nixos-readlink = "readlink -f /nix/var/nix/profiles/system";
    ns-pkgs-installed = "nix path-info --recursive /run/current-system";
    ns-generations = "nix profile history --profile /nix/var/nix/profiles/system";
    ns-diff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    ns-switch = "sudo -E nixos-rebuild switch --flake ~/nsworld#$(hostname)";
    ns-boot = "sudo -E nixos-rebuild boot --flake ~/nsworld#$(hostname)";
    ns-upgrade = "sudo -E nixos-rebuild boot --flake ~/nsworld#$(hostname) \\
    --recreate-lock-file";
  };

  home.file = {
    # ".vimrc".source = ./vimrc;

    ".inputrc".text = ''
      set bell-style none
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

    # ".local/share/fcitx5/themes".source = pkgs.fetchFromGitHub {
    #   owner = "icy-thought";
    #   repo = "fcitx5-catppuccin";
    #   rev = "3b699870fb2806404e305fe34a3d2541d8ed5ef5";
    #   sha256 = "hOAcjgj6jDWtCGMs4Gd49sAAOsovGXm++TKU3NhZt8w=";
    # };

  };

  xdg.configFile = {
    "mpv".source = ./mpv;
    "foot/foot.ini".source = ./foot.ini;
    "wezterm/wezterm.lua".source = ./wezterm.lua;
    "alacritty/alacritty.yml".source = ./alacritty.yml;
  };

  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status -sb";
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      pm = "push -u origin main";
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

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
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
    # package = pkgs.nix-index-git;
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
      setopt no_nomatch
      unsetopt correct
      bindkey -e
      bindkey "\e[27;2;13~" accept-line  # shift+return
      bindkey "\e[27;5;13~" accept-line  # ctrl+return
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