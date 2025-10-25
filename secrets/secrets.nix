{ config, pkgs, ... }:
{  
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/keys/id_ed25519" = { 
      owner = config.users.users.tim.name;
      group = config.users.users.tim.group;
      mode = "0600";
    };
    "ssh/keys/id_ed25519_pub" = {
      owner = config.users.users.tim.name;
      group = config.users.users.tim.group;
      value = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIxLHrkuK4U5UUbtVPUolts0Ob7iuh7KhBRQ941T2i3 tim_nixos@ttschnz"; 
    };
    "ssh/keys/id_rsa" = { 
      owner = config.users.users.tim.name;
      group = config.users.users.tim.group;
      mode = "0600";
    };
    "ssh/keys/id_rsa_pub" = { 
      owner = config.users.users.tim.name;
      group = config.users.users.tim.group;
      value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIJodGhHEQOni20lLu3D8FnkD+m26LAGQ+NITnsf0R7BKRgdiSGj4DcT1s8QwjN4bBzc3iL8ULCOl29LBN1AT33ZmaBnj6iLZOdN/o3EmpQ+0dXqgVtxNaJIJudNt/dW4hDMU0a5gFmJFCTxIEux8R5WK929efOaa5D7g+vrVkCqlsRmMf977/+jstVlgMyE1GG8Rw6qbinEUlJZOgBgDo1IhPvLLPFI2+b/U20JpGcSpYBR/xUFLhL1Zpi1HvkFjOgSNLBbacWtDGdpeZ22Og7ulv+gyIGo8Gx/38Sojx0JZQjM6wwf+j0MyZIiZJdHSFP66KfxzljdU4gGY4NEzrdEebRetnV1yZ1lV9E0EmLLQZ0phWEhmijKTi26FXZe5zXYa6d2f0XIQ0QzdNiL+QClMTxq3QVz8sgKJyQote4P5WasZKuqiMFIhGT3T9RI54VC9QPwN+oquCQblH/OxRRH5YZxS98uCTYOyefjpLYc8PD56K3Dte5Co6MZOrWnk= tim\tim@tim"; 
    };
    "syncthing/pixel6a" = { value = null; };
    "syncthing/samsungtab" = { value = null; };
    "syncthing/web_gui_password" = { value = null; };
    "git/name" = { value = null; };
    "git/email" = { value = null; };
    "vpn_credentials" = { 
      owner = config.users.users.tim.name;
      group = config.users.users.tim.group;
    };
    "2fa_credentials" = { 
      owner = config.users.users.tim.name;
      group = config.users.users.tim.group;
      mode = "400";
    };
    "printer_epfl_printerserver" = { value = null; };
  };
}
