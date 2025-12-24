
{config, pkgs, ...}:

{
  # enable flatpak
  services.flatpak.enable = true;

  # install audiveris
  system.userActivationScripts.flatpak-install-audiveris = ''
    ${pkgs.flatpak}/bin/flatpak install --user -y --nointeractive flathub org.audiveris.audiveris || true
    ${pkgs.flatpak}/bin/flatpak update --user -y org.audiveris.audiveris
  '';

  # allow audiveris access to the download folder
  system.userActivationScripts.flatpak-override-audiveris = ''
    ${pkgs.flatpak}/bin/flatpak override --user org.audiveris.audiveris --filesystem=xdg-download
  '';
}