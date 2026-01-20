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
  moon
  sql-studio
  sqlite
  (callPackage ./n-link.nix {})
]