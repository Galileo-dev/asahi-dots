{
  description = "Home Manager configuration for fionnbarrett";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpanel = {
      url = "github:l6174/HyprPanel";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprpanel, ... }:
    let
      # Specify your system architecture
      system = "aarch64-linux"; # Change to "x86_64-linux" if you're on x86_64

      # Overlays
      overlays = [
        hyprpanel.overlay
        # Removed home-manager.overlay, as it doesn't exist
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
      };

    in
    {
      # Development shell with specified packages
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.home-manager
          pkgs.git
          pkgs.hyprpanel
        ];
      };

      # Home Manager configuration
      homeConfigurations.fionnbarrett = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Import your home.nix configuration
        modules = [ ./home.nix ];
      };
    };
}

