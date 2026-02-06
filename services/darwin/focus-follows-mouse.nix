{
  config,
  lib,
  pkgs,
  ...
}:
let
  autoraise = pkgs.autoraise.overrideAttrs (old: {
    buildPhase = ''
      runHook preBuild
      $CXX -std=c++03 -fobjc-arc -D"NS_FORMAT_ARGUMENT(A)=" -D"SKYLIGHT_AVAILABLE=1" -DEXPERIMENTAL_FOCUS_FIRST -o AutoRaise AutoRaise.mm -framework AppKit -framework SkyLight
      bash create-app-bundle.sh
      runHook postBuild
    '';
  });
in
{
  environment.systemPackages = [ autoraise ];

  launchd.user.agents.autoraise = {
    command = "${autoraise}/bin/autoraise -delay 0 -focusDelay 1";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/autoraise.log";
      StandardErrorPath = "/tmp/autoraise.err.log";
    };
  };
}
