{ config, pkgs, ... }:
{
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    # Nix Tools
    nil
    # nixd
    ns-cli
    # alejandra
    nixpkgs-fmt
    nixfmt-rfc-style
    # lorri
    # cachix
    # comma # ,
    nix-top
    nix-tree
    nix-prefetch
    # colmena
    # nix-update
    # nix-template
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
    sd
    choose
    ssh-to-age
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
    croc
    magic-wormhole-rs
    ripdrag

    # System Monitor
    ctop # containers monitor
    iotop-c
    dstat
    powertop
    psmisc # pstree
    procs
    erdtree
    ikill
    gdu
    duf
    fastfetch
    tokei # count code

    # Utils
    just
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

  programs = {
    aria2 = {
      enable = true;
    };

    eza = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    btop = {
      enable = true;
    };

    # btm
    bottom = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    htop = {
      enable = true;
    };

    # hh :history
    hstr = {
      enable = true;
    };

    tealdeer = {
      enable = true;
    };

    fzf = {
      # enable = true;
    };

    skim = {
      enable = true;
    };

    yazi = {
      enable = true;
    };

    # z: autojump directory
    zoxide = {
      enable = true;
    };

    # shell history
    # atuin login -u zendo
    # atuin sync -f
    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
        # "--disable-ctrl-r"
      ];
      # settings = {
      #   auto_sync = true;
      #   sync_frequency = "5m";
      #   sync_address = "https://api.atuin.sh";
      #   search_mode = "prefix";
      # };
    };

    nix-index = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    micro = {
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
  };
}
