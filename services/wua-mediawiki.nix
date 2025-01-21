{ pkgs, ... }:
let
  hostName = "wiki.wishuponabyss.com";
  port = 8080;
in {
  networking.extraHosts = ''
    127.0.0.1 ${hostName}
    ::1 ${hostName}
  '';
  services.nginx.virtualHosts.${hostName} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
    };
  };
  services.mediawiki = {
    enable = true;
    name = "Wish Upon Abyss Wiki";
    url = "https://${hostName}";
    httpd.virtualHost = {
      listen = [
        {
          ip = "127.0.0.1";
          inherit port;
          ssl = false;
        }
      ];
      extraConfig = ''
        <Directory "/">
          RewriteEngine On
          RewriteBase /

          RewriteRule ^/*$ /index.php?title=Main_Page [L]

          RewriteCond %{REQUEST_FILENAME} !-f
          RewriteCond %{REQUEST_FILENAME} !-d
          RewriteCond %{REQUEST_URI} !^/images/
          RewriteRule ^(.*) /index.php/$1 [L,QSA]
          
          RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
          RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
          RewriteCond %{REQUEST_URI} !^/images/
          RewriteRule ^(?:(?!rest.php/).)*$ %{DOCUMENT_ROOT}/index.php [L]
          RewriteRule ^/*$ %{DOCUMENT_ROOT}/index.php [L]
        </Directory>
      '';
    };
    passwordFile = pkgs.writeText "password" "maverick-skyline-conclude"; # Initial password
    passwordSender = "alex@bates64.com";
    extraConfig = ''
      # SMTP doesn't work
      $wgEnableEmail = false;

      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;

      $wgArticlePath = "/$1";

      # TEMP (remove on release)
      $wgGroupPermissions['*']['read'] = false;
      $wgGroupPermissions['*']['createaccount'] = false;

      # VisualEditor
      $wgGroupPermissions['user']['writeapi'] = true;
      $wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

      $wgScribuntoDefaultEngine = 'luastandalone';
      $wgScribuntoEngineConf['luastandalone']['luaPath'] = '${pkgs.lua51Packages.lua}/bin/lua';

      //error_reporting( -1 );
      //ini_set( 'display_errors', 1 );
      //$wgShowExceptionDetails = true;
      //$wgShowDBErrorBacktrace = true;

      $wgLogo = $wgScriptPath . '/images/2/2a/Logotype_In-game.png';

      $wgDiscordWebhookURL = 'https://discord.com/api/webhooks/1272697078664921170/AyTu1joCZW5961jNsg-nCcRemVknhW0y_XhCKQ3HATEo1cVYjNs5d22MktzICb4PbnCv';
    '';
    extensions = {
      VisualEditor = null;
      Scribunto = null;
      PageImages = null;
      TextExtracts = null;
      Discord = pkgs.fetchFromGitHub {
        owner = "jaydenkieran";
        repo = "mw-discord";
        rev = "67b73e8807f2657de908bc666c06c6b227660312";
        hash = "sha256-mZqBMNagEAbCcAsTygtGaxpSbIaXkqrGbn5g7zkw1Yw=";
      };
      PortableInfobox = pkgs.fetchFromGitHub {
        owner = "Universal-Omega";
        repo = "PortableInfobox";
        rev = "c592fe319e4ecba6ef1d0d47a1956a2c2714f336";
        hash = "sha256-ZZsT/HzYcLTPvKrXjixEaQYX4W1Hld7O0PSk+0xN0nk=";
      };
      TemplateStyles = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-master-af59ace.tar.gz";
        hash = "sha256-BnLzcNGySQhzXbiyq4Y3Qd/Ri1+rKrMsHu65LWSoInw=";
      };
      Loops = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/Loops-master-3d722d6.tar.gz";
        hash = "sha256-VzCpAsqynmbKdTWAw+BAjVRV+UeHUMk14vQ+SEmDn2g=";
      };
      Popups = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/Popups-master-2d7cce7.tar.gz";
        hash = "sha256-eHwKVAV5xjSc7GqkGch2ZX9hkm74ztsQ7PZHF3HHXX4=";
      };
      CodeMirror = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-master-75710d6.tar.gz";
        hash = "sha256-NQ+vkEO3eLEfEmwsU8/Z0KBktY8KXMEuV0Ek543X60I=";
      };
    };
  };
}
