{config, pkgs, ...}:

{
  # enable flatpak
  services.flatpak.enable = true;

  # install bottles
  system.userActivationScripts.flatpak-install-bottles = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ${pkgs.flatpak}/bin/flatpak install flathub com.usebottles.bottles
  '';
}