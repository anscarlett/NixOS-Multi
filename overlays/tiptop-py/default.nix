{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tiptop-py";
  version = "0.2.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "tiptop";
    rev = "v${version}";
    hash = "sha256-3nrYwcdqGGRvYB5FOW/OCqlRHIlCdkxClBfyKnVC1rQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    py-cpuinfo
    distro
    psutil
    rich
    textual
  ];

  checkInputs = [ python3.pkgs.pytestCheckHook ];

  pythonImportsCheck = [ "tiptop" ];

  # postInstall = ''
  #   mv $out/bin/tiptop $out/bin/tiptop-py
  # '';

  meta = with lib; {
    description = "Command-line system monitoring tool in the spirit of top";
    homepage = "https://github.com/nschloe/tiptop";
    license = licenses.mit;
    # Use a higher priority to shadow `tiptop` package.
    priority = 5;
    mainProgram = "tiptop";
    maintainers = with maintainers; [ zendo ];
  };
}