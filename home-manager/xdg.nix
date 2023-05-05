{
  config,
  ...
}: let
  lnDots = config.lib.file.mkOutOfStoreSymlink config.home.homeDirectory + "/nsworld/dotfiles";
in {
  home.sessionPath = [
    "${../dotfiles/bin}"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "micro";
    EDITOR = "micro";
  };

  home.file = {
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "foot".source = ../dotfiles/foot;
    "kitty".source = ../dotfiles/kitty;
    "wezterm".source = ../dotfiles/wezterm;
    "gtklock".source = ../dotfiles/gtklock;
    "swaylock".source = ../dotfiles/swaylock;
    "nix-init".source = ../dotfiles/nix-init;
    "alacritty".source = ../dotfiles/alacritty;
    "radioboat".source = ../dotfiles/radioboat;

    "doom".source = "${lnDots}/doom";
    "emacs/elisp".source = "${lnDots}/emacs/elisp";
    "emacs/init.el".source = ../dotfiles/emacs/init.el;
    "emacs/early-init.el".source = ../dotfiles/emacs/early-init.el;

    "lf".source = "${lnDots}/lf";
    "mpv".source = "${lnDots}/mpv";
    "mako".source = "${lnDots}/mako";
    "helix".source = "${lnDots}/helix";
    "waybar".source = "${lnDots}/waybar";
    "yt-dlp".source = "${lnDots}/yt-dlp";
    "starship.toml".source = "${lnDots}/starship.toml";
    "sway/custom.conf".source = "${lnDots}/sway/custom.conf";
    "hypr/custom.conf".source = "${lnDots}/hypr/custom.conf";
  };

  xdg.dataFile = {
    "goodvibes".source = ../dotfiles/goodvibes;
    "color-schemes/Genshin.colors".source = ../dotfiles/misc/kde-color-Genshin.colors;
  };
}
