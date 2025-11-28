{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "lua"
    ];
    userSettings = {
      #server_url = "https://disable-zed-downloads.invalid"; # https://github.com/zed-industries/zed/issues/12589
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;
        ### PROVIDER OPTIONS
        ### zed.dev models { claude-3-5-sonnet-latest } requires github connected
        ### anthropic models { claude-3-5-sonnet-latest claude-3-haiku-latest claude-3-opus-latest  } requires API_KEY
        ### copilot_chat models { gpt-4o gpt-4 gpt-3.5-turbo o1-preview } requires github connected
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      #hour_format = "hour24";
      auto_update = false;
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        font_family = "FiraCode Nerd Font Mono";
        font_features = null;
        font_size = null;
        shell = "system";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };
      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external.command = lib.getExe pkgs.nixfmt-rfc-style;
        };
        Lua = {
          formatter = "language_server";
          inlay_hints = {
            enabled = true;
            show_type_hints = true;
            show_parameter_hints = true;
            show_other_hints = true;
          };
        };
      };
      lsp = {
        rust-analyzer = {
          binary = {
            path = lib.getExe pkgs.rust-analyzer;
          };
          initialization_options.check.command = "clippy";
        };
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        clangd = {
          binary = {
            path = "${pkgs.clang-tools}/bin/clangd";
            arguments = [
              "--background-index"
              "--background-index-priority=background"
              "--clang-tidy"
              "--header-insertion=iwyu"
              "--header-insertion-decorators"
              "--experimental-modules-support"
              "--rename-file-limit=0"
              "--enable-config"
              "--query-driver=/nix/store/**/*"
            ];
          };
          initialization_options = {
            fallbackFlags = [
              "-std=c++20"
              "-std=c11"
            ];
          };
        };
      };

      vim_mode = false;
      relative_line_numbers = false;

      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      project_panel.dock = "right";
      #ui_font_family = "FiraCode Nerd Font Mono";
      ui_font_size = 13;
      buffer_font_family = "FiraCode Nerd Font Mono";
      buffer_font_size = 13;

      wrap_guides = [
        80
        120
      ];
    };
  };

  # https://wiki.nixos.org/wiki/Zed#Remote_Server
  # note: client and server versions must match
  home.file.".zed_server".source = "${pkgs.zed-editor.remote_server}/bin";

  programs.zsh.shellAliases.zed = "zeditor";
}
