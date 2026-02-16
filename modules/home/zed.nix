{
  pkgs,
  lib,
  config,
  ...
}:
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
      "catppuccin-icons"
      "nix"
      "toml"
      "xml"
      "kdl"
      "lua"
      "starlark" # for Bazel
      "java"
      "python"
      "git-firefly"
      "glsl"
    ];
    userSettings = {
      #server_url = "https://disable-zed-downloads.invalid"; # https://github.com/zed-industries/zed/issues/12589

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
        jdtls = {
          binary = {
            path = "jdtls"; # provide through devShell
          };
        };
      };

      vim_mode = false;
      relative_line_numbers = "disabled";

      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      icon_theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      title_bar = {
        show_user_picture = false;
        show_onboarding_banner = true;
        show_project_items = true;
        show_branch_name = true;
        show_branch_icon = true;
      };
      tabs = {
        file_icons = true;
        git_status = true;
        show_diagnostics = "errors";
        show_close_button = "hidden"; # middle click
      };
      preview_tabs.enable_preview_from_file_finder = true;
      tab_bar.show_pinned_tabs_in_separate_row = true;

      bottom_dock_layout = "full";

      project_panel = {
        dock = "right";
        hide_root = true;
      };
      git_panel = {
        tree_view = true;
        sort_by_path = true;
      };
      notification_panel.button = false;
      collaboration_panel.button = false;
      agent_panel = {
        dock = "bottom";
        default_height = 600.0;
      };
      agent = {
        enabled = true;
        notify_when_agent_waiting = "never";
        play_sound_when_agent_done = true;
      };

      ui_font_family = "Inter Variable";
      ui_font_size = 13;
      buffer_font_family = "FiraCode Nerd Font Mono";
      buffer_font_size = 11;

      rounded_selection = false;

      wrap_guides = [
        80
        100
        120
      ];
      git.inline_blame.min_column = 80;

      session.trust_all_worktrees = true;

      use_system_prompts = config.isMacOS;
      use_system_path_prompts = config.isMacOS;

      window_decorations = "server";
    };
    installRemoteServer = true;
  };

  programs.zsh.shellAliases.zed = "zeditor";
}
