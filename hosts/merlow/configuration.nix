{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "merlow"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bates64 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsDTVCIkcFjkaDm5RoWG1uSNJBanUWGmoKHIRHvSsQq alex@bates64.com"
    ];
  };
  users.users.spchee = {
    isNormalUser = true;
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFA5ZPLnyiC8WnU8qm14WltVrQVMIHG8rRy0IG3OC+VK spchee@k55"
    ];
  };
  users.users.emily = {
    isNormalUser = true;
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNtA6RJe0WsRGMmDzJzu5tbyEg0wCxLsjww1W/pTyiW/3PD5Czyv7tJrjJU/5m971qu+LWd/nN4Ce1KK6qOywsvOqBcixl+O5otxqsDLQ/jBSQLfbR5swCttBS+mBlvzNzdBitAUaNYSpbvdGWG6mwRoX6TMB3FRowrZYdUUvo/wcB2ijxA67b9bwxSkRvcv6xvbUjlTBBZcBf/9WIj+kd0tgiKG+w5hQJxeiadr9bDcBqzxteJJXL6wxB9puEWvhKQpu9CjmfuyQrcKr1FibFYihDXxWg/i14FBWOWWWx7djUGoal4i5sAZXOT6fzurSBG5Fv0kJHNVuQ/ewQr7bwL6qSAzSb5fO4K1FlP4vdS+GU9pg9byVdzxushCUX09pwNao6jg+nJq0caa4PeOviOZ1pWlkZeCXX2NOamk1q1emLaRV9XW/20DZtB57bQ1FfjmpfN3Hs1vnsSbYyUsI0X70I5IpPPFO2whmmXiRw59VHZ1yWjg9eiwFaUR864VE= emily@Firethorn"
    ];
  };
  users.users.agi = {
    isNormalUser = true;
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSgPm3xPWH/Tb2yWC6j23umV1IJJXSDnEFAduXdytjQ6fN6I8h81WSQEJB2b1PRIca45kAN5m6HmCFz1Jht5/r5Np8GZbofHO7BWdnJKgStjjttGxs7lCuYbjXS66+sl5lEaNxvTU26hstV4E2acdnRokcZW8DYqET0Ssm6FY/P2xn4t1JhlbEJNnci2CX8jp6q4f44Vlzqocv/WLT+5gbZvM9PP2CkVU0H3gKyRN6Tllh3fEDYt+86XsQ54upfOLtMvpDkFabIZisdWsJb5QhFbHdqeqcaxGErpKLpuOszeF0iXvkbga4Qmxtlfh1CPi5PKJ5yVteyqGRxWh+AWFsHwPbh15CM4dFpYCQRCJ/Y4EpbKRjTS3jFX7kaGuWHl0wKH+adbnV6CJBmWFpzQaYgfAiZnQ9Vs6DYhP46bk8SMXEZWM9VH//Fv2UsYhD5T/1P01TATHtl0x2Nx8K2xKLgVQpVyDBaRc/adPHMLxFscc7grGd68Zp2xxrguHsq4s= agi@LAPTOP-9RFHQEDO"
    ];
  };
  users.users.eva = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUw/qbJt3LkMvj9bHry1AKfO0eHzfzH0ndoC5ddlZtc elc20@DESKTOP-QBR7O1S"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."bates64.com" = {
    addSSL = true;
    enableACME = true;
    root = "/var/www/bates64.com";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "alex@bates64.com";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Reduce size of image
  nix.settings.auto-optimise-store = true;
  documentation.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
