fish_config theme choose "Rosé Pine"
fish_add_path --path $HOME/.local/bin
fish_add_path --path $HOME/bin
starship init fish | source
zoxide init --cmd cd fish | source
set -x BAT_THEME Catppuccin-mocha
set -x EDITOR nano
set -x fish_greeting ""
if status is-interactive
    # Commands to run in interactive sessions can go here
    # neofetch --ascii radioactive.txt --ascii_colors 2 1
    # neofetch
    nitch
end
if status --is-login    
    
end
fish_add_path /home/llawliet/.spicetify

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# rust
source "$HOME/.cargo/env.fish"

alias code 'nu -c "zellij -l welcome --config-dir ~/.config/yazelix/zellij options --layout-dir ~/.config/yazelix/zellij/layouts"'
