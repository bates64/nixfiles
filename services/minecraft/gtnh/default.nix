{ pkgs, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  services.minecraft-servers.servers.gtnh = {
    enable = true;
    enableReload = true;
    package = pkgs.callPackage ./gtnh.nix { };
    jvmOpts = "-Xms3G -Xmx3G -Dfml.readTimeout=180";
    whitelist = import ../whitelist.nix;
    serverProperties = {
      level-type = "rwg";
      difficulty = 2;
      spawn-protection = 0;
      server-port = 25565;
      online-mode = true;
      white-list = true;
      motd = "Greg\\u00f3rio T\\u00e9cnico: Novidades Horizontais";
      max-tick-time = 60000; # 1 minute
    };
  };
}
