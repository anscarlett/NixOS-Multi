{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ xclip ];

  # programs.zellij = {
  #   enable = true;
  #   settings = {};
  # };

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    prefix = "C-x";
    aggressiveResize = true;
    terminal = "xterm-kitty"; # tmux-256color
    shell = "${lib.getExe pkgs.zsh}";
    disableConfirmationPrompt = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      fuzzback # ?
      extrakto # tab
      tmux-fzf # prefix - F
      resurrect # environment save : prefix - C-s/C-r
      # continuum # automatically save 15m BUG!!!
      # catppuccin # theme
      # onedark-theme
    ];
    extraConfig = ''
      # set-option -g prefix2 C-x

      bind m copy-mode

      # Increase scrollback buffer size from 2000 to 50000 lines
      set -g history-limit 50000

      unbind '"'
      bind 2 splitw -v -c '#{pane_current_path}'
      unbind %
      bind 3 splitw -h -c '#{pane_current_path}'
      bind 0 kill-pane
      bind x swap-pane -D

      # unbind c
      bind t new-window -c "#{pane_current_path}"
      bind k kill-window
      bind b list-windows
      bind Right next-window
      bind Left previous-window

      bind S new-session
      bind Up switch-client -p
      bind Down switch-client -n

      # silence
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      set -g monitor-activity off
      set -g bell-action none

      ######################
      ###  DESIGN THEME  ###
      ######################

      ## #H[ost] #W #T #I #{b:pane_current_path}

      # Title bar
      set -g set-titles on
      set -g set-titles-string ' #H : #W'

      # Pane borders
      set -g pane-border-style fg=colour235 #fg=base02
      set -g pane-active-border-style fg=colour240 #fg=base01
      # set -g pane-border-status bottom
      # set -g pane-border-format ' #{pane_current_command} '

      # Command line
      set -g message-style bright,bg=white,fg=black

      # Status bar
      set -g status-position top
      # set -g status-justify left
      set -g status-style fg=white,bold,bg=default
      set -g status-right-style fg=color0,bold,bg=color4
      set -g status-right " %m/%d #[bg=color15,fg=color0] %H:%M "

      # default window title colors
      set -g window-status-style bg=color0,dim
      set -g window-status-format "#I: #{b:pane_current_path} "

      # active window title colors
      set -g window-status-current-style fg=color0,bold,bg=brightgreen
      set -g window-status-current-format "#I: #{b:pane_current_path} "

      # set -g status-style 'bg=#282c34 fg=#aab2bf dim'
      # # set -g status-style 'bg=terminal'
      # set -g status-left ' '
      # set -g status-right '#[bg=#282c34,fg=#aab2bf] %m/%d #[fg=colour233,bg=colour8] %H:%M '
      # set -g status-right-length 50
      # set -g status-left-length 20
    '';
  };
}
