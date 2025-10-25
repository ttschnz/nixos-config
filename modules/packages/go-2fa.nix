{config, pkgs, ...}:

{
  # link .2fa in homedir from credentials (readonly)
  system.userActivationScripts.add_2fa = ''
    ln -sf ${config.sops.secrets."2fa_credentials".path} ${config.users.users.tim.home}/.2fa
  '';
  packages = [pkgs.go-2fa];
}