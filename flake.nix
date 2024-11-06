{
  description = "Home Manager configuration for fionnbarrett";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    # Source of Nixpkgs and Home Manager.
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input for AGS (Another Gnome Shell)
    ags = {
      url = "github:Aylur/ags";
    };

    # Input for HyprPanel
    hyprpanel = {
      url = "github:l6174/HyprPanel";
    };
  };

  outputs = { self, nixpkgs, home-manager, ags, hyprpanel, ... } @ inputs:
    let
      system = "aarch64-linux";  # Use ARM64 architecture

      overlay = final: prev: {
        # Overlay to add or override packages
        ags = ags.packages.${system}.default;
        hyprpanel = hyprpanel.packages.${system}.default;
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
    in {
      homeManagerConfigurations = {
        fionnbarrett = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
            {
              home.stateVersion = "24.05";  # Adjust based on your Home Manager version
            }
          ];
        };
      };
    };
}
