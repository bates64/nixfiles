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
        url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_42-06a2587.tar.gz";
        hash = "sha256-JJNT8ClWAwFCs8de9kQ3RyQ3T/9l6nIJQH7OWUrNuUE=";
      };
      Loops = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/Loops-REL1_42-47718f0.tar.gz";
        hash = "sha256-MQpmx/7gxx11o4UYLkrScJH4xlrgrvJgxBTwldTsAoE=";
      };
      Popups = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/Popups-REL1_42-a970651.tar.gz";
        hash = "sha256-X/pGGDH3u/QiLsLAftrjadXtS7m8pTIE6PkrCnathT8=";
      };
      CodeMirror = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_42-29c214e.tar.gz";
        hash = "sha256-y3ElEGPMOnCN4IhnF84RPvr9zBwDGdIDXCgh6lsAwFQ=";
      };
      Interwiki = pkgs.fetchzip {
        url = "Interwiki-REL1_42-fbccb35.tar.gz";
        hash = "sha256-y3ElEGPMOnCN4IhnF84RPvr9zBwDGdIDXCgh6lsAwFQ=";
      };
    };
  };
}
