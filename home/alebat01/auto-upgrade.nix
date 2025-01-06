{ pkgs, ... }: {
  systemd.user = {
    timers.home-manager-auto-upgrade = {
      Unit.Description = "Home Manager upgrade timer";

      Install.WantedBy = [ "timers.target" ];

      Timer = {
        OnCalendar = "*-*-* 04:40:00";
        Unit = "home-manager-auto-upgrade.service";
        Persistent = true;
      };
    };

    services.home-manager-auto-upgrade = {
      Unit.Description = "Home Manager upgrade";

      # --impure and NIXPKGS_ALLOW_UNFRAME=1 are required due to nixGL; see https://github.com/nix-community/nixGL/issues/90
      Service.ExecStart = toString
        (pkgs.writeShellScript "home-manager-auto-upgrade" ''
          PATH=$PATH:${pkgs.nix}/bin NIXPKGS_ALLOW_UNFREE=1 ${pkgs.home-manager}/bin/home-manager switch --flake github:bates64/nixfiles --impure
        '');
    };
  };
}
