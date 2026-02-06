# switch:
#     sudo nixos-rebuild switch
# help:
#     man configuration.nix
#     nixos-help

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  minimal = false;
in
{
  imports = [
    ./disko.nix
    #./8bitdo.nix
    ../../modules/system/auto-upgrade.nix
    ../../modules/system/gc.nix
    ../../modules/system/nixvim.nix
    ../../modules/system/tailscale.nix
    inputs.minegrub-world-sel-theme.nixosModules.default
    inputs.minecraft-plymouth-theme.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.nixvim.nixosModules.nixvim
    inputs.vscode-server.nixosModules.default
  ];

  programs.nix-ld.enable = true;
  services.vscode-server.enable = true;

  boot.plymouth = {
    enable = true;
    plymouth-minecraft-theme.enable = true;
  };
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.bates64 = ../../modules/home/profiles/desktop.nix;
    backupCommand = "rm";
    extraSpecialArgs = { inherit inputs; };
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev"; # EFI only
    enableCryptodisk = true;
    minegrub-world-sel = {
      enable = true;
      customIcons = [
        {
          name = "nixos";
          lineTop = "NixOS";
          lineBottom = "Spectator Mode, Cheats";
          customImg = builtins.path {
            path = ./nixos-logo.png;
            name = "nixos-img";
          };
        }
      ];
    };
  };

  boot.initrd.systemd.enable = true;
  boot.initrd.luks.fido2Support = false; # disko does it with crypttab
  boot.initrd.systemd.fido2.enable = true;

  networking.hostName = "merlon"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.enableAllFirmware = true; # Enable proprietary firmware for things like WiFi cards

  hardware.bluetooth = lib.mkIf (!minimal) {
    enable = true;
    powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = !minimal;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
  services.pipewire = lib.mkIf (!minimal) {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    # https://discourse.nixos.org/t/strange-audio-issues-after-updating/57098/7
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 2048;
        "default.clock.max-quantum" = 8192;
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker.enable = !minimal;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bates64 = {
    isNormalUser = true;
    description = "Alex Bates";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "audio"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      unofficial-homestuck-collection
      prismlauncher
    ];
    initialPassword = ""; # change me
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "ca-derivations"
  ];

  nix.settings.trusted-users = [
    "root"
    "bates64"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    busybox
    zsh
    vulkan-loader
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enable OpenGL
  hardware.graphics.enable = !minimal;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
    intel-vaapi-driver
    libva-vdpau-driver
    vulkan-tools
    vulkan-validation-layers
  ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = lib.mkIf (!minimal) [ "nvidia" ];

  hardware.nvidia = lib.mkIf (!minimal) {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true; # Fixes tearing
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.extraModulePackages =
    with config.boot.kernelPackages;
    lib.mkIf (!minimal) [
      nvidia_x11
      ddcci-driver # for brightness control
    ];

  powerManagement.enable = !minimal; # For sleep and hibernate

  # Start niri via GDM
  programs.niri.enable = true;
  services.getty = {
    autologinUser = "bates64";
    autologinOnce = true;
  };
  services.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
      autoSuspend = false;
    };
  };
  security.pam.services.swaylock = { };

  # Hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Fix cursor not showing on wayland+nvidia
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  # For solaar
  hardware.logitech.wireless.enable = !minimal;

  # Casting
  services.avahi.enable = !minimal;

  programs.steam = lib.mkIf (!minimal) {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;
}
