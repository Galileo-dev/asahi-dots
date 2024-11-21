{ pkgs, ... }:

let
  # The dotfiles are located at the root of the flake
  dotfilesPath = ./.;

  # Your username and home directory
  username = "fionnbarrett"; # Replace with your actual username
  homeDirectory = "/home/${username}"; # Adjust if necessary

  # List of directories inside .config to symlink

  configDirs = [
    # Window Management
    "hypr" "zellij" "rofi" "Thunar"

    # Shells
    "fish" "nushell"

    # Editors
    "kitty" "helix" "nvim"

    # UI/Theme
    "Kvantum" "qt5ct" "qt6ct" "gtk-2.0" "gtk-3.0" "gtk-4.0" "nwg-look"

    # System Tools
    "btop" "cava" "bat" "nix" "yazelix"
  ];

  
  # Function to create symlinked directories
  symlinkConfigDir = dir: {
    name = ".config/${dir}";
    value = {
      source = "${dotfilesPath}/.config/${dir}";
      recursive = true;
    };
  };

in
{
  # Specify the Home Manager state version
  home.stateVersion = "24.05";
 
  # Set your username and home directory
  home.username = username;
  home.homeDirectory = homeDirectory;

  # Enable Home Manager itself
  programs.home-manager.enable = true;

  # Symlink files and directories into your home directory
  home.file =
    # Symlink the .icons directory (copied instead of symlinking)
    {
      ".icons" = {
        source = "${dotfilesPath}/.icons";
        recursive = true;
      };
      # Symlink the .local/bin directory
      ".local/bin" = {
        source = "${dotfilesPath}/.local/bin";
        recursive = true;
      };
    }
    # Symlink the listed .config directories
    // builtins.listToAttrs (map symlinkConfigDir configDirs)
    // {
      # Symlink individual files in .config
      ".config/starship.toml" = {
        source = "${dotfilesPath}/.config/starship.toml";
      };
      # For applications like VSCode, only symlink specific settings files
      ".config/VSCodium/User/settings.json" = {
        source = "${dotfilesPath}/.config/VSCodium/User/settings.json";
      };
      ".config/VSCodium/User/keybindings.json" = {
        source = "${dotfilesPath}/.config/VSCodium/User/keybindings.json";
      };
    };

  # Set environment variable to specify cache directory
  home.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  # Enable Fish Shell and set as default shell
  programs.fish = {
    enable = true;
  };
}

