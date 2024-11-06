{
  description = "Home Manager configuration for fionnbarrett";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add HyprPanel as an input with an overlay
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprpanel, ... } @ inputs:
    let
      system = "aarch64-linux";  # Adjust to your system architecture

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ hyprpanel.overlay ];  # Enable the HyprPanel overlay
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