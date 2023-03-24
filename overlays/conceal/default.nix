{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ANsJqADYihAidGLJm3KCCxbqw8xTdPRNI7qlY4EzQxw=";
  };

  cargoHash = "sha256-/V5+fCwn+99w/vtJyx+3lvYNQ58HtUsjwPc0O++NEow=";

  # cargoLock = {
  #   lockFile = ./Cargo.lock;
  #   outputHashes = {
  #   #   "beefy-gadget-4.0.0-dev" = "sha256-3zOEG4ER0UQK3GRctZw6TgkX/8Ydk1ynU8N6vlepnHw=";
  #   #   "sub-tokens-0.1.0" = "sha256-GvhgZhOIX39zF+TbQWtTCgahDec4lQjH+NqamLFLUxM=";
  #   };
  # };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash completions/cnc.bash
    installShellCompletion --fish completions/cnc.fish
  '';

  meta = with lib; {
    description = "A trash collector";
    homepage = "https://github.com/TD-Sky/conceal";
    mainProgram = "cnc";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
