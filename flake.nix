{
  description = "Nix & home-manager configuration for HyDE, an Arch Linux based Hyprland desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      ...
    }@inputs:
    let
      system = "aarch64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.apple-silicon-support.overlays.default
        ];
      };

      mkConfig = import ./lib/mkConfig.nix {
        inherit
          inputs
          pkgs
          system
          ;
      };

      defaultConfig = mkConfig {
        userConfig = import ./config.nix;
        extraInputs = { };
      };
    in
    {

      # Main config builder
      lib = {
        inherit mkConfig;
      };

      packages.${system} = {
        # generate-config script
        gen-config = pkgs.writeShellScriptBin "gen-config" (builtins.readFile ./lib/gen-config.sh);

        /*
          Packages below are default configurations
          These are used for testing
        */

        # NixOS activation packages
        hydenix = defaultConfig.nixosConfiguration.config.system.build.toplevel;

        # Home activation packages - you probably don't want to use these
        hm = defaultConfig.homeConfigurations.${defaultConfig.userConfig.username}.activationPackage;
        hm-generic =
          defaultConfig.homeConfigurations."${defaultConfig.userConfig.username}-generic".activationPackage;

      };

      devShells.${system}.default = import ./lib/dev-shell.nix { inherit pkgs; };
    };
}
