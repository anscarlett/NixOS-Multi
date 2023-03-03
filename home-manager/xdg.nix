{
  config,
  lib,
  pkgs,
  ...
}: let
  mkOOSL = config.lib.file.mkOutOfStoreSymlink;
  hmDots = config.home.homeDirectory + "/nsworld/dotfiles";
  rime-ice-custom = ''
    patch:
      "switches":
        - name: ascii_mode # 0 中文，1 英文
          states: [ 中, A ]
          reset: 1
        - name: full_shape
          # states: [ 半角, 全角 ]
          reset: 0
        - name: ascii_punct
          states: [ 。，, ．， ]
          # reset: 0
        - name: traditionalization
          states: [ 简, 繁 ]
          reset: 0
        - name: emoji
          states: [ 💀, 😄 ]
          # reset: 1
  '';
in {
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.emacs.d/bin"
    "${../dotfiles/bin}"
  ];

  home.sessionVariables = {
    VISUAL = "micro";
    EDITOR = "micro";
  };

  home.file = {
    ".doom.d".source = mkOOSL hmDots + "/doom";
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "foot".source = ../dotfiles/foot;
    "kitty".source = ../dotfiles/kitty;
    "helix".source = ../dotfiles/helix;
    "wezterm".source = ../dotfiles/wezterm;
    "gtklock".source = ../dotfiles/gtklock;
    "swaylock".source = ../dotfiles/swaylock;
    "nix-init".source = ../dotfiles/nix-init;
    "alacritty".source = ../dotfiles/alacritty;
    "radioboat".source = ../dotfiles/radioboat;
    "starship.toml".source = ../dotfiles/starship.toml;

    "emacs/init.el".source = ../dotfiles/emacs/init.el;
    "emacs/early-init.el".source = ../dotfiles/emacs/early-init.el;
    "emacs/elisp".source = mkOOSL hmDots + "/emacs/elisp";

    "lf".source = mkOOSL hmDots + "/lf";
    "mako".source = mkOOSL hmDots + "/mako";
    "waybar".source = mkOOSL hmDots + "/waybar";
    "wayfire.ini".source = mkOOSL hmDots + "/wayfire.ini";
    "sway/custom.conf".source = mkOOSL hmDots + "/sway/custom.conf";
    "hypr/custom.conf".source = mkOOSL hmDots + "/hypr/custom.conf";

    # ibus-rime
    "ibus/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: rime_ice
    '';
    "ibus/rime/ibus_rime.custom.yaml".text = ''
      patch:
        style:
          horizontal: true
    '';
    "ibus/rime/rime_ice.custom.yaml".text = rime-ice-custom;
  };

  xdg.dataFile = {
    "goodvibes".source = ../dotfiles/goodvibes;
    "color-schemes/Genshin.colors".source = ../dotfiles/misc/kde-color-Genshin.colors;

    # fcitx-rime
    "fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: rime_ice
    '';
    "fcitx5/rime/rime_ice.custom.yaml".text = rime-ice-custom;
  };
}
