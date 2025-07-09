{config, pkgs, ...}:

{
  # enable flatpak
  services.flatpak.enable = true;

  # install threema
  system.userActivationScripts.flatpak-install-threema = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ${pkgs.flatpak}/bin/flatpak install --user -y --noninteractive https://releases.threema.ch/flatpak/threema-desktop/ch.threema.threema-desktop.flatpakref || true
    ${pkgs.flatpak}/bin/flatpak update --user -y ch.threema.threema-desktop
  '';

  system.userActivationScripts.flatpak-override-threema = ''
    ${pkgs.flatpak}/bin/flatpak override --user ch.threema.threema-desktop --filesystem=host
  '';
}