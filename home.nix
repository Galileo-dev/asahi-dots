{ pkgs, config, ... }:

let
  username = "fionnbarrett"; # Replace with your actual username
  homeDirectory = "/home/${username}";
  dotfilesPath = "${homeDirectory}/hyprdots"; # Adjust if your dotfiles are located elsewhere
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
  };

  # Install packages
  home.packages = with pkgs; [
    fish
    starship
    helix
    nushell
    kitty
    btop
    cava
    rofi
    xfce.thunar
    libsForQt5.qtstyleplugin-kvantum
    bat
    hyprpanel
  ];

  # Symlink files and directories
  home.file = {
    ".icons" = {
      source = "${dotfilesPath}/.icons";
      recursive = true;
      target = "copy"; # Change to 'copy' instead of symlink
    };
    ".local/bin" = { source = "${dotfilesPath}/.local/bin"; recursive = true; };
    ".config/ags" = { source = "${dotfilesPath}/.config/ags"; recursive = true; };
  };

  xdg.configFile = {
    "hypr" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/hypr"; recursive = true; };
    "fish" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/fish"; recursive = true; };
    "kitty" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/kitty"; recursive = true; };
    "btop" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/btop"; recursive = true; };
    "cava" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/cava"; recursive = true; };
    "helix" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/helix"; recursive = true; };
    "nushell" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/nushell"; recursive = true; };
    "rofi" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/rofi"; recursive = true; };
    "Kvantum" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/Kvantum"; recursive = true; };
    "qt5ct" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/qt5ct"; recursive = true; };
    "qt6ct" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/qt6ct"; recursive = true; };
    "Thunar" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/Thunar"; recursive = true; };
    "yazelix" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/yazelix"; recursive = true; };
    "starship.toml" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/starship.toml"; };
    "VSCodium/User/settings.json" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/VSCodium/User/settings.json"; };
    "gtk-2.0/gtkfilechooser.ini" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/gtk-2.0/gtkfilechooser.ini"; };
    "gtk-3.0/settings.ini" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/gtk-3.0/settings.ini"; };
    "gtk-3.0/gtk.css" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/gtk-3.0/gtk.css"; };
    "gtk-3.0/bookmarks" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/gtk-3.0/bookmarks"; };
    "gtk-4.0/gtk.css.bak" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/gtk-4.0/gtk.css.bak"; };
  };

  programs.home-manager.enable = true;
}
