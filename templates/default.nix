{
  # nix flake init -t ~/nsworld#minimal
  mkiso = {
    description = ''
      Minimal flake - contains only the configs.
      Contains the bare minimum to migrate your existing legacy configs to flakes.
    '';
    path = ./mkiso;
  };
}
