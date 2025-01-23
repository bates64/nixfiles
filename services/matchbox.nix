# Matchbox server for papermario-dx networking
{ pkgs, ... }:
let
  pkg = pkgs.rustPlatform.buildRustPackage rec {
    pname = "matchbox_server";
    version = "0.11.0";
    src = pkgs.fetchFromGitHub {
      owner = "johanhelsing";
      repo = "matchbox";
      rev = "v${version}";
      hash = "sha256-fF6SeZhfOkyK1hAWxdcXjf6P6pVJWLlkIUtyGxVrm94=";
    };
    buildAndTestSubdir = "matchbox_server";
    cargoHash = "sha256-yNwfSL81ONhW1sQJOx2YHUR1X8mEHCvebc6Qvbx0oLI=";
  };
in {
  systemd.services.matchbox = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Matchbox Signalling Server";
    script = ''
      ${pkg}/bin/matchbox_server
    '';
    serviceConfig = {
      Type = "simple";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 3536 ];
    allowedUDPPorts = [ 3536 ];
  };
}
