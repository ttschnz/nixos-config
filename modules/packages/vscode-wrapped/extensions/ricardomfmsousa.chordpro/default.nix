{ lib
, vscode-utils
}:


vscode-utils.extensionFromVscodeMarketplace {
  name = "chordpro";
  publisher = "ricardomfmsousa";
  version = "0.2.0";

  hash = "sha256-A4+aVrdfWiFNUaUrj2hi45Q0zZsgy/Q11ssYClPpjoU=";

  meta = with lib; {
    description = "ChordPro - Provides ChordPro support for Visual Studio Code";
    license = licenses.mit;
    platforms = platforms.all;
  };
}