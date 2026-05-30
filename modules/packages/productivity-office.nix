{ pkgs, ... }: with pkgs; [
  authenticator
  dialect
  pdfarranger
  folio
  iplan
  warp # sharing files over wormhole protocol
  papers # gnome pdf viewer
  kdePackages.okular # kde pdf viewer
  obsidian
  foliate
  libreoffice-still
  notion-app-enhanced
  anki
  musescore
  # moon # build error at 1.41.8. current version is 2.2.6
  sql-studio
  sqlite
  teams-for-linux
  omnissa-horizon-client
  viking
  (callPackage ./n-link.nix {})
]