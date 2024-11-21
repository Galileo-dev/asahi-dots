 nix --extra-experimental-features "nix-command flakes" run home-manager/release-24.05 -- init --switch $HOME/hyprdots --show-trace --impure
