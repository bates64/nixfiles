{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./disko.nix
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
  ];

  # Hardware
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
    "consoleblank=60"
  ];
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.logind.settings.Login.HandleLidSwitch = "ignore";

  networking.hostName = "watt";

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = true; # for rescue
  };

  users.users.bates64 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsDTVCIkcFjkaDm5RoWG1uSNJBanUWGmoKHIRHvSsQq alex@bates64.com"
    ];
    shell = pkgs.zsh;
  };

  # Not publicly accessible, so disable firewall.
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  programs.zsh.enable = true;
  programs.zsh.loginShellInit = ''
    ${lib.getExe pkgs.chafa} --format=kitty --clear --scale=4 --align top,mid ${./host.png}
  '';

  # Reduce size of image
  nix.settings.auto-optimise-store = true;
  documentation.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
