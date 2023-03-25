{ lib
, stdenv
, fetchFromGitHub
, file
, openssl
, ffmpeg
, ffmpegthumbnailer
, waylandSupport ? stdenv.isLinux
, x11Support ? stdenv.isLinux
, chafa
, ueberzug
}:

stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = pname;
    rev = "f1f649fd9cc05abd6a243d938a5edda832ba1a5b";
    hash = "sha256-yE7sU+HxJ29rAt46HB/f53dO8Jxnh8I9DklNUa3nk8w=";
  };

  buildInputs = [
    file # libmagic
    openssl
    ffmpeg
    ffmpegthumbnailer
  ] ++ lib.optionals waylandSupport [
    chafa
  ]
  ++ lib.optionals x11Support [
    ueberzug
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Image previews for lf (list files) file manager";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
