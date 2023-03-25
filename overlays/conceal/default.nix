{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+ChJjn3LCUUr8k0gcil/phNbN7qKgcgp6ti4BUURXR0=";
  };

  cargoHash = "sha256-FJnjuOSyZVWf1Wol7R19c/IC1YHMEkVFID8o2Zqr6t8=";

  # cargoLock = {
  #   lockFile = ./Cargo.lock;
  #   outputHashes = {
  #   #   "beefy-gadget-4.0.0-dev" = "sha256-3zOEG4ER0UQK3GRctZw6TgkX/8Ydk1ynU8N6vlepnHw=";
  #   #   "sub-tokens-0.1.0" = "sha256-GvhgZhOIX39zF+TbQWtTCgahDec4lQjH+NqamLFLUxM=";
  #   };
  # };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # installShellCompletion --zsh completions/conceal/_conceal
    installShellCompletion --bash completions/conceal/conceal.bash
    installShellCompletion --fish completions/conceal/conceal.fish
  '';

  meta = with lib; {
    description = "Command line tool based on trash-rs which implements FreeDesktop.org Trash specification";
    homepage = "https://github.com/TD-Sky/conceal";
    # mainProgram = "cnc";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
