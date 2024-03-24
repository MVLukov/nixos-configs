# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking = {
    firewall.enable = true;
    hostName = "nixos-base";
    interfaces = {
    enp6s18 = {
      useDHCP = false;
      ipv4.addresses = [ {
        address = "192.168.0.70";
        prefixLength = 20;
        } ];
      };
    };
    defaultGateway = "192.168.0.1";
  };

  time.timeZone = "Europe/Sofia";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    btop
    fish
    neofetch
  ];
  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  users.users.user = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
     initialPassword = "123456";
     packages = with pkgs; [
     ];
   };

   nix.gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 7d";
   };

  #programs
  programs.fish.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  programs.bash = {
  interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
    '';
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

