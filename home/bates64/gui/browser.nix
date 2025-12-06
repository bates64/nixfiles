{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # TODO: remove once happy with zen
  programs.firefox.enable = !config.isMacOS; # currently broken on darwin (package.meta.badPlatforms)

  programs.zen-browser = {
    enable = true;
    darwinDefaultsId = "app.zen-browser.zen";
    nativeMessagingHosts = lib.mkIf (!config.isMacOS) [ pkgs.firefoxpwa ];
    policies =
      let
        mkLockedAttrs = builtins.mapAttrs (
          _: value: {
            Value = value;
            Status = "locked";
          }
        );
      in
      {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = false; # Telemetry is Good, actually
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Preferences = mkLockedAttrs {
          # Behaviour
          "browser.aboutConfig.showWarning" = false;
          "zen.updates.show-update-notification" = false;
          "zen.welcome-screen.seen" = true;
          "zen.workspaces.open-new-tab-if-last-unpinned-tab-is-closed" = true;
          "zen.workspaces.continue-where-left-off" = true;

          # Privacy
          "dom.security.https_only_mode" = true;
          "network.trr.mode" = 5; # Always use DNS-over-HTTPS over Cloudflare

          # Theme
          "zen.tabs.show-newtab-vertical" = false;
          "zen.view.use-single-toolbar" = false;
          "zen.urlbar.show-domain-only-in-sidebar" = false;
          "zen.urlbar.single-toolbar-show-copy-url" = false;
          "zen.watermark.enabled" = false;
        };
      };
    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        bitwarden
        kagi-search

        # Privacy
        ublock-origin
        decentraleyes
        facebook-container
        historyblock
        consent-o-matic
        clearurls

        # Improvements
        sponsorblock
        catppuccin-web-file-icons
        steam-database
        unpaywall

        # Fixes
        don-t-fuck-with-paste
      ];
      containersForce = true;
      containers = {
        Personal = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "blue";
          icon = "briefcase";
          id = 2;
        };
        # Facebook container extension
        Facebook = {
          color = "toolbar";
          icon = "fence";
          id = 6;
        };
      };
      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles.default.containers;
        in
        {
          Personal = {
            id = "c6de089c-410d-4206-961d-ab11f988d40a";
            position = 1000;
            container = containers.Personal.id;
          };
          Work = {
            id = "cdd10fab-4fc5-494b-9041-325e5759195b";
            position = 2000;
            container = containers.Work.id;
          };
        };
    };
  };

  xdg.mimeApps =
    let
      value = config.programs.zen-browser.package.meta.desktopFileName;
      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name value;
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };
}
