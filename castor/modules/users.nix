{ config, pkgs, ... }:

{
  users.users.tim = {
    isNormalUser = true;
    description = "Tim";
    extraGroups = [ "wheel" "networkmanager" "users" ];
    shell = pkgs.bash;
    hashedPassword = "$6$SWEvIAF63INqJAf/$l8WQOO8uNRCw9SWlcQpmXiKFXMPfH7PkqZXa028IYMcQaAzgukn.UQFWcAKCnFD1BkVwMDQ4CBY8MVoz7D3La1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIxLHrkuK4U5UUbtVPUolts0Ob7iuh7KhBRQ941T2i3 tim_nixos@ttschnz"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIJodGhHEQOni20lLu3D8FnkD+m26LAGQ+NITnsf0R7BKRgdiSGj4DcT1s8QwjN4bBzc3iL8ULCOl29LBN1AT33ZmaBnj6iLZOdN/o3EmpQ+0dXqgVtxNaJIJudNt/dW4hDMU0a5gFmJFCTxIEux8R5WK929efOaa5D7g+vrVkCqlsRmMf977/+jstVlgMyE1GG8Rw6qbinEUlJZOgBgDo1IhPvLLPFI2+b/U20JpGcSpYBR/xUFLhL1Zpi1HvkFjOgSNLBbacWtDGdpeZ22Og7ulv+gyIGo8Gx/38Sojx0JZQjM6wwf+j0MyZIiZJdHSFP66KfxzljdU4gGY4NEzrdEebRetnV1yZ1lV9E0EmLLQZ0phWEhmijKTi26FXZe5zXYa6d2f0XIQ0QzdNiL+QClMTxq3QVz8sgKJyQote4P5WasZKuqiMFIhGT3T9RI54VC9QPwN+oquCQblH/OxRRH5YZxS98uCTYOyefjpLYc8PD56K3Dte5Co6MZOrWnk= tim\\tim@tim"
    ];
  };
  
  security.sudo.wheelNeedsPassword = false;
}
