{
  system.autoUpgrade = {
    enable = true;
    flake = "github:bates64/nixfiles/main";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    allowReboot = true;
    rebootWindow = { lower = "03:00"; upper = "06:00"; };
  };
}
