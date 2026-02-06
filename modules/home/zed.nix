{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    rustup
    nixfmt-rfc-style
    nodejs
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "lua"
      "starlark" # for Bazel
    ];
    userSettings = {
      #server_url = "https://disable-zed-downloads.invalid"; # https://github.com/zed-industries/zed/issues/12589
      agent = {
        enabled = true;
      };

      node = {
        path = "node";
        npm_path = "npm";
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
          formatter.external.command = "nixfmt";
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
            path = "rust-analyzer";
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
            path = "clangd";
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
      relative_line_numbers = "disabled";

      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      theme = {
        mode = "dark";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      project_panel.dock = "right";
      ui_font_family = "FiraCode Nerd Font Mono";
      ui_font_size = 13;
      buffer_font_family = "FiraCode Nerd Font Mono";
      buffer_font_size = 13;

      wrap_guides = [
        80
        100
        120
      ];
    };
    installRemoteServer = true;
  };

  programs.zsh.shellAliases.zed = "zeditor";
}
