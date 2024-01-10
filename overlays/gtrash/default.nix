{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gtrash";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "umlx5h";
    repo = "gtrash";
    rev = "v${version}";
    hash = "sha256-OqJ9uxRsr1RGY5JLqMuFpdu9QmiVvBQOrJzFg7THnso=";
  };

  vendorHash = "sha256-lsExnIlPHH1vFYipCBv1MpKwKmI4eRT9PwWp0nc2THM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=goreleaser"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Modern Trash CLI manager for Linux system trash written in Go";
    homepage = "https://github.com/umlx5h/gtrash";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
    mainProgram = "gtrash";
  };
}
