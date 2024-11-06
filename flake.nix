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
    hyprpanel = {
      url = "github:l6174/HyprPanel";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprpanel, ... } @ inputs:
    let
      system = "aarch64-linux"; # Set this to your actual system architecture.
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            gpu-screen-recorder = null; # Exclude gpu-screen-recorder
          })
          hyprpanel.overlay # Adding the hyprpanel overlay from inputs.
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";

        packages = [
          pkgs.home-manager
          pkgs.git
          pkgs.hyprpanel # Adding hyprpanel to the shell.
        ];
      };
      homeConfigurations = {
        "fionnbarrett" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
          ];
        };
        programs.fish.enable = true;
        environment.shells = with pkgs; [ fish ];
        users.defaultUserShell = pkgs.fish;
      };
    };
}
