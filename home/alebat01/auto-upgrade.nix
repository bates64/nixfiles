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

      Service.ExecStart = toString
        (pkgs.writeShellScript "home-manager-auto-upgrade" ''
          PATH=$PATH:${pkgs.nix}/bin ${pkgs.home-manager}/bin/home-manager switch --flake github:bates64/nixfiles
        '');
    };
  };
}
