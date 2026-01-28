{ config, pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ../bates64/cli
    ../bates64/gui
  ];
  config = {
    home.username = "alebat01";
    home.homeDirectory = if config.isMacOS then "/Users/alebat01" else "/home/alebat01";

    programs.git.settings.user.email = "alex.bates@arm.com";
    programs.jujutsu.settings = {
      user.email = "alex.bates@arm.com";
      templates.commit_trailers = ''if(!trailers.contains_key("Change-Id"), format_gerrit_change_id_trailer(self))'';
    };

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;

    programs.zed-editor.userSettings = {
      default_model.provider = "openai";
      language_models.openai.api_url = "https://openai-api-proxy.geo.arm.com/api/providers/openai/v1";

      ssh_connections = [
        {
          host = "pc";
          upload_binary_over_ssh = true;
          projects = [ { paths = [ "/data_nvme1n1/ddk" ]; } ];
        }
      ];
    };

    home.packages = with pkgs; [ bazelisk ];
  };
}
