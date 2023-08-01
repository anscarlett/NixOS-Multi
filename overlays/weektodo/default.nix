{ lib
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, electron
}:
# WIP!!!
mkYarnPackage rec {
  pname = "weektodo";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "manuelernestog";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pg0oaLejR0KeqctVspjfJEbPsT+ygVvQTl3B1yqUnvE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-HAq68o0xkRE3a4sGxZssblCm5Zs88N0OMIbYOqF4v/Y=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  distPhase = "true";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    yarn --offline electron-builder \
      --dir --linux --x64 \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,${pname}}
    cp -r ./* $out/share/${pname}
    # cp deps/${pname}/dist/linux-unpacked/resources/app.asar $out/share/${pname}

    # for size in 16 32 128 256 512; do
    #   install -D deps/${pname}/build/icon.iconset/icon_''${size}x''${size}.png \
    #     $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    # done

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --argv0 "WeekToDo" \
      --add-flags "$out/share/${pname}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "WeekToDo";
      comment = meta.description;
      categories = [ "Office" ];
    })
  ];

  meta = with lib; {
    description = "A free minimalist weekly planner app focused on privacy";
    homepage = "https://weektodo.me";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
