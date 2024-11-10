{
  system.autoUpgrade = {
    enable = true;
    flake = "github:bates64/nixfiles/main";
    flags = [
      "--update-input" # deprecated, see https://github.com/NixOS/nixpkgs/issues/349734
      "nixpkgs"
      "-L" # print build logs
    ];
    allowReboot = true;
    rebootWindow = { lower = "03:00"; upper = "06:00"; };
  };
}
