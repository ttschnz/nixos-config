{ lib
, fetchurl
, appimageTools
, makeDesktopItem
, openssl_1_1
}:

let
  pname = "n-link";
  version = "0.1.6";

  src = fetchurl {
    url = "https://github.com/lights0123/n-link/releases/download/v${version}/desktop_${version}_amd64.AppImage";
    sha256 = "r7dVxoiDw8nns0WPw3LUiCtID2ZDgiAGF1eYIq7iKnA=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "n-link";
    exec = pname;
    comment = "n-link desktop application";
    categories = [ "Utility" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    openssl_1_1
    webkitgtk_4_1
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    install -m644 ${desktopItem}/share/applications/*.desktop \
      $out/share/applications/
  '';

  meta = with lib; {
    description = "n-link desktop application";
    homepage = "https://github.com/lights0123/n-link";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = pname;
  };
}
