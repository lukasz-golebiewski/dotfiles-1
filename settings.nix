# {
#    user = "little-dude";
#    role = "vm";
#    workdir = "$HOME/code";
#    isNixOS = false;
# }

{
  user = "little-dude";
  role = "nixos";
  workdir = "/data/work";
  isNixOS = true;
}
