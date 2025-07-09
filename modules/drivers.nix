{ config, pkgs, ... }:

{
  # enable hardware accelerated graphics drivers
  # used by rust three_d crate & development. 
  hardware.graphics.enable = true;
}