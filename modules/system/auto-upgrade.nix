{
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://tangled.org/bates64.com/infra";
    flags = [
      "--update-input" # deprecated, see https://github.com/NixOS/nixpkgs/issues/349734
      "nixpkgs"
      "-L" # print build logs
      "--no-write-lock-file"
    ];
    allowReboot = false;
    rebootWindow = {
      lower = "03:00";
      upper = "06:00";
    };
  };
}
