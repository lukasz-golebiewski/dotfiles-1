# Part of this comes from
# https://gist.github.com/walkermalling/23cf138432aee9d36cf59ff5b63a2a58

{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # See https://github.com/mozilla/nixpkgs-mozilla/issues/51#issue-245576627
  environment.pathsToLink = [ "/lib/rustlib/src" ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/836ae1c1-cfb6-4e3d-866e-21a90fbfe56a";
      preLVM = true;
    };
  };

  # acpi_call is necessart for tlp to work on Thinkpads
  boot.kernelModules = [ "acpi_call" "kvm-amd" "kvm-intel" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Prevent the sound card from draining the battery:
  # https://askubuntu.com/questions/229204/audio-codec-consuming-high-battery-power
  # https://www.kernel.org/doc/html/latest/sound/designs/powersave.html
  #
  #     boot.extraModprobeConfig = "options snd_hda_intel power_save=1 power_save_controller=Y";
  #
  # Unfortunately extraModprobeConfig does not work properly so we use the
  # kernel params instead. See: https://github.com/NixOS/nixpkgs/issues/20906
  boot.kernelParams =
    [ "snd_hda_intel.power_save=1" "snd_hda_intel.power_save_controller=Y" ];

  networking.hostName = "xain-laptop";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  time.timeZone = "Europe/Berlin";

  # See https://nixos.wiki/wiki/Intel_Graphics
  # environment.variables = { MESA_LOADER_DRIVER_OVERRIDE = "iris"; };
  hardware.opengl.enable = true;
  # hardware.opengl.package = (pkgs.mesa.override {
  #   galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  # }).drivers;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  environment.etc.currentconfig.source = ./.;

  # Just the bare minimum: we use home-manager for this
  environment.systemPackages = with pkgs; [ neovim git tlp powertop ];

  # power saving
  services.tlp.enable = true;
  # power usage monitoring
  powerManagement.powertop.enable = true;

  services.sshd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplip
    hplipWithPlugin
    samsungUnifiedLinuxDriver
    splix
    brlaser
    brgenml1lpr
    brgenml1cupswrapper
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome3.enable = true;

  services = {
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };

  # PostgresSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    enableTCPIP = true;
    initialScript = pkgs.writeText "backend-initScript" ''
      -- By default we use ident auth, so we want to create a role for ourself
      CREATE ROLE "little-dude" WITH LOGIN CREATEDB;
      -- Create a default db with our name, so that we can just login with `psql`
      CREATE DATABASE "little-dude";
      -- No idea what the default password is on NixOS for postgres, so we set it here
      ALTER USER postgres PASSWORD 'postgres';
    '';
    # Note that because we use "Ident auth" for local connection, `psql -U postgres` does work: we need to be logged in as `postgres` first. By default a `postgres` user is created on the system but no
    # password is set, so we have to `su` our way in: `sudo -u postgres psql`.
    #
    # See: https://github.com/NixOS/nixpkgs/blob/3ba3d8d8cbec36605095d3a30ff6b82902af289c/nixos/modules/services/databases/postgresql.nix#L190
    #
    # Otherwise we can log in via TCP with: `psql postgresql://postgres:postgres@localhost:5432/`
  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Docker. See: https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;

  # To communicate with android. See: https://nixos.wiki/wiki/Android#adb_setup
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."little-dude" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "adbusers" ];
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  virtualisation.libvirtd.enable = true;
}

