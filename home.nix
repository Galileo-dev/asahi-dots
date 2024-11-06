
{ pkgs, lib, config, ... }:

let
  username = "fionnbarrett";  # Replace with your actual username
  homeDirectory = "/home/${username}";
  dotfilesPath = "${homeDirectory}/hyprdots";  # Adjust if your dotfiles are located elsewhere
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  # Install packages
  home.packages = with pkgs; [
    fish starship helix nushell kitty btop cava rofi thunar kvantum bat hyprland hyprpanel ags
  ];

  # Symlink files and directories
  home.file = {
    ".icons" = { source = "${dotfilesPath}/.icons"; recursive = true; };
    ".local/bin" = { source = "${dotfilesPath}/.local/bin"; recursive = true; };
    ".config/ags" = { source = "${dotfilesPath}/.config/ags"; recursive = true; };
  };

  xdg.configFile = {
    "hypr" = { source = "${dotfilesPath}/.config/hypr"; recursive = true; };
    "fish" = { source = "${dotfilesPath}/.config/fish"; recursive = true; };
    "kitty" = { source = "${dotfilesPath}/.config/kitty"; recursive = true; };
    "btop" = { source = "${dotfilesPath}/.config/btop"; recursive = true; };
    "cava" = { source = "${dotfilesPath}/.config/cava"; recursive = true; };
    "helix" = { source = "${dotfilesPath}/.config/helix"; recursive = true; };
    "nushell" = { source = "${dotfilesPath}/.config/nushell"; recursive = true; };
    "rofi" = { source = "${dotfilesPath}/.config/rofi"; recursive = true; };
    "Kvantum" = { source = "${dotfilesPath}/.config/Kvantum"; recursive = true; };
    "qt5ct" = { source = "${dotfilesPath}/.config/qt5ct"; recursive = true; };
    "qt6ct" = { source = "${dotfilesPath}/.config/qt6ct"; recursive = true; };
    "Thunar" = { source = "${dotfilesPath}/.config/Thunar"; recursive = true; };
    "VSCodium" = { source = "${dotfilesPath}/.config/VSCodium"; recursive = true; };
    "yazelix" = { source = "${dotfilesPath}/.config/yazelix"; recursive = true; };
    "starship.toml" = { source = "${dotfilesPath}/.config/starship.toml"; };
    "gtk-2.0/gtkfilechooser.ini" = { source = "${dotfilesPath}/.config/gtk-2.0/gtkfilechooser.ini"; };
    "gtk-3.0/settings.ini" = { source = "${dotfilesPath}/.config/gtk-3.0/settings.ini"; };
    "gtk-3.0/gtk.css" = { source = "${dotfilesPath}/.config/gtk-3.0/gtk.css"; };
    "gtk-3.0/bookmarks" = { source = "${dotfilesPath}/.config/gtk-3.0/bookmarks"; };
    "gtk-4.0/gtk.css.bak" = { source = "${dotfilesPath}/.config/gtk-4.0/gtk.css.bak"; };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "helix";
    SHELL = "${pkgs.fish}/bin/fish";
    GTK_THEME = "Your-Installed-GTK-Theme";
    GTK_ICON_THEME = "YourIconThemeName";
    QT_STYLE_OVERRIDE = "kvantum";
    XDG_DATA_DIRS = "${homeDirectory}/.local/share:${config.xdg.dataHome}:${pkgs.gtk3}/share:${pkgs.gtk2}/share:${pkgs.qt5.qtbase}/share:${pkgs.qt6.qtbase}/share";
    XCURSOR_THEME = "YourCursorThemeName";
  };

  # Enable and configure programs
  programs = {
    fish = {
      enable = true;
      functions = builtins.listToAttrs (map (functionName: {
        name = functionName;
        value = builtins.readFile "${dotfilesPath}/.config/fish/functions/${functionName}.fish";
      }) [
        "cat" "dn" "dots" "fish_prompt" "la" "l" "mtp" "pls" "se" "server" "server-remote" "ssh-host" "update"
      ]);
      extraConfig = builtins.readFile "${dotfilesPath}/.config/fish/config.fish";
    };

    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile "${dotfilesPath}/.config/starship.toml");
    };

    kitty = {
      enable = true;
      extraConfig = builtins.readFile "${dotfilesPath}/.config/kitty/kitty.conf";
    };

    nushell = {
      enable = true;
      config = builtins.readFile "${dotfilesPath}/.config/nushell/config.nu";
      env = builtins.readFile "${dotfilesPath}/.config/nushell/env.nu";
    };

    helix = {
      enable = true;
      package = pkgs.helix;
      settings = {
        configFile = "${dotfilesPath}/.config/helix/config.toml";
      };
    };

    home-manager = { enable = true; };
  };

  # xsession configuration
  xsession = {
    enable = true;
    windowManager.hyprland.enable = true;
    desktopManager.default = "none";
  };

  # AGS systemd user service
  systemd.user.services.ags = {
    description = "AGS (HyprPanel)";
    after = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ags}/bin/ags";
      Restart = "on-failure";
    };
  };
}