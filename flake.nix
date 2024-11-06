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
      url = "github:Jas-SinghFSU/HyprPanel";
    };
  };

  outputs = { nixpkgs, home-manager, hyprpanel, ... } @ inputs:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";

        packages = [
          pkgs.home-manager
          pkgs.git
        ];
      };
      homeConfigurations = {
        "fionnbarrett" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
            nixpkgs.overlays = [
            (self: super: {
              hyprpanel = super.hyprpanel;
            })
          ];
          ];
        };
        programs.fish.enable = true;
        environment.shells = with pkgs; [ fish ];
        users.defaultUserShell = pkgs.fish;
      };
    };
}
