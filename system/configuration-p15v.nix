# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
 {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
boot.loader.grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };

    boot.initrd.luks.devices.crypted = {
      device = "/dev/disk/by-uuid/195bcf1c-bafa-4077-b406-cefdc03804b5";
      preLVM = true;
    };
  boot = {
    # try to disable the bell
    blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
    kernelModules = [
      # for tlp to work on Thinkpads
      "acpi_call"
      # for virtualization
      "kvm-intel"
      # for virtualization too (we disable netfilter on libvirt bridged networks, see the sysctl params below)
      "br_netfilter"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelPackages = pkgs.linuxPackages_latest;

    # Note that to configure kernel module, we there's extraModprobeConfig:
    #
    #     extraModprobeConfig = "options snd_hda_intel power_save=1 power_save_controller=Y";
    #
    # but it doesn't seem to work. See also: https://github.com/NixOS/nixpkgs/issues/20906.
    # Therefore we use kernel command line parameters instead.
    kernelParams = [
      # Prevent the sound card from draining the battery:
      # https://askubuntu.com/questions/229204/audio-codec-consuming-high-battery-power
      # https://www.kernel.org/doc/html/latest/sound/designs/powersave.html
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.power_save_controller=Y"
      # Clicks are not detected correctly otherwise. See: https://discourse.nixos.org/t/touchpad-click-not-working/12276
      "psmouse.synaptics_intertouch=0"
    ];

    kernel.sysctl = {
      # Disable netfilter. This is necessary for libvirt bridged networks,
      # since we want to allow all traffic to be forwarded to the bridge
      # See:
      # https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm
      # Note that these settings require the `br_netfilter` module to be loaded.
      "net.bridge.bridge-nf-call-ip6tables" = 0;
      "net.bridge.bridge-nf-call-iptables" = 0;
      "net.bridge.bridge-nf-call-arptables" = 0;
    };
  };

  networking = {
    hostName = "thinpad-p15v";
    extraHosts = let
      hostsPath =
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      hostsFile = builtins.fetchurl hostsPath;
    in builtins.readFile "${hostsFile}";
  };

  time.timeZone = "Europe/Berlin";

  environment = {
    # Just the bare minimum: we use home-manager for this
    systemPackages = with pkgs; [ neovim git tlp powertop ];
  };

  # power saving
  # services.tlp.enable = true;
  # power usage monitoring
  powerManagement.powertop.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
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
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    # Gnome
    displayManager.gdm = {
        enable = true;
	# Teams cannot do screensharing with Wayland so fallback to Xorg
	wayland = false;
    };
    desktopManager.gnome.enable = true;

    # videoDrivers = [ "modesetting" "nvidia" ];

    libinput.enable = true;
    # Tried to configure the touchpad here, but this crashes xserver:
    # inputClassSections = [''
    #   Identifier "Synaptics TM3471-020"
    #   Driver "libinput"
    #   MatchIsTouchpad "on"
    #   Device "/dev/input/event*"
    #   Option "AccelProfille"        "adaptive,flat"
    #   Option "ClickMethod"          "buttonareas,clickfinger"
    #   Option "DisableWhileTyping"   "true"
    #   Option "HorizontalScrolling"  "true"
    #   Option "LeftHanded"           "false"
    #   Option "MiddleEmulation"      "false"
    #   Option "NaturalScrolling"     "false"
    #   Option "ScrollMethod"         "twofinger,edge"
    #   Option "SendEventsMode"       "enabled"
    #   Option "Tapping"              "true"
    #   Option "TappingDrag"          "true"
    # ''];
  };

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
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

  services.sshd.enable = false;

  # Docker. See: https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;

  # To communicate with android. See: https://nixos.wiki/wiki/Android#adb_setup
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."little-dude" = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" "docker" "adbusers" "libvirtd" ];
    shell = pkgs.zsh;
  };

  users.groups = { users = { gid = 100; }; };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  # List of hosts entries to configure in /etc/nsswitch.conf. Note that "files"
  # is always prepended, and "dns" and "myhostname" are always appended. This
  # option only takes effect if nscd is enabled.
  #
  # Adding libvirt allows us to ssh into VMs using their hostname. See:
  # https://wiki.archlinux.org/index.php/Libvirt#Access_virtual_machines_using_their_hostnames
  system.nssDatabases.hosts = [ "libvirt" "libvirt_guest" ];

  virtualisation.libvirtd.enable = true;

}

