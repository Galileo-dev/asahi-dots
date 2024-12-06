{
  inputs,
  pkgs,
  system,
  ...
}:
{
  userConfig,
  extraInputs ? { },
}:
rec {
  commonArgs = {
    inherit pkgs system userConfig;
    inputs = inputs // extraInputs;
  };

  nixosConfiguration = import ../hosts/nixos-asahi { inherit commonArgs; };

  inherit userConfig;

  homeConfigurations = {

    # Home configuration for nix
    "${userConfig.username}" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../hosts/nixos-asahi/home.nix
        inputs.nix-index-database.hmModules.nix-index
      ] ++ userConfig.homeModules;
      extraSpecialArgs = {
        inherit userConfig;
        inherit inputs;
      };
    };

    # Generic home configuration for non-NixOS systems
    "${userConfig.username}-generic" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../hosts/nixos-asahi/home.nix
        inputs.nix-index-database.hmModules.nix-index
        {
          targets.genericLinux.enable = true;
        }
      ] ++ userConfig.homeModules;
      extraSpecialArgs = {
        inherit userConfig;
        inherit inputs;
      };
    };

  };
}
