{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Nix Tools
    nil
    ns-cli
    alejandra
    nixpkgs-fmt
    # lorri
    # cachix
    nurl
    comma # ,
    nix-init
    nix-top
    nix-tree
    nix-prefetch
    deploy-rs
    # colmena
    # nix-update
    # nix-template
    nixpkgs-review
    nixos-generators
    nix-output-monitor

    # Developing
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    discount # markdown
    efm-langserver # markdown lsp
    strace
    lurk # strace alternative

    # Compressor / Archiver
    p7zip
    unzip
    # unar # free but oversize
    unrar # unfree
    ouch
    patool
    # atool

    # FileManager
    f2
    fd
    ripgrep
    sd
    choose
    sops
    age
    # rage # age encrypt RIIR
    lf
    ctpv
    chafa # image viewer
    viu # image viewer
    graphviz
    # imagemagick
    exiftool
    ffmpegthumbnailer
    trash-cli
    eget
    zssh # SSH and Telnet client
    termscp
    croc
    magic-wormhole-rs

    # System Monitor
    btop
    ctop # containers monitor
    htop
    iotop-c
    dstat
    powertop
    bottom # btm
    psmisc # pstree
    procs
    ikill
    gdu
    duf
    neofetch
    tokei # count code

    # Utils
    hstr # hh: history
    cht-sh
    # difftastic # too big
    kalker # calculator
    ydict
    typos
    shellcheck
    translate-shell
    aspellDicts.en
    asciinema # record the terminal
    paperoni # save html
    calcurse
    # zee

    # Networking
    lsof
    dogdns
    nali
    mtr
    nload
    ipinfo
    elinks
    dnspeep
    nethogs
    bandwhich
    traceroute
    speedtest-cli
    proxychains-ng
    # airgeddon # wifi crack

    # Game & fun
    cava # Music Visualizer
    # pipes-rs
    # cbonsai
    # hollywood
    # nyancat
  ];

  manual.manpages.enable = false;

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

  programs.tealdeer = {
    enable = true;
  };

  # z: autojump directory
  programs.zoxide = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  programs.skim = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  #######################################################################
  ##  CLI EDITOR
  #######################################################################
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.micro = {
    enable = true;
    settings = {
      autosu = true;
      softwrap = true;
      hlsearch = true;
      saveundo = true;
      scrollbar = true;
      mkparents = true;
      diffgutter = true;
    };
  };
}
