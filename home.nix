{ config, pkgs, lib, ... }:

let
  settings = import ./settings.nix;
  role = ./role + "/${settings.role}.nix";
  user = ./user + "/${settings.user}.nix";
in {
  programs.home-manager.enable = true;
  imports = [
    ./machine/lenovo-x390.nix
    role
    (import user { inherit pkgs lib settings; })
  ];
  home.stateVersion = "21.03";
}
