{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status -sb";
      undo = "reset --hard HEAD~1";
      patch = "format-patch --stdout HEAD~1";
      rank = "shortlog -s -n --no-merges";
      lg = "log --graph --decorate --all --oneline";
      ll = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
    };
    extraConfig = {
      init.defaultBranch = "main";
      # pull.rebase = true;
      # merge.ff = "only";
      # core.editor = "vim";
      # credential.helper = "store";
      safe.directory = [
        # "/home/iab/nsworld"
        # "/home/iab/devel/nixpkgs"
      ];
    };
  };

  programs.git.delta = {
    enable = true;
  };

  # Git Large File Storage
  programs.git.lfs = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  # programs.ssh = {
  #   enable = true;
  #   # extraConfig = ''
  #   #   ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
  #   # '';
  # };
}
