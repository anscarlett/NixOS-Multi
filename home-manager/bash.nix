{ ... }:
{
  programs.bash = {
    enable = true;
  };

  # ~/.inputrc
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-h" = "backward-kill-word";
    };
    extraConfig = ''
      set bell-style none
      set completion-ignore-case on
      # Show all tab-completion options on first <tab>
      set show-all-if-ambiguous on
    '';
  };
}
