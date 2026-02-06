{ config, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Required for Tailscale
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
